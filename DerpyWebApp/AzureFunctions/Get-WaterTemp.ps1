using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$StationID = $Request.Query.StationID

function Get-StationData {
    param (
        $StationID
    )

    $DataURI = "https://sdf.ndbc.noaa.gov/sos/server.php?request=GetObservation&service=SOS&version=1.0.0&offering=urn:ioos:station:wmo:$($StationID)&observedproperty=sea_water_temperature&responseformat=text/csv"
    ConvertFrom-Csv (Invoke-WebRequest -Uri $DataURI ).content
}

if ($StationID) {
    $status = [HttpStatusCode]::OK
    [float]$WaterTemp = (Get-StationData -StationID $StationID).'sea_water_temperature (C)'
    $WaterTemp = ($WaterTemp * 9/5) + 32
    $WaterTemp = [math]::Round($WaterTemp,2)
}
else {
    $status = [HttpStatusCode]::BadRequest
    $body = "Please pass a StationID on the query string."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $WaterTemp
})
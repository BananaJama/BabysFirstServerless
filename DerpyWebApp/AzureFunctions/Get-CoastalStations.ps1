# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"

$Stations = @('01500','01521','01522','01523','01524','01526','01531','01532','01534','01535','01536','01538','01909','01910','31201','41108','41109','41112','41113','41114','41116','41118','41140','41141','42094','42099','44088','44094','44096','44097','44099','44100','44172','46114','46211','46212','46213','46214','46215','46216','46217','46218','46219','46220','46221','46222','46223','46224','46225','46226','46227','46228','46229','46230','46231','46232','46234','46235','46236','46237','46238','46239','46240','46241','46242','46243','46244','46245','46247','46248','46249','46250','46251','46253','46254','46256','46257','46258','46262','48910','51200','52212','LJPC1')

function Get-StationNames {
    param (
        $Stations
    )
    
    foreach ($StationID in $Stations) {
        $GetDataURI = "https://sdf.ndbc.noaa.gov/sos/server.php?request=DescribeSensor&OutputFormat=text/xml;subtype=`"sensorML/1.0.1`"&procedure=urn:ioos:station:wmo:$($StationID)&service=SOS&version=1.0.0"
        [xml]$StationData = (Invoke-WebRequest -Uri $GetDataURI).Content

        if ('description' -in $StationData.SensorML.member.System.psobject.properties.name) {
            $StationName = ($StationData.SensorML.member.System.Description -split '-')[1].trim()

            $result = [PSCustomObject]@{
                id = $StationID
                name = $StationName
            }
    
            $result
        }
    }
}

$CoastalStations = Get-StationNames -Stations $Stations
$JsonOutput = $CoastalStations | ConvertTo-Json
Push-OutputBinding -Name outputBlob -Value $JsonOutput
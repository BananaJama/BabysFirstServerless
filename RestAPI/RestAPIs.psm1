# Using https://icanhazdadjoke.com/api for examples
# Requires no API key

function Get-RestApiExample {
    [CmdletBinding()]
    param (
       [Parameter(Mandatory)]
       [Int]
       $Example
    )
        
    $Examples = @('Invoke-RestMethod -Uri "https://icanhazdadjoke.com/"',
      '$headers = @{Accept="application/json"}',
      '$headers',
      'Invoke-RestMethod -Uri "https://icanhazdadjoke.com/" -Headers $headers',
      'Invoke-RestMethod -Uri "https://icanhazdadjoke.com/" -Headers $headers | gm',
      'Invoke-RestMethod -Uri "https://icanhazdadjoke.com/" -Headers $headers | Select-Object Joke')

   $Examples[$Example]
}

Export-ModuleMember -Function Demo-RestAPI
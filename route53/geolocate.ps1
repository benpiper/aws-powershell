
$dnsservers = Get-Content -Path nameservers.txt

foreach ($dnsserver in $dnsservers) {
    $response = (Invoke-WebRequest http://api.db-ip.com/v2/free/$dnsserver).Content | ConvertFrom-Json
    $response.stateProv
}
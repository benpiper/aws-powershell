$zonename = "benpiper.host."
$isprivate = $false

$zone = Get-R53HostedZones | where { $_.name -like $zonename -and $_.Config.PrivateZone -like $isprivate}

# Get list of record sets
$rrsetlist = Get-R53ResourceRecordSet -HostedZoneId $zone.Id

# Display resource record sets
$rrsetlist.ResourceRecordSets | Format-Table

# Get NS resource record set
$nsrr = $rrsetlist.ResourceRecordSets | where { $_.type -like "NS" }

# Display NS resource record set
$nsrr | Format-Table

New-TimeSpan -Seconds 172800 | Format-Table

# Display NS resource records
$nsrr.ResourceRecords

# Get SOA resource record set
$soarr = $rrsetlist.ResourceRecordSets | where { $_.type -like "SOA" }

# Display SOA resource record
$soarr.ResourceRecords

New-TimeSpan -Seconds 1209600 | Format-Table
New-TimeSpan -Seconds 86400 | Format-Table

# Remove hosted zone
Remove-R53HostedZone -id $zone.Id -Force

# Remove reusable delegation set

Remove-R53ReusableDelegationSet -id $delegationset.DelegationSet.Id -Force
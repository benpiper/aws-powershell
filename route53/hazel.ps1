$zonename = "benpiper.host."

# Create reusable delegation set
$delegationset = New-R53ReusableDelegationSet -CallerReference (Get-Random)

# View nameservers
$delegationset.DelegationSet | Format-List

# Get delegation set ID
$dsid = $delegationset.DelegationSet.Id

# Create hosted zone
$zone = New-R53HostedZone -Name $zonename -DelegationSetId $dsid -CallerReference (Get-Random)

# View zone properties
$zone.HostedZone

# Check SOA record
nslookup -type=soa benpiper.host. 198.6.1.5

# Check NS records. The server volunteers A records.
nslookup -type=ns benpiper.host. 198.6.1.5

# The server volunteers NS, A, and AAAA records
nslookup -type=soa benpiper.host. 216.52.126.33

# Get list of record sets
$rrsetlist = Get-R53ResourceRecordSet -HostedZoneId $zone.HostedZone.Id

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
Remove-R53HostedZone -id $zone.HostedZone.Id -Force

# Remove reusable delegation set

Remove-R53ReusableDelegationSet -id $delegationset.DelegationSet.Id -Force
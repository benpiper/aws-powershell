# reusable-delegation-set.ps1

#Import AWS credentials
. ./credentials.ps1

# Create reusable delegation set
$delegationset = New-R53ReusableDelegationSet -CallerReference (Get-Random)
Get-R53ReusableDelegationSetList

# View nameservers only
$delegationset.DelegationSet.NameServers

# Get delegation set ID
$dsid = $delegationset.DelegationSet.Id

# Configure zone name
$zonename = "benpiper.host."

# Create public hosted zone
$zone = New-R53HostedZone -Name $zonename -DelegationSetId $dsid -CallerReference (Get-Random)

# View zone properties
$zone.HostedZone

# View all records
$firstns = $zone.DelegationSet.NameServers[0]
$firstns
nslookup -type=any $zonename $firstns

# View nameservers only
$zone.DelegationSet.NameServers
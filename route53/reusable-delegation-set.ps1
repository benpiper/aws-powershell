# reusable-delegation-set.ps1

#Import AWS credentials
. ./credentials.ps1

# Create reusable delegation set
$delegationset = New-R53ReusableDelegationSet -CallerReference (Get-Random)
Get-R53ReusableDelegationSets

# View nameservers
$delegationset.DelegationSet | Format-List

# Get delegation set ID
$dsid = $delegationset.DelegationSet.Id

# Configure zone name
$zonename = "benpiper.host."

# Create public hosted zone
$zone = New-R53HostedZone -Name $zonename -DelegationSetId $dsid -CallerReference (Get-Random)

# View zone properties
$zone.HostedZone

# Check SOA record
nslookup -type=soa $zonename 198.6.1.5

# Check NS records. The server volunteers A records.
nslookup -type=ns $zonename 198.6.1.5

# The server volunteers NS, A, and AAAA records
nslookup -type=soa $zonename 216.52.126.33
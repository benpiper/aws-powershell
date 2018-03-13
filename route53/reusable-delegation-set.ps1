# reusable-delegation-set.ps1

#Import AWS credentials
. ./credentials.ps1
#The credentials file should contain the following two variables:
# $AWSAccessKey="" # Your access key
# $AWSSecretKey="" # Your secret key

# Set AWS credentials and region
$AWSProfileName="aws-networking-deep-dive-route-53-dns"

# Set AWS credentials and store them
Set-AWSCredential -AccessKey $AWSAccessKey -SecretKey $AWSSecretKey -StoreAs $AWSProfileName

# Load the credentials for this session
Set-AWSCredential -ProfileName $AWSProfileName
# Create a reusable delegation set and create a public hosted zone that uses it

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
nslookup -type=soa $zonename 198.6.1.5

# Check NS records. The server volunteers A records.
nslookup -type=ns $zonename 198.6.1.5

# The server volunteers NS, A, and AAAA records
nslookup -type=soa $zonename 216.52.126.33
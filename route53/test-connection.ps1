# test-connection.ps1

# Set AWS credentials and region
$AWSRegion = "us-east-1"

$AWSProfileName="aws-networking-deep-dive-route-53-dns"

# Load the credentials for this session
Set-AWSCredential -ProfileName $AWSProfileName

# Test functionality
if ((Get-EC2Vpc -Region $AWSRegion).count -ge 1) { Write-Host -ForegroundColor yellow Connectivity to AWS established! }
# test-connection.ps1

#Import AWS credentials
. ./credentials.ps1

# Set AWS credentials and region
$AWSRegion = "us-east-1"

# Test functionality
if ((Get-EC2Vpc -Region $AWSRegion).count -ge 1) { Write-Host -ForegroundColor yellow Connectivity to AWS established! }
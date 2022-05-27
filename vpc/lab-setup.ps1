# Lab-Setup.ps1

#Import AWS credentials
. ./credentials.ps1
#The credentials file should contain the following two variables:
# $AWSAccessKey="AKIAYVP4CIPPKKEX3NUX" # Replace with your access key
# $AWSSecretKey="mpCNyY4qm3YvBH1f8WQjVQQ6j1Y7kiRkgvl4bbr+" # Replace with your secret key

# Set AWS credentials and region
$AWSProfileName="aws-networking-deep-dive-vpc"
$AWSRegion = "us-east-1"

# Set AWS credentials and store them
Set-AWSCredential -AccessKey $AWSAccessKey -SecretKey $AWSSecretKey -StoreAs $AWSProfileName

# Load the credentials for this session
Set-AWSCredential -ProfileName $AWSProfileName

# Set the default region
Set-DefaultAWSRegion -Region $AWSRegion
Get-DefaultAWSRegion

# Test functionality
if ((Get-EC2Vpc).count -ge 1) { Write-Host Connectivity to AWS established! }

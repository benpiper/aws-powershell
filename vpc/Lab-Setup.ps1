# Lab-Setup.ps1

# Install and load the AWS PowerShell module
. ./Load-AWSPowerShell.ps1
Load-AWSPowerShell

# Set AWS credentials and region
$AWSAccessKey="AKIAJTC5OJWSJZDZZ3XA"
$AWSSecretKey="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"
$AWSProfileName="ps-aws-networking-deep-dive"
$AWSRegion = "us-east-1"

# Set AWS credentials and store them
Set-AWSCredential -AccessKey $AWSAccessKey -SecretKey $AWSSecretKey -StoreAs $AWSProfileName

# Then load them from the store
Set-AWSCredential -ProfileName $AWSProfileName

# Set the default region
Set-DefaultAWSRegion -Region $AWSRegion
Get-DefaultAWSRegion

# Test functionality
Get-EC2Vpc

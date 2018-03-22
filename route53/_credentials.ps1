#Replace the values below and save this file as credentials.ps1
$AWSAccessKey="replace with your access key" # Replace with your access key
$AWSSecretKey="replace with your secret key" # Replace with your secret key

# Set AWS credentials and region
$AWSProfileName="aws-networking-deep-dive-route-53-dns"

# Set AWS credentials and store them
Set-AWSCredential -AccessKey $AWSAccessKey -SecretKey $AWSSecretKey -StoreAs $AWSProfileName

# Load the credentials for this session
Set-AWSCredential -ProfileName $AWSProfileName
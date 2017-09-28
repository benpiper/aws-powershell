Write-Warning "This script will modify your AWS account!"
Pause

### OVERVIEW
## Destroy VPC and everything in it!

$vpcname = "web-vpc"
$subnetname = "web-pub"
$routetable = "web-pub"
$igwname = "web-igw"

$subnet = Get-EC2Subnet -Filter @{Name="tag-value";Values="$subnetname"}
Remove-EC2Subnet -SubnetId $subnet.subnetId -Force

$vpc = Get-EC2Vpc -Filter @{Name="tag-value";Values="$vpcname"}

$igw = Get-EC2InternetGateway -Filter @{Name="tag-value";Values="$igwname"}
Dismount-EC2InternetGateway -InternetGatewayId $igw.InternetGatewayId -VpcId $vpc.VpcId
Remove-EC2InternetGateway -InternetGatewayId $igw.InternetGatewayId -Force

#Remove security groups

Remove-EC2VPC -VpcId $vpc.VpcId -Force
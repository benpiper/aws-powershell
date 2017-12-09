# Lab-Setup.ps1

#Import AWS credentials
. ./credentials.ps1
#The credentials file should contain the following two variables:
# $AWSAccessKey="" # Your access key
# $AWSSecretKey="" # Your secret key

# Set AWS credentials and region
$AWSProfileName="aws-networking-deep-dive-elb"
$AWSRegion = "us-east-1"
# Set your IP subnet for SSH access
$myIP = "24.96.154.171/32"
# Set the AMI image (change this if you change the region)
$ami = "ami-c710e7bd" # aws-elasticbeanstalk-amzn-2017.03.1.x86_64-ecs-hvm-201709251832
# Set the name of your SSH keypair
$keyname = "ccnetkeypair"

# Set AWS credentials and store them
Set-AWSCredential -AccessKey $AWSAccessKey -SecretKey $AWSSecretKey -StoreAs $AWSProfileName

# Load the credentials for this session
Set-AWSCredential -ProfileName $AWSProfileName

# Set the default region
Set-DefaultAWSRegion -Region $AWSRegion
Get-DefaultAWSRegion

# Test functionality
if ((Get-EC2Vpc).count -ge 1) { Write-Host Connectivity to AWS established! }

# Import VPC helper functions
. ../vpc/vpc-functions.ps1

# Create webapp-vpc
$vpc = Create-VPC -vpcCidr "172.31.0.0/16" -vpcName "webapp-vpc"
Edit-EC2VpcAttribute -VpcId $vpc.VpcId -EnableDnsHostnames $true

# Create web tier subnets
$web1a = Create-Subnet -vpc $vpc -zone "us-east-1a" -name "web-1a" -IPv4Cidr "172.31.1.0/24" -IPv6prefix "11"
$web1b = Create-Subnet -vpc $vpc -zone "us-east-1b" -name "web-1b" -IPv4Cidr "172.31.2.0/24" -IPv6prefix "12"

# Create app tier subnets
$app1a = Create-Subnet -vpc $vpc -zone "us-east-1a" -name "app-1a" -IPv4Cidr "172.31.101.0/24" -IPv6prefix "01"
$app1b = Create-Subnet -vpc $vpc -zone "us-east-1b" -name "app-1b" -IPv4Cidr "172.31.102.0/24" -IPv6prefix "02"

# Create internet gateway
$igw = Create-InternetGateway -vpc $vpc -name "webapp-igw"

# Create route table and associate with subnets
$rt = Create-RouteTable -vpc $vpc -name "webapp-rt"
Register-EC2RouteTable -RouteTableId $rt.RouteTableId -SubnetId $web1a.SubnetId
Register-EC2RouteTable -RouteTableId $rt.RouteTableId -SubnetId $web1b.SubnetId
Register-EC2RouteTable -RouteTableId $rt.RouteTableId -SubnetId $app1a.SubnetId
Register-EC2RouteTable -RouteTableId $rt.RouteTableId -SubnetId $app1b.SubnetId

# Add default routes
New-EC2Route -DestinationCidrBlock "0.0.0.0/0" -GatewayId $igw.InternetGatewayId -RouteTableId $rt.RouteTableId
New-EC2Route -DestinationIpv6CidrBlock "::0/0" -GatewayId $igw.InternetGatewayId -RouteTableId $rt.RouteTableId

#Create security groups
$websg = New-EC2SecurityGroup -VpcId $vpc.VpcId -GroupName "web-sg" -GroupDescription "web-sg"
$appsg = New-EC2SecurityGroup -VpcId $vpc.VpcId -GroupName "app-sg" -GroupDescription "app-sg"
$dbsg = New-EC2SecurityGroup -VpcId $vpc.VpcId -GroupName "db-sg" -GroupDescription "db-sg"

#Create IPpermissions for public http and https
$httpip = new-object Amazon.EC2.Model.IpPermission
$httpip.IpProtocol = "tcp"
$httpip.FromPort = 80
$httpip.ToPort = 80
$httpip.IpRanges.Add("0.0.0.0/0")

$httpsip = new-object Amazon.EC2.Model.IpPermission
$httpsip.IpProtocol = "tcp"
$httpsip.FromPort = 443
$httpsip.ToPort = 443
$httpsip.IpRanges.Add("0.0.0.0/0")

$sship = new-object Amazon.EC2.Model.IpPermission
$sship.IpProtocol = "tcp"
$sship.FromPort = 22
$sship.ToPort = 22
$sship.IpRanges.Add($myIP)

$tcp81ip = new-object Amazon.EC2.Model.IpPermission
$tcp81ip.IpProtocol = "tcp"
$tcp81ip.FromPort = 81
$tcp81ip.ToPort = 81
$tcp81ip.IpRanges.Add("172.31.0.0/16")

#Create IPpermissions for app tier
#Create IPpermissions for public http and https
$appip = new-object Amazon.EC2.Model.IpPermission
$appip.IpProtocol = "tcp"
$appip.FromPort = 8080
$appip.ToPort = 8080
$appip.IpRanges.Add("172.31.1.0/24")
$appip.IpRanges.Add("172.31.2.0/24")

$appsip = new-object Amazon.EC2.Model.IpPermission
$appsip.IpProtocol = "tcp"
$appsip.FromPort = 8443
$appsip.ToPort = 8443
$appsip.IpRanges.Add("172.31.1.0/24")
$appsip.IpRanges.Add("172.31.2.0/24")

#Create IPpermissions for DB tier
$dbip = new-object Amazon.EC2.Model.IpPermission
$dbip.IpProtocol = "tcp"
$dbip.FromPort = 3306
$dbip.ToPort = 3306
$dbip.IpRanges.Add("172.31.101.0/24")
$dbip.IpRanges.Add("172.31.102.0/24")

Grant-EC2SecurityGroupIngress -GroupId $websg -IpPermissions @( $httpip, $httpsip, $tcp81ip, $sship )
Grant-EC2SecurityGroupIngress -GroupId $appsg -IpPermissions @( $appip, $appsip, $sship )
Grant-EC2SecurityGroupIngress -GroupId $dbsg -IpPermissions @( $dbip, $sship )

# Create web instances
$itype = "t2.nano"

$web1 = New-EC2Instance -ImageId $ami -KeyName $keyname -InstanceType $itype -SubnetId $web1a.SubnetId -SecurityGroupId $websg -AssociatePublicIp $true -PrivateIpAddress "172.31.1.21"
$web2 = New-EC2Instance -ImageId $ami -KeyName $keyname -InstanceType $itype -SubnetId $web1b.SubnetId -SecurityGroupId $websg -AssociatePublicIp $true -PrivateIpAddress "172.31.2.22"
$web3 = New-EC2Instance -ImageId $ami -KeyName $keyname -InstanceType $itype -SubnetId $web1b.SubnetId -SecurityGroupId $websg -AssociatePublicIp $true -PrivateIpAddress "172.31.2.23"

New-NameTag -name "web1" -resourceID $web1.Instances.InstanceId
New-NameTag -name "web2" -resourceID $web2.Instances.InstanceId
New-NameTag -name "web3" -resourceID $web3.Instances.InstanceId

# Create application server instances
$app1 = New-EC2Instance -ImageId $ami -KeyName $keyname -InstanceType $itype -SubnetId $app1a.SubnetId -SecurityGroupId $appsg -AssociatePublicIp $true -PrivateIpAddress "172.31.101.21"
$app2 = New-EC2Instance -ImageId $ami -KeyName $keyname -InstanceType $itype -SubnetId $app1b.SubnetId -SecurityGroupId $appsg -AssociatePublicIp $true -PrivateIpAddress "172.31.102.22"
$app3 = New-EC2Instance -ImageId $ami -KeyName $keyname -InstanceType $itype -SubnetId $app1b.SubnetId -SecurityGroupId $appsg -AssociatePublicIp $true -PrivateIpAddress "172.31.102.23"

New-NameTag -name "app1" -resourceID $app1.Instances.InstanceId
New-NameTag -name "app2" -resourceID $app2.Instances.InstanceId
New-NameTag -name "app3" -resourceID $app3.Instances.InstanceId

# Create db instance
$db = New-EC2Instance -ImageId $ami -KeyName $keyname -InstanceType $itype -SubnetId $app1a.SubnetId -SecurityGroupId $dbsg -AssociatePublicIp $true -PrivateIpAddress "172.31.101.99"
New-NameTag -name "db" -resourceID $db.Instances.InstanceId

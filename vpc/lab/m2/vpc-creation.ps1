Write-Warning "This script will modify your AWS account!"
Pause

### OVERVIEW
## Create web VPC
## Create web-pub subnet for internet connectivity
## Create internet gateway
## Create web server instance


##VPC CREATION SECTION
#Module name: Creating Secure Virtual Private Clouds (VPCs)
#Topics covered: VPC creation, ipv4 and ipv6 subnet creation, ipv4 routing
#tables, internet gateways and default routes, adding secondary network
#interfaces, launching instances, security groups
#Scenario: Create an internet facing web server instance


## CREATE WEB VPC

$vpcCidr = "10.1.0.0/16"
$vpc = New-EC2Vpc -CidrBlock $vpcCidr -AmazonProvidedIpv6CidrBlock $true

# Verify
Get-EC2Vpc -VpcId $vpc.VpcId

$tag = New-Object Amazon.EC2.Model.Tag
$tag.Key = "Name"
$tag.Value = "web-vpc"
$tag

# Attach the tag to the VPC
New-EC2Tag -Tag $tag -Resource $vpc.VpcId

#Refresh $vpc variable
$vpc = Get-EC2Vpc -VpcId $vpc.VpcId
$vpc
#View Name tag
$vpc | Select-Object -ExpandProperty Tags


## CREATE PUBLIC SUBNET IN WEB-VPC
#Create public IPv4 and IPv6 subnets for the webtier VPC

$zone = "us-east-1a"
$IPv4Cidr = "10.1.254.0/24"

#The IPv4 CIDR must be a subnet of the VPC's CIDR block
$vpc.CidrBlock

#Create the subnet with only the IPv4 CIDR
$subnet = New-EC2Subnet -AvailabilityZone $zone -VpcId $vpc.VpcId -CidrBlock $IPv4Cidr

#Verify
Get-EC2Subnet -SubnetId $subnet.SubnetId

#Assign IPv6 subnet to AWS subnet
$IPv6prefix = "00"

#The IPv6 prefix will replace the last two 00's in the CIDR
$vpc.Ipv6CidrBlockAssociationSet

#VPC CIDR prefix length is /56 by default, and AWS requires /64 for a subnet
# Remove the /56 ("Split")
# Replace the rightmost "00" with the subnet prefix ("Replace")
# Append a /64
$IPv6Cidr = ($vpc.Ipv6CidrBlockAssociationSet).IPv6CidrBlock
$IPv6subnet = ($IPv6Cidr.Split("/")[0]).Replace("00::","$IPv6prefix::") + "/64"
$IPv6subnet

#Add IPv6 CIDR block association
Register-EC2SubnetCidrBlock -SubnetId $subnet.SubnetId -Ipv6CidrBlock $IPv6subnet

#Verify
Get-EC2Subnet -SubnetId $subnet.SubnetId | select-object -ExpandProperty Ipv6CidrBlockAssociationSet

#Tag subnet with a friendly Name
$tag = New-Object Amazon.EC2.Model.Tag
$tag.Key = "Name"
$tag.Value = "web-pub"
$tag

# Attach the tag to the VPC
New-EC2Tag -Tag $tag -Resource $subnet.SubnetId

#Verify
Get-EC2Subnet -SubnetId $subnet.SubnetId

#Create web-vpc Internet gateway
$igwName = "web-igw"
$igw = New-EC2InternetGateway
Add-EC2InternetGateway -InternetGatewayId $igw.InternetGatewayId -VpcId $vpc.VpcId

$tag = New-Object Amazon.EC2.Model.Tag
$tag.Key = "Name"
$tag.Value = "$igwName"
$tag
New-EC2Tag -Tag $tag -Resource $igw.InternetGatewayId

#Verify
$igw

#Create a new route table for webtier-public subnet
$routeTableName = "web-pub"
#$routeTable = Create-RouteTable -vpc $vpc -routeTableName $routeTableName -subnet $subnet
$routeTable = New-EC2RouteTable -VpcId $vpc.VpcId

#associate subnet with route table
Register-EC2RouteTable -RouteTableId $routeTable.RouteTableId -SubnetId $subnet.SubnetId

#Verify
$routetable
$routetable.Associations
$routetable
$routetable.Routes.Count
$routetable.Routes | ft -Property DestinationCidrBlock,DestinationIpv6CidrBlock,GatewayId,Origin

#Tag and verify

#Create a default IPv4 route and add to route table
New-EC2Route -DestinationCidrBlock "0.0.0.0/0" -GatewayId $igw.InternetGatewayId -RouteTableId $routeTable.RouteTableId

#Verify the route
$routeTable = Get-EC2RouteTable -RouteTableId $routeTable.RouteTableId
$routetable.Routes | ft -Property DestinationCidrBlock,DestinationIpv6CidrBlock,GatewayId,Origin

#Create security group
$sgname = "web-pub-sg"
$sg = New-EC2SecurityGroup -VpcId $vpc.VpcId -GroupName $sgname -GroupDescription $sgname
Get-EC2SecurityGroup -GroupId $sg

#Create IPpermissions objects to allow ssh, http, https
$ip1 = new-object Amazon.EC2.Model.IpPermission
$ip1.IpProtocol = "tcp"
$ip1.FromPort = 22
$ip1.ToPort = 22
$ip1.IpRanges.Add("0.0.0.0/0")

$ip2 = new-object Amazon.EC2.Model.IpPermission
$ip2.IpProtocol = "tcp"
$ip2.FromPort = 80
$ip2.ToPort = 80
$ip2.IpRanges.Add("0.0.0.0/0")

Grant-EC2SecurityGroupIngress -GroupId $sg -IpPermissions @( $ip1, $ip2 )
Get-EC2SecurityGroup -GroupId $sg

#Create elastic network interface
$primary = "10.1.254.10"
$desc = "www1 eth0"
$eni = New-EC2NetworkInterface -SubnetId $subnet.SubnetId -Description $desc -PrivateIPAddress $primary -Group $sg

#Allocate elastic IP

$eip = New-EC2Address

#Associate elastic IP with www1 eth0 ENI
Register-EC2Address -AllocationId $eip.AllocationId -NetworkInterfaceId $eni.NetworkInterfaceId

#Create www1 instance (ami-3883a55d t2.micro)
$ami = "ami-d61027ad"
$keyname = "ccnetkeypair"
$itype = "t2.micro"

$eth0 = new-object Amazon.EC2.Model.InstanceNetworkInterfaceSpecification
$eth0.NetworkInterfaceId = $eni.NetworkInterfaceId
$eth0.DeviceIndex = 0
$eth0.DeleteOnTermination = $false
$www1 = New-EC2Instance -ImageId $ami -KeyName $keyname -InstanceType $itype -NetworkInterface $eth0

#Test SSH


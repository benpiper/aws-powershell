Write-Warning "This script will modify your AWS account!"
Pause

### OVERVIEW
## Create webtier VPC
## Create web-public subnet for internet connectivity
## Create web-private subnet for backend database connectivity
## Create internet gateway
## Create web server instance


##VPC CREATION SECTION
#Module name: Creating Secure Virtual Private Clouds (VPCs)
#Topics covered: VPC creation, ipv4 and ipv6 subnet creation, ipv4 routing
#tables, internet gateways and default routes, adding secondary network
#interfaces, launching instances, security groups
#Scenario: Create an internet facing web server instance with two virtual NICs,
#one facing the public internet and another on a private subnet to connect to
#a database server in a different VPC that we’ll create later. Must be IPv6 ready.


## CREATE WEBTIER VPC

$vpcCidr = "10.3.0.0/16"
$vpcName = "webtier"
$vpc = New-EC2Vpc -CidrBlock $vpcCidr -AmazonProvidedIpv6CidrBlock $true

# Verify
Get-EC2Vpc -VpcId $vpc.VpcId

$tag = New-Object Amazon.EC2.Model.Tag
$tag.Key = "Name"
$tag.Value = "webtier"
$tag

# Attach the tag to the VPC
New-EC2Tag -Tag $tag -Resource $vpc.VpcId

Refresh $vpc variable
$vpc = Get-EC2Vpc -VpcId $vpc.VpcId
$vpc
#View Name tag
$vpc | Select-Object -ExpandProperty Tags


## CREATE PUBLIC SUBNETS IN WEBTIER VPC
#Create public IPv4 and IPv6 subnets for the webtier VPC

$zone = "us-east-1a"
$subnetName = "web-public"
$IPv4Cidr = "10.3.1.0/24"

#The IPv4 CIDR must be a subnet of the VPC's CIDR block
$vpc.CidrBlock

#Create the subnet with only the IPv4 CIDR
$subnet = New-EC2Subnet -AvailabilityZone $zone -VpcId $vpc.VpcId -CidrBlock $IPv4Cidr

#Verify
Get-EC2Subnet -SubnetId $subnet.SubnetId

#IPv6
$IPv6prefix = "31"

#The IPv6 prefix will replace the last two 00's in the CIDR
$vpc.Ipv6CidrBlockAssociationSet

#CIDR prefix length is /56 by default, and AWS requires /64 for a subnet
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
$tag.Value = "web-public"
$tag

# Attach the tag to the VPC
New-EC2Tag -Tag $tag -Resource $subnet.SubnetId

#Verify
Get-EC2Subnet -SubnetId $subnet.SubnetId



#Create webtier VPC Internet gateway
$igwName = "webtier-inet-gw"
$igw = Create-InternetGateway -vpc $vpc -name $igwName

#Verify
$igw

#Tag the IGW
#Verify

#Create a new route table for webtier-public subnet
$routeTableName = "webtier-public-routes"
$routeTable = Create-RouteTable -vpc $vpc -routeTableName $routeTableName -subnet $subnet

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

#Associate subnet with route table
#Register-EC2RouteTable

#Create security group

#Create IPpermissions objects to allow ssh, http, https

#Create elastic network interface for public with static IP

#Tag as www1-public

#Allocate elastic IP and tag

#Associate elastic IP with eth1 ENI (register-ec2address)

#Create elastic network interface for private subnet with private IP

#Tag as www1-private

#Create www1 instance (ami-3883a55d t2.micro)

#Test SSH and HTTP connectivity. Verify database connection error shows.

# Create dbtier VPC

## Note: Create www2 using PoSh, then move the EIP to it. When would you move an ENI from one instance to another?
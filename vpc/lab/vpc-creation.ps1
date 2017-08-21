# Load functions
. ./VPC-Functions.ps1

#### OVERVIEW
### Create webtier VPC
### Create web1a-public-subnet for internet connectivity
### Create web1a-private-subnet for private connectivity


##VPC CREATION SECTION
#Module name: Creating Secure Virtual Private Clouds (VPCs)
#Topics covered: VPC creation, ipv4 and ipv6 subnet creation, ipv4 routing tables, internet gateways and default routes, adding secondary network interfaces, launching instances, security groups
#Scenario: Create an internet facing web server instance with two virtual NICs, one facing the public internet and another on a private subnet to connect to a database server in a different VPC that we’ll create later. Must be IPv6 ready.


## CREATE WEBTIER VPC

$vpcCidr = "10.3.0.0/16"
$vpcName = "webtier"
$vpc = Create-VPC -vpcCidr $vpcCidr -vpcName $vpcName

# Verify
$vpc
$vpc | Select-Object -ExpandProperty Tags
Get-ResourceByTagValue $vpcName
$vpc
$vpc.Ipv6CidrBlockAssociationSet

## CREATE PUBLIC SUBNETS IN WEBTIER VPC
#Create public IPv4 and IPv6 subnets for webtier VPC

$awszone = "us-east-1a"
$subnetName = "web1a-public-subnet"
$subnetIPv4Cidr = "10.3.91.0/24"
$subnetIPv6prefix = "91"

$subnet = Create-Subnet -vpc $vpc -zone $awszone -name $subnetName -IPv4Cidr $subnetIPv4Cidr -IPv6prefix $subnetIPv6prefix

#Verify
$subnet
$subnet.Ipv6CidrBlockAssociationSet
$vpc.Ipv6CidrBlockAssociationSet
Get-ResourceByTagValue


#Create webtier VPC Internet gateway
$igwName = "webtier-inet-gw"
$igw = Create-InternetGateway -vpc $vpc -name $igwName

#Verify
$igw
Get-ResourceByTagValue -keyvalue $igwName

#Create a new route table for webtier-public subnet
$routeTableName = "webtier-public-routes"
$routeTable = Create-RouteTable -vpc $vpc -routeTableName $routeTableName -subnet $subnet

#Verify
$routetable
$routetable.Associations
$routetable
$routetable.Routes.Count
$routetable.Routes | ft -Property DestinationCidrBlock,DestinationIpv6CidrBlock,GatewayId,Origin

#Create a default IPv4 route
New-EC2Route -DestinationCidrBlock "0.0.0.0/0" -GatewayId $igw.InternetGatewayId -RouteTableId $routeTable.RouteTableId

#Verify
$routeTable = Get-EC2RouteTable -RouteTableId $routeTable.RouteTableId
$routetable.Routes | ft -Property DestinationCidrBlock,DestinationIpv6CidrBlock,GatewayId,Origin

Get-ResourceByTagValue

#Associate subnet with route table

#Create public facing subnet for webtier
#Name: webtier-public, zone: us-east-2a, subnet: 172.27.10.0/24, ipv6: 10 (match third octet of IPv4 address)

#Create webtier IGW
#Name: webtier-igw

#Attach webtier IGW to webtier VPC
#Modify security group that got created, allow inbound ssh source 0.0.0.0/0

#Create route table for webtier-public subnet
#Name: webtier-public
#Associate subnet with route table

#Create key pair

#Create web1 instance
#Launch AWS AMI ami-3883a55d, t2.micro, vpc: webtier, subnet: webtier-public, auto-assign IPv4 and IPv6 addresses, only one nic for now, Name=web1, use webtier-sg security group

#Attempt to connect to instance. It won’t work because default route isn’t there.

#Add default route to webtier-public
#Connect again, username ec2-user

#Create new network interface
#name: web1-private, subnet: webtier-private
#Attach to web1 instance
#Verify that it shows up inside instance

#Demonstrate that traffic to internet can be sourced from eth0 (public) but not eth1 (private)
#Demonstrate IPv4 works but not IPv6
#Add default route for IPv6

#create dbtier VPC
aws ec2 create-vpc --cidr-block 172.28.0.0/16 --amazon-provided-ipv6-cidr-block
aws ec2 create-tags --resources  --tags Name=dbtier #Key Name must be capitalized!

#add name to (and if possible, rename) security group to dbtier-sg

#Create private subnet for dbtier
#Name: dbtier-private, zone: us-east-2a, subnet: 172.28.20.0/24, ipv6: 20 (match third octet of IPv4 address)

#Create route table for dbtier-private subnet
#Name: dbtier-private
#Associate subnet with route table
#Note that there’s no default route, and no route to any other subnets

#Bring up db1 instance
#Launch AWS AMI ami-3883a55d, t2.micro, vpc: dbtier, subnet: webtier-private, do NOT auto-assign public IPv4 address, DO auto-assign IPv6 address, only one nic for now, Name=db1, use dbtier-sg security group

#db1 has no public IP, but does have a private IP. How do we reach it? From web1!

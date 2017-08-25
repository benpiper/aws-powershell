
### OVERVIEW
## Create webtier VPC
## Create web-public subnet for internet connectivity
## Create web-private subnet for backend database connectivity
## Create internet gateway
## Create web server instance


##VPC CREATION SECTION
#Module name: Creating Secure Virtual Private Clouds (VPCs)
#Topics covered: VPC creation, ipv4 and ipv6 subnet creation, ipv4 routing tables, internet gateways and default routes, adding secondary network interfaces, launching instances, security groups
#Scenario: Create an internet facing web server instance with two virtual NICs, one facing the public internet and another on a private subnet to connect to a database server in a different VPC that we’ll create later. Must be IPv6 ready.


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

#Create webserver instance

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

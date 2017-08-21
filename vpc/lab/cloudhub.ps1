# Load functions
. ./VPC-Functions.ps1

##CLOUDHUB SECTION
#Name: Connecting Remote Sites Using CloudHub
#Topics covered: cloudhub, dynamic routing, route propagation
#Scenario: We want to connect Atlanta and Charleston offices via VPN using CloudHub thru the dbtier VPC.
#Create Charleston office VPC, cidr 10.29.0.0/16, use amazon provided IPv6 block
#Create subnet, name: Charleston-public, subnet: 10.29.1.0/24, IPv6 cidr 01
#Create internet gateway
#Create route table and add default gateway
#Associate route table with subnet
#Bring up cisco router AMI: auto assign public IPv4 and IPv6, one interface, create security group
#Create customer gateway, name: Charleston-router, BGP 65002
#Create VPN connection, name: Charleston-dbtier-vpn, use dbtier-vgw, dynamic routing
#Download cisco router config
#Change public IP to private IP (10.29.1.53)
#Establish IPsec tunnel
#On router, add loopback in 10.29.2.0/24 subnet. Advertise into BGP.
#Check dbtier-private route table to make sure routes propagated
#Add rule to dbtier-sg security group to allow 10.29.2.0/24. Test connectivity to dbtier.

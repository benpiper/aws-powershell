# Load functions
. ./VPC-Functions.ps1

##VPN SECTION
#Module name: Connecting On-premises Networks and Cloud Resources Using VPNs
#Topics covered: customer gateways, virtual gateways, vpn connections, dynamic routing, vpn monitoring, 
#Scenario: From Atlanta office we want to provide always-on VPN connectivity to the dbtier.

#Create Atlanta office VPC, cidr 192.168.0.0/16, use amazon provided IPv6 block
#Create subnet, name: Atlanta-public, subnet: 192.168.1.0/24, IPv6 cidr 01
#Create internet gateway
#Create route table and add default gateway
#Associate route table with subnet
#Bring up cisco router AMI: auto assign public IPv4 and IPv6, one interface, create security group
#Create customer gateway, name: Atlanta-router, BGP 65001
#Create virtual gateway, name: dbtier-vgw, attach to dbtier vpc
#Create VPN connection, name: Atlanta-dbtier-vpn, use dbtier-vgw, dynamic routing
#Download cisco router config
#Change public IP to private IP
#Establish IPsec tunnel
#On dbtier-private routing table, enable route propagation
#On router, add loopback (or real interface) in 192.168.2.0/24 subnet. Advertise into BGP.
#Add rule to dbtier-sg security group to allow 192.168.2.0/24. Test connectivity to dbtier.

# Load functions
. ./VPC-Functions.ps1

##IPV6 SECTION
#Module name: Configuring IPv6 Connectivity
#Topics covered: IPv6 addressing and routing
#Scenario: Ensure IPv6 connectivity to web server, and between web and db server over VPC peering.
#Configure webtier igw to allow ipv6 (already done?)
#Add IPv6 default route to webtier public subnet
#Ensure web1 instance has IPv6 addresses and routes
#Test connectivity
#Configure IPv6 connectivity between dbtier and webtier VPCs
#Configure egress only internet gateway for dbtier
#Add IPv6 default route to dbtier inet subnet

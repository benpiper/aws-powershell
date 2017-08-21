# Load functions
. ./VPC-Functions.ps1


##VPC PEERING SECTION
#Module name: Connecting Isolated Virtual Private Clouds Using VPC Peering
#Topics: vpc peering, jumpboxing, NAT gateways, elastic IPs
#Scenario: We need to connect webtier and dbtier VPCs, but ensure that public internet traffic can’t access the dbtier, and that dbtier can access internet on an as-needed basis.

#Create VPC peering between webtier and dbtier
#Name: webtier-dbtier
#Accept request

#On web1, start ping to db1’s private IP. It will fail.
#In dbtier-private route table, add route for the 172.27.20.0/24 subnet pointing to the peering connection.
#In webtier-private route table, add route for 172.28.20.0/24 subnet pointing to peering connection.

#In dbtier-sg, add rule to allow all traffic from 172.27.20.0/24

#Manually add route on web1 (better way to do this?)
sudo route add -net 172.28.20.0/24 gw 172.27.20.1 

#On web1, ping db1
#Drop pem file and ssh to db1
chmod 0600 benpiper-kp.pem
ssh ec2-user@172.28.20.78 -i benpiper-kp.pem
#On db1, demonstrate no internet access, no connectivity back to web1

#Create dbtier-inet subnet for dbtier outbound internet access
#Subnet: 172.28.10.0/24, us-east-2a, no IPv6 (because it doesn’t work for NAT gateway)

#Create dbtier-igw and attach to vpc

#Create route table, name: dbtier-inet
#Associate route table with subnet

#Create network interface, name: db1-inet
#Attach network interface

#Create subnet for NAT gateway
#Name: dbtier-nat, Subnet: 172.28.254.0/24

#Create route table called dbtier-nat
#Add default route pointing to IGW

#create NAT gateway for dbtier
#Select dbtier-inet subnet and allocate new elastic IP

#In route table dbtier-inet, add default route pointing to NAT gateway

#On db1, test by pinging from eth1 interface
#Demonstrate that traffic from eth0 doesn’t work
#TODO: Need to remove default route out eth0
curl ipinfo.io/ip --interface eth1

#Download web server and config on web1, and sql server and config on db1. Demonstrate full functionality.

#Delete NAT gateway (since it’s expensive)

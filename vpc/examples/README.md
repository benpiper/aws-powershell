Under construction

This is a set of related scripts you can use to create and configure VPCs to do anything a traditional network can do.

Follow the scripts in the following order:
[lab-setup.ps1](lab-setup.ps1)
[vpc-creation.ps1](vpc-creation.ps1)  
[vpc-peering.ps1](vpc-peering.ps1)  
[vpn.ps1](vpn.ps1)  
[cloudhub.ps1](cloudhub.ps1)  
[ipv6.ps1](ipv6.ps1)  

## [lab-setup.ps1](lab-setup.ps1)

Sets AWS credentials from credentials.ps1 file.
Sets AWS region to us-east-1.

## [vpc-creation.ps1](vpc-creation.ps1)

Creates two VPCs: one Internet-facing with two subnets (public and private), and another private with a NAT gateway.  
Creates route tables, routes, security groups, and instances.  

## [vpc-peering.ps1](vpc-peering.ps1)

Peers the preceding two VPCs together.  
Creates routes and security groups to control access between VPCs.  

## [vpn.ps1](vpn.ps1)

Creates VPN connections to non-AWS sites

## [cloudhub.ps1](cloudhub.ps1)

Connects two non-AWS sites via an AWS transit VPC

## [ipv6.ps1](ipv6.ps1)

Adds IPv6 addressing to the preceding architecture

# VPC Examples

A set of related scripts you can use to create and configure VPCs to do anything a traditional network can do.

## Getting Started

Follow the scripts in this order:

1. [lab-setup.ps1](../lab-setup.ps1) — Set credentials and region.
2. [vpc-creation.ps1](../lab/m2/vpc-creation.ps1) — Create VPCs, subnets, routes, security groups, and instances.

## Script Details

### [lab-setup.ps1](../lab-setup.ps1)

Sets AWS credentials from `credentials.ps1` file and sets the AWS region to us-east-1.

### [vpc-creation.ps1](../lab/m2/vpc-creation.ps1)

Creates two VPCs: one Internet-facing with two subnets (public and private), and another private with a NAT gateway. Creates route tables, routes, security groups, and instances.

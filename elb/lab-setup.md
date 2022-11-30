AWS Networking Deep Dive: Elastic Load Balancing (ELB)

## Automated lab setup
1. You will need the AWS PowerShell SDK installed and loaded. Run [install-awspowershell.ps1](/install-awspowershell.ps1) to take care of this, or do it manually.
2. Edit the file [_credentials.ps1](_credentials.ps1), replace the AWS secret key and access key with your own, and save the file as credentials.ps1
3. Edit [lab-setup.ps1](lab-setup.ps1) and modify the AWS region (default is us-east-1), SSH keypair name, and your public IP address accordingly.
4. Run [. ./lab-setup.ps1](lab-setup.ps1)

## Manual lab setup

VPC: webapp-vpc 172.31.0.0/16

Subnets:
web-1a 172.31.1.0/24
web-1b 172.31.2.0/24
App-1a 172.31.101.0/24
App-1b 172.31.102.0/24

Internet gateway: webapp-igw

Route tables:
webapp-rt (associate with all subnets):
Default IPv4 (0.0.0.0/0) and IPv6 (::0/0) routes with internet gateway as target

Security groups:
web-sg:
Inbound tcp/80,443 from 0.0.0.0/0
Inbound tcp/81 from 172.31.0.0/16
Inbound tcp/22 (SSH) from your IP

app-sg:
Inbound tcp/8080,8443 from 172.31.0.0/16
Inbound tcp/22 (SSH) from your IP

db-sg:
Inbound tcp/3306 (MySQL) from 172.31.101.0/24,172.31.102.0/24
Inbound tcp/22 (SSH) from your IP

Instances:
All instances use the AMI named "aws-elasticbeanstalk-amzn-2017.03.1.x86_64-ecs-hvm-201709251832" (AMI ID ami-c710e7bd in N. Virginia region)
Auto-assign all instances a public IP

Web tier:
Assign the web-sg security group to all
Name, subnet, IP
Web1, web-1a, 172.31.1.21
Web2, web-1b, 172.31.2.22
Web3, web-1b, 172.31.2.23

App tier:
Assign the app-sg security group to all
Name, subnet, IP
App1, app-1a, 172.31.101.21
App2, app-1b, 172.31.102.22
App3, app-1b, 172.31.102.23

Database tier:
Assign the db-sg security group
Name, subnet, IP
db, app-1a, 172.31.101.99

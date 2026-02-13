# ELB Lab Setup

## Automated Lab Setup

1. You will need the AWS PowerShell SDK installed and loaded. Run [install-awspowershell.ps1](/install-awspowershell.ps1) to take care of this, or do it manually.
2. Edit the file [_credentials.ps1](_credentials.ps1), replace the AWS secret key and access key with your own, and save the file as `credentials.ps1`.
3. Edit [lab-setup.ps1](lab-setup.ps1) and modify the AWS region (default is us-east-1), SSH keypair name, and your public IP address accordingly.
4. Run [lab-setup.ps1](lab-setup.ps1):
   ```powershell
   . ./lab-setup.ps1
   ```

> [!NOTE]
> A Terraform alternative is also available in the [terraform/](terraform/) directory.

## Manual Lab Setup

### VPC

- **Name**: webapp-vpc
- **CIDR**: 172.31.0.0/16

### Subnets

| Name   | CIDR            |
| ------ | --------------- |
| web-1a | 172.31.1.0/24   |
| web-1b | 172.31.2.0/24   |
| app-1a | 172.31.101.0/24 |
| app-1b | 172.31.102.0/24 |

### Internet Gateway

- **Name**: webapp-igw

### Route Tables

- **webapp-rt** (associate with all subnets):
  - Default IPv4 (0.0.0.0/0) and IPv6 (::0/0) routes with internet gateway as target.

### Security Groups

**web-sg**:
- Inbound TCP/80,443 from 0.0.0.0/0
- Inbound TCP/81 from 172.31.0.0/16
- Inbound TCP/22 (SSH) from your IP

**app-sg**:
- Inbound TCP/8080,8443 from 172.31.0.0/16
- Inbound TCP/22 (SSH) from your IP

**db-sg**:
- Inbound TCP/3306 (MySQL) from 172.31.101.0/24, 172.31.102.0/24
- Inbound TCP/22 (SSH) from your IP

### Instances

> [!WARNING]
> The AMI referenced below (`ami-c710e7bd`, from 2017) may be deprecated in your region. Verify AMI availability before launching instances, or substitute a current Amazon Linux AMI.

All instances use the AMI named `aws-elasticbeanstalk-amzn-2017.03.1.x86_64-ecs-hvm-201709251832` (AMI ID `ami-c710e7bd` in N. Virginia region). Auto-assign all instances a public IP.

**Web tier** (assign **web-sg**):

| Name | Subnet | IP          |
| ---- | ------ | ----------- |
| Web1 | web-1a | 172.31.1.21 |
| Web2 | web-1b | 172.31.2.22 |
| Web3 | web-1b | 172.31.2.23 |

**App tier** (assign **app-sg**):

| Name | Subnet | IP            |
| ---- | ------ | ------------- |
| App1 | app-1a | 172.31.101.21 |
| App2 | app-1b | 172.31.102.22 |
| App3 | app-1b | 172.31.102.23 |

**Database tier** (assign **db-sg**):

| Name | Subnet | IP            |
| ---- | ------ | ------------- |
| db   | app-1a | 172.31.101.99 |

aws-powershell

## Cross-platform PowerShell scripts for doing cool things with AWS VPC, ELB, and Route 53.
### PowerShell Core: it's not just for Windows anymore!

#### AWS PowerShell SDK setup:
If you don't already have the AWS PowerShell SDK installed, [install-awspowershell.ps1](install-awspowershell.ps1) has got you covered. It will detect your PowerShell edition (Desktop or Core) and install and import the appropriate AWS PowerShell module.
```
. ./install-awspowershell.ps1
```
I recommend using [Visual Studio Code with the PowerShell extension](https://benpiper.com/2017/08/visual-studio-code-as-a-powershell-integrated-scripting-environment/). It works on Linux, Mac, and Windows!

#### [AWS Networking Deep Dive: Virtual Private Cloud (VPC)](https://pluralsight.pxf.io/c/1191775/424552/7490?subId1=github&u=https%3A%2F%2Fwww.pluralsight.com%2Fcourses%2Faws-networking-deep-dive-vpc) lab setup
Refer to [vpc/lab-setup.md](vpc/lab-setup.md) for the lab setup for this course.

#### [AWS Networking Deep Dive: Elastic Load Balancing (ELB)](https://pluralsight.pxf.io/6bXjBK) lab setup
Refer to [elb/lab-setup.md](elb/lab-setup.md) for the lab setup for this course.

#### [AWS Networking Deep Dive: Route 53 DNS](https://pluralsight.pxf.io/n1jM96) lab setup
Refer to [route53/lab-setup.md](route53/lab-setup.md) for the lab setup for this course.

*Baked with love for PowerShell Core!*

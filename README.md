# aws-powershell

Cross-platform scripts and Terraform configurations for doing cool things with AWS VPC, ELB, and Route 53.

This repository contains both PowerShell scripts and Terraform configurations for setting up AWS lab environments.

## PowerShell Setup (PowerShell Core)

If you don't already have the AWS PowerShell SDK installed, [install-awspowershell.ps1](install-awspowershell.ps1) has got you covered. It will detect your PowerShell edition (Desktop or Core) and install and import the appropriate AWS PowerShell module.

```powershell
. ./install-awspowershell.ps1
```

I recommend using [Visual Studio Code with the PowerShell extension](https://benpiper.com/2017/08/visual-studio-code-as-a-powershell-integrated-scripting-environment/). It works on Linux, Mac, and Windows!

## Terraform Setup (Alternative)

If you prefer infrastructure-as-code with Terraform, configurations are available for some lab modules. To use these:

1. Ensure you have [Terraform](https://www.terraform.io/downloads.html) installed.
2. Navigate to the `terraform` directory within the module folder.
3. Run `terraform init` and `terraform apply`.

---

## Lab Modules

### Virtual Private Cloud (VPC)

- **PowerShell**: Refer to [vpc/lab-setup.md](vpc/lab-setup.md) for setup instructions.

### Elastic Load Balancing (ELB)

- **PowerShell**: Refer to [elb/lab-setup.md](elb/lab-setup.md) for setup instructions.
- **Terraform**: Configuration available in [elb/terraform](elb/terraform/).

### Route 53 DNS

- **PowerShell**: Refer to [route53/lab-setup.md](route53/lab-setup.md) for setup instructions.
- **Terraform**: Configuration available in [route53/terraform](route53/terraform/).

### AWS Config

- Scripts for AWS Config are in the [cfg](cfg/) directory.

*Baked with love for PowerShell Core and Terraform!*

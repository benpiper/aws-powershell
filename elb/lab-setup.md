1. You will need the AWS PowerShell SDK installed and loaded. Run [install-awspowershell.ps1](/install-awspowershell.ps1) to take care of this, or do it manually.
2. Edit the file [_credentials.ps1](_credentials.ps1), replace the AWS secret key and access key with your own, and save the file as credentials.ps1
3. Edit [lab-setup.ps1](lab-setup.ps1) and modify the AWS region (default is us-east-1) and your public IP address accordingly.
4. Run [. ./lab-setup.ps1](lab-setup.ps1)

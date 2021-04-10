
    
        if (!(Get-Module AWSPowerShell.NetCore)) { 
            Write-Host "Installing AWSPowerShell.NetCore..." 
            Install-Module -name AWSPowerShell.NetCore -Scope CurrentUser -Force -AllowClobber
        }
        Write-Host "Importing module..."
        Import-Module AWSPowerShell.NetCore -Force
 
    Get-AWSPowerShellVersion
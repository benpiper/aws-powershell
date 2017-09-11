
    Write-Host "You are using PowerShell $PSEdition!"

    # Test PoSh version (core vs full) and respond accordingly
    if ($PSEdition -eq "Core") {  
        #PoSh Core (probably Linux but maybe bleeding edge Windows user)
        if (!(Get-Module AWSPowerShell.NetCore)) { 
            Write-Host "Installing AWSPowerShell.NetCore..." 
            Install-Module AWSPowerShell.NetCore -Scope CurrentUser -Force
        }
        Write-Host "Importing module..."
        Import-Module AWSPowerShell.NetCore -Force
        # If using PoSh Core on windows, add: Install-Module AWSPowerShell -SkipPublisherCheck
    } elseif ($PSEdition -eq "Desktop")
    {
        #PoSh Windows
        if ((Get-Module AWSPowerShell) -notlike "AWSPowerShell" ) {
        Write-Host "Installing AWSPowerShell..."
        Install-Module AWSPowerShell -Scope CurrentUser -Force
        }
        Write-Host "Importing module..."
        Import-Module AWSPowerShell -Force
    }

    #NB: Do not install Core module in regular Windows PowerShell! It's not the same thing and won't work.

    Get-AWSPowerShellVersion
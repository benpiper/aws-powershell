#Import AWS credentials
. ./credentials.ps1

$AWSProfileName="aws-networking-deep-dive-route-53-dns"

# Load the credentials for this session
Set-AWSCredential -ProfileName $AWSProfileName

# To avoid errors, specify only the regions you're using.
$regions = @("us-east-1","us-west-1")
#$regions = @((Get-AWSRegion).Region)

$urlprefix = "http://"

$instances = @()

$regions | ForEach-Object {
    $regioninstances = (Get-EC2Instance -Region $_).Instances
    if ($regioninstances -ne $null) {
        $instances += (Get-EC2Instance -Region $_).Instances
    }
}

$sessions = @()
$instances | ForEach-Object {
    $sessions += New-Object PSObject -Property @{
        'Name'=$_.Tags.Value;
        'IP'=$_.PublicIpAddress;
        'URL'="$($urlprefix)$($_.PublicIpAddress)";
    }
}

$sessions | Sort-Object -Property IP | Select-Object -Property Name,IP,URL

$sessions | ForEach-Object {
    $csvline += "$($_.Name),$($_.IP)`n"
}

$csvline | Out-File ./instance-eip.csv

Remove-Variable csvline,sessions,instances
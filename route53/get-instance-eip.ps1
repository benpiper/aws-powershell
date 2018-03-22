#Import AWS credentials
. ./credentials.ps1

Set-AWSCredential -AccessKey $AWSAccessKey -SecretKey $AWSSecretKey

#$regions = @("us-east-1","us-west-1")
$regions = @((Get-AWSRegion).Region)
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
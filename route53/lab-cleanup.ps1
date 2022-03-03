Write-Warning "This will destroy AWS resources." -WarningAction Inquire

$cidr = "172.9.0.0/16"
$region = "us-west-1"

Set-DefaultAWSRegion $region
# Remove instances
$instances = Get-EC2Instance
foreach ($instance in $instances) { Remove-EC2Instance $instances.Instances.InstanceId -Force }
Write-Host Proceed when instances are terminated
pause
# Remove network interfaces
# Remove VPCs
$vpcs = Get-EC2Vpc -Region $region -Filter @( @{name="cidr";value=$cidr})
foreach ($vpc in $vpcs) { Remove-EC2Vpc -VpcId $vpc.VpcId -Force }
# Remove resource record sets
# Remove zones
# Remove reusable delegation sets


$cidr = "172.3.0.0/16"
$region = "us-east-1"

Set-DefaultAWSRegion $region
# Remove instances
$instances = Get-EC2Instance
foreach ($instance in $instances) { Remove-EC2Instance $instances.Instances.InstanceId -Force }
Write-Host Proceed when instances are terminated
pause
# Remove network interfaces
# Remove VPCs
$vpcs = Get-EC2Vpc -Region $region -Filter @( @{name="cidr";value=$cidr})
foreach ($vpc in $vpcs) { Remove-EC2Vpc -VpcId $vpc.VpcId -Force }
# Remove resource record sets
# Remove zones
# Remove reusable delegation sets
$cidr = "172.9.0.0/16"
$region = "us-west-1"

Set-DefaultAWSRegion $region
# Remove instances
$instances = Get-EC2Instance
foreach ($instance in $instances) { Remove-EC2Instance $instances.Instances.InstanceId -Force }
Write-Host Proceed when instances are terminated
pause
# Remove VPCs
$vpc = Get-EC2Vpc -Region $region -Filter @( @{name="cidr";value=$cidr})
Remove-EC2Vpc -VpcId $vpc.VpcId -Force
# Remove resource record sets
# Remove zones
# Remove reusable delegation sets
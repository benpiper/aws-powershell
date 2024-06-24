#Import AWS credentials
. ./credentials.ps1

# Set AWS credentials
$AWSProfileName="aws-networking-deep-dive-route-53-dns"

# Set AWS credentials and store them
Set-AWSCredential -AccessKey $AWSAccessKey -SecretKey $AWSSecretKey -StoreAs $AWSProfileName

# Load the credentials for this session
Set-AWSCredential -ProfileName $AWSProfileName

Write-Warning "This will destroy AWS resources." -WarningAction Inquire

$locations = @(
    @{ cidr = "172.9.0.0/16"; region = "us-west-2" },
    @{ cidr = "172.3.0.0/16"; region = "us-east-2" }
)

foreach($location in $locations)
{
    $cidr = $location.cidr
    $region = $location.region

    Write-Host Cleaning up $region resources in CIDR $cidr

    Set-DefaultAWSRegion $region

    $gateways = @()
    $vpcs = Get-EC2Vpc -Region $region -Filter @( @{Name="cidr";Values=$cidr})

    foreach($vpc in $vpcs)
    {
        # Detach internet gateways and keep track for later deletion
        $gws = Get-EC2InternetGateway -Filter @(@{Name="attachment.vpc-id";Values=$vpc.VpcId})
        foreach($gw in $gws) 
        { 
            $gateways += $gw
            Dismount-EC2InternetGateway -VpcId $vpc.VpcId -InternetGatewayId $gw.InternetGatewayId
        }
    }

    # Delete internet gateways
    foreach($gateway in $gateways)
    {
        Remove-EC2InternetGateway -InternetGatewayId $gateway.InternetGatewayId
    }

    # Remove instances
    $instances = Get-EC2Instance
    foreach ($instance in $instances) { Remove-EC2Instance $instances.Instances.InstanceId -Force }

    Write-Host Proceed when instances are terminated
    pause

    # Remove VPCs
    foreach ($vpc in $vpcs) 
    {
        # Remove network interfaces
        $interfaces = Get-EC2NetworkInterface -Filter @( @{Name="vpc-id";Values=$vpc.VpcId})
        foreach ($interface in $interfaces) { Remove-EC2NetworkInterface -NetworkInterfaceId $interface.NetworkInterfaceId }

        # Remove subnets
        $subnets = Get-EC2Subnet -Filter @(@{Name="vpc-id";Values=$vpc.VpcId})
        foreach ($subnet in $subnets) { Remove-EC2Subnet -SubnetId $subnet.SubnetId }

        # Remove route tables
        $routetables = Get-EC2RouteTable -Filter @(@{Name="vpc-id";Values=$vpc.VpcId})
        foreach ($routetable in $routetables)
        {
            $mainroutetable = $false

            # We can't remove the main route table
            foreach($association in $routetable.Associations)
            {
                if ($association.Main)
                {
                    $mainroutetable = $true
                    continue
                }
            }

            if (!$mainroutetable)
            {
                Remove-EC2RouteTable -RouteTableId $routetable.RouteTableId
            }
        }

        # Remove security groups
        $securitygroups = Get-EC2SecurityGroup -Filter @(@{Name="vpc-id";Values=$vpc.VpcId})
        foreach($securitygroup in $securitygroups)
        {
            # We can't delete the default security group
            if ($securitygroup.GroupName -ne "default")
            {
                Remove-EC2SecurityGroup -GroupId $securityGroup.GroupId
            }
        }

        Remove-EC2Vpc -VpcId $vpc.VpcId
    }

    # Remove resource record sets
    # Remove zones
    # Remove reusable delegation sets
}

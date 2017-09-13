#Instructions: Execute each command line-by-line. If you've configured your
#VPCs per the demonstrations, each cmdlet should give you output. Compare
#the output to the information in the web console to verify your configuration.

$vpcname = "web-vpc"
$subnetname = "web-pub"
$routetable = "web-pub"

#View the CIDR block of the web-vpc
Get-EC2Vpc -Filter @{Name="tag-value";Values="$vpcname"} | select CidrBlock

#View the web-pub route table
Get-EC2RouteTable -Filter @{Name="tag-value";Values="$routetable"} | select Associations,Routes

#View the web-pub route table associations
Get-EC2RouteTable -Filter @{Name="tag-value";Values="$routetable"} | select -ExpandProperty Associations

#View the web-pub subnet
Get-EC2Subnet -Filter @{Name="tag-value";Values="$subnetname"} | select AvailabilityZone,CidrBlock,SubnetId

#View the routes in the web-pub route table
Get-EC2RouteTable -Filter @{Name="tag-value";Values="$routetable"} | select -ExpandProperty Routes | ft

#View www1's eth0 elastic network interface
Get-EC2NetworkInterface -Filter @{Name="tag-value";Values="www1 eth0"} | select Description,Groups,PrivateIpAddress

#View www1's public-private IP address mapping
Get-EC2Address | select PrivateIpAddress,PublicIp,InstanceId


$vpcname = "shared-vpc"
$subnetname = "database"
$routetable = "shared"

#View the CIDR block of the shared-vpc
Get-EC2Vpc -Filter @{Name="tag-value";Values="$vpcname"} | select CidrBlock

#View the shared route table
Get-EC2RouteTable -Filter @{Name="tag-value";Values="$routetable"} | select Associations,Routes

#View the shared route table associations
Get-EC2RouteTable -Filter @{Name="tag-value";Values="$routetable"} | select -ExpandProperty Associations

#View the database subnet
Get-EC2Subnet -Filter @{Name="tag-value";Values="$subnetname"} | select AvailabilityZone,CidrBlock,SubnetId

#View the routes in the shared route table
Get-EC2RouteTable -Filter @{Name="tag-value";Values="$routetable"} | select -ExpandProperty Routes | ft

#View db1's eth0 elastic network interface
Get-EC2NetworkInterface -Filter @{Name="private-ip-address";Values="10.2.2.41"} | select Groups,PrivateIpAddress
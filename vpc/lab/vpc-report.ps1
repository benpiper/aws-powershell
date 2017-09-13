#View the CIDR block of the web-vpc
Get-EC2Vpc -Filter @{Name="tag-value";Values="web-vpc"} | select CidrBlock

#View the web-pub route table
Get-EC2RouteTable -Filter @{Name="tag-value";Values="web-pub"} | select Associations,Routes

#View the web-pub route table associations
Get-EC2RouteTable -Filter @{Name="tag-value";Values="web-pub"} | select -ExpandProperty Associations

#View the web-pub subnet
Get-EC2Subnet -Filter @{Name="tag-value";Values="web-pub"} | select AvailabilityZone,CidrBlock,SubnetId

#View the routes in the web-pub route table
Get-EC2RouteTable -Filter @{Name="tag-value";Values="web-pub"} | select -ExpandProperty Routes | ft

#View www1's eth0 elastic network interface
Get-EC2NetworkInterface -Filter @{Name="tag-value";Values="www1 eth0"} | select Description,Groups,PrivateIpAddress

#View www1's public-private IP address mapping
Get-EC2Address | select PrivateIpAddress,PublicIp,InstanceId

#View the CIDR block of the shared-vpc
Get-EC2Vpc -Filter @{Name="tag-value";Values="shared-vpc"} | select CidrBlock

#View the shared route table
Get-EC2RouteTable -Filter @{Name="tag-value";Values="shared"} | select Associations,Routes

#View the shared route table associations
Get-EC2RouteTable -Filter @{Name="tag-value";Values="shared"} | select -ExpandProperty Associations

#View the database subnet
Get-EC2Subnet -Filter @{Name="tag-value";Values="database"} | select AvailabilityZone,CidrBlock,SubnetId

#View the routes in the shared route table
Get-EC2RouteTable -Filter @{Name="tag-value";Values="shared"} | select -ExpandProperty Routes | ft

#View db1's eth0 elastic network interface
Get-EC2NetworkInterface -Filter @{Name="private-ip-address";Values="10.2.2.41"} | select Groups,PrivateIpAddress
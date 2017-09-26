#Populate with instance's Name tag
$instancename = "www1"

#Retrieve the instance
$instance = (Get-EC2Instance -Filter @{Name="tag-value";Values="$instancename"}).Instances

#View the instance
$instance

#Retrieve the instance's ENIs
$eni = $instance | select -ExpandProperty NetworkInterfaces

#View the primary ENI's properties
$eni[0] | select PrivateIpAddress,Groups,SubnetId

#Retrieve the primary ENI's associated subnet
$subnet = Get-EC2Subnet -SubnetId $eni.SubnetId

#View the subnet properties
$subnet | select AvailabilityZone,CidrBlock

#Retrieve the route table the subnet is associated with
$table = (Get-EC2RouteTable -Filter @{Name="association.subnet-id";Values=$eni.SubnetId})

#View the routes in the route table
$table.Routes | ft
$table.Routes | fl
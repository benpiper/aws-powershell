# AWS VPC PowerShell Functions
# Ben Piper
# ben@benpiper.com


### Create-NameTag

# Example variables
# $name = "Webtier VPC"
# $resourceID = "vpc-12345678"

function Create-NameTag {
    param (
        [Parameter(Mandatory)] [string]$name,
        [Parameter(Mandatory)] [string]$resourceID
    )
     # Create a tag object with the key "Name" and specified value
     $tag = New-Object Amazon.EC2.Model.Tag
     $tag.Key = "Name"
     $tag.Value = $name
 
     # Attach the tag to the subnet
     New-EC2Tag -Tag $tag -Resource $resourceID
}

### Create-RouteTable

#Example variables
# $routeTableName = "webtier-public-routes"

function Create-RouteTable {
    param (
        [Parameter(Mandatory)] [Amazon.EC2.Model.Vpc]$vpc,
        [Parameter(Mandatory)] [string]$routeTableName,
        [Amazon.EC2.Model.Subnet]$subnet
        )

    #Create route table in VPC
    $routeTable = New-EC2RouteTable -VpcId $vpc.VpcId

    #Create "Name" tag for the route table
    Create-NameTag -name $routeTableName -resourceID $routeTable.RouteTableId

    #If subnet specified, register route table with subnet
    if ($subnet) {
        Register-EC2RouteTable -RouteTableId $routeTable.RouteTableId -SubnetId $subnet.SubnetId
    }
   
    return $routeTable
}


### Create-Subnet

# Example Variables
# $zone = "us-east-1a"
# $name = "web1a-public-subnet"
# $Pv4Cidr = "10.3.91.0/24"
# $IPv6prefix = "91"

function Create-Subnet {
    param (
        [Parameter(Mandatory)] [Amazon.EC2.Model.VPC]$vpc,
        [Parameter(Mandatory)] [string]$zone,
        [Parameter(Mandatory)] [string]$name,
        [Parameter(Mandatory)] [string]$IPv4Cidr,
        [Parameter(Mandatory)] [string]$IPv6prefix
    )

    #Generate the IPv6 subnet from the specified IPv6 ID
    
    #Example: Given a CIDR 2600:1f18:4369:9800::/56
    #                                       ^^
    #         and a subnet prefix of 75, the new subnet would be
    #         2600:1f18:4369:9875::/64
    #                          ^^

    #Get the IPv6 CIDR assigned to the VPC
    $vpcIPv6Cidr = (($vpc.Ipv6CidrBlockAssociationSet).Ipv6CidrBlock)
 
    #CIDR prefix length is /56 by default, and AWS requires /64 for a subnet
    # Remove the /56 ("Split")
    # Replace the rightmost "00" with the subnet prefix ("Replace")
    # Append a /64
    $IPv6subnet = ($vpcIPv6Cidr.Split("/")[0]).Replace("00::","$IPv6prefix::") + "/64"

    # Create subnet containing IPv4 CIDR and generated IPv6 subnet
    $subnet = New-EC2Subnet -AvailabilityZone $zone -VpcId $vpc.VpcId -CidrBlock $IPv4CIDR -Ipv6CidrBlock $IPv6subnet

    #Create Name tag for the subnet
    Create-NameTag -name $name -resourceID $subnet.SubnetId
    
    # Return the subnet
    $subnet = get-ec2subnet -SubnetId $subnet.SubnetId
    return $subnet
}


### Create-VPC

# Example variables
# $vpcCidr = "10.3.0.0/16"
# $vpcName = "webtier"

function Create-VPC {
    param (
        [Parameter(Mandatory)] [string]$vpcCidr,
        [Parameter(Mandatory)] [string]$vpcName
    )

    # Create new vpc with CIDR block and have AWS allocate an IPv6 CIDR block
    $vpc = New-EC2Vpc -CidrBlock $vpcCidr -AmazonProvidedIpv6CidrBlock $true

    #Create Name tag for the VPC
    Create-NameTag -name $vpcName -resourceID $vpc.VpcId

    # Return the VPC
    $vpc = Get-EC2Vpc -VpcId $vpc.VpcId
    return $vpc
    }

    ### Create-InternetGateway

    function Create-InternetGateway {
        param (
            [Parameter(Mandatory)] [Amazon.EC2.Model.VPC]$vpc,
            [Parameter(Mandatory)] [string]$name
        )

        $igw = New-EC2InternetGateway
        Add-EC2InternetGateway -InternetGatewayId $igw.InternetGatewayId -VpcId $vpc.VpcId

        Create-NameTag -name $name -resourceID $igw.InternetGatewayId
        $igw = Get-EC2InternetGateway $igw.InternetGatewayId
        return $igw
    }






    ##### GET FUNCTIONS! #####

    ### Get-ResourceByTagValue

    # Example variable
# $keyvalue = "webtier"

function Get-ResourceByTagValue {
    param (
        [string]$keyvalue="*"
    )
    $tag = Get-EC2Tag -Filter @( @{name="value";value=$keyvalue}) | Sort-Object -Property Value,ResourceType
    return $tag
}
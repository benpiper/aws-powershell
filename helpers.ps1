### New-NameTag

# Example variables
# $name = "Webtier VPC"
# $resourceID = "vpc-12345678"

function New-NameTag {
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

function Get-ResourceByTagValue {
    param (
        [string]$keyvalue="*"
    )
    $tag = Get-EC2Tag -Filter @( @{name="value";value=$keyvalue}) | Sort-Object -Property Value,ResourceType
    return $tag
}
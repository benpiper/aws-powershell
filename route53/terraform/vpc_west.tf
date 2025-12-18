# Region B: us-west-1 (West)

resource "aws_vpc" "r53_lab_west" {
  provider             = aws.west
  cidr_block           = "172.9.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "r53-lab-west-vpc" }
}

resource "aws_internet_gateway" "igw_west" {
  provider = aws.west
  vpc_id   = aws_vpc.r53_lab_west.id
  tags     = { Name = "r53-lab-west-igw" }
}

resource "aws_subnet" "subnet_1a_west" {
  provider          = aws.west
  vpc_id            = aws_vpc.r53_lab_west.id
  cidr_block        = "172.9.0.0/24"
  availability_zone = "${var.region_b}a"
  tags              = { Name = "r53-lab-1a-west" }
}

resource "aws_subnet" "subnet_1b_west" {
  provider          = aws.west
  vpc_id            = aws_vpc.r53_lab_west.id
  cidr_block        = "172.9.1.0/24"
  availability_zone = "${var.region_b}b"
  tags              = { Name = "r53-lab-1b-west" }
}

resource "aws_route_table" "rt_west" {
  provider = aws.west
  vpc_id   = aws_vpc.r53_lab_west.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_west.id
  }
  tags = { Name = "r53-lab-rt-west" }
}

resource "aws_route_table_association" "a_west" {
  provider       = aws.west
  subnet_id      = aws_subnet.subnet_1a_west.id
  route_table_id = aws_route_table.rt_west.id
}

resource "aws_route_table_association" "b_west" {
  provider       = aws.west
  subnet_id      = aws_subnet.subnet_1b_west.id
  route_table_id = aws_route_table.rt_west.id
}

resource "aws_security_group" "sg_west" {
  provider    = aws.west
  name        = "r53-lab-sg-west"
  description = "r53-lab-sg-west"
  vpc_id      = aws_vpc.r53_lab_west.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
        "172.3.0.0/16", # Access from Region A
        var.allowed_ssh_cidr
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web1 West
resource "aws_network_interface" "web1_west_eni" {
  provider        = aws.west
  subnet_id       = aws_subnet.subnet_1a_west.id
  private_ips      = ["172.9.0.10"]
  security_groups = [aws_security_group.sg_west.id]
  description     = "web1-west eth0"
}

resource "aws_eip" "web1_west_eip" {
  provider          = aws.west
  network_interface = aws_network_interface.web1_west_eni.id
}

resource "aws_instance" "web1_west" {
  provider      = aws.west
  ami           = var.ami_west
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.web1_west_eni.id
    device_index         = 0
  }

  tags = { Name = "web1-west" }
}

# Web2 West
resource "aws_network_interface" "web2_west_eni" {
  provider        = aws.west
  subnet_id       = aws_subnet.subnet_1b_west.id
  private_ips      = ["172.9.1.20"]
  security_groups = [aws_security_group.sg_west.id]
  description     = "web2-west eth0"
}

resource "aws_eip" "web2_west_eip" {
  provider          = aws.west
  network_interface = aws_network_interface.web2_west_eni.id
}

resource "aws_instance" "web2_west" {
  provider      = aws.west
  ami           = var.ami_west
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.web2_west_eni.id
    device_index         = 0
  }

  tags = { Name = "web2-west" }
}

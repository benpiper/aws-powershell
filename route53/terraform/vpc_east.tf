# Region A: us-east-1 (East)

resource "aws_vpc" "r53_lab_east" {
  provider             = aws.east
  cidr_block           = "172.3.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "r53-lab-east-vpc" }
}

resource "aws_internet_gateway" "igw_east" {
  provider = aws.east
  vpc_id   = aws_vpc.r53_lab_east.id
  tags     = { Name = "r53-lab-east-igw" }
}

resource "aws_subnet" "subnet_1a_east" {
  provider          = aws.east
  vpc_id            = aws_vpc.r53_lab_east.id
  cidr_block        = "172.3.0.0/24"
  availability_zone = "${var.region_a}a"
  tags              = { Name = "r53-lab-1a-east" }
}

resource "aws_subnet" "subnet_1b_east" {
  provider          = aws.east
  vpc_id            = aws_vpc.r53_lab_east.id
  cidr_block        = "172.3.1.0/24"
  availability_zone = "${var.region_a}b"
  tags              = { Name = "r53-lab-1b-east" }
}

resource "aws_route_table" "rt_east" {
  provider = aws.east
  vpc_id   = aws_vpc.r53_lab_east.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_east.id
  }
  tags = { Name = "r53-lab-rt-east" }
}

resource "aws_route_table_association" "a_east" {
  provider       = aws.east
  subnet_id      = aws_subnet.subnet_1a_east.id
  route_table_id = aws_route_table.rt_east.id
}

resource "aws_route_table_association" "b_east" {
  provider       = aws.east
  subnet_id      = aws_subnet.subnet_1b_east.id
  route_table_id = aws_route_table.rt_east.id
}

resource "aws_security_group" "sg_east" {
  provider    = aws.east
  name        = "r53-lab-sg-east"
  description = "r53-lab-sg-east"
  vpc_id      = aws_vpc.r53_lab_east.id

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
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web1 East
resource "aws_network_interface" "web1_east_eni" {
  provider        = aws.east
  subnet_id       = aws_subnet.subnet_1a_east.id
  private_ips      = ["172.3.0.10"]
  security_groups = [aws_security_group.sg_east.id]
  description     = "web1-east eth0"
}

resource "aws_eip" "web1_east_eip" {
  provider          = aws.east
  network_interface = aws_network_interface.web1_east_eni.id
}

resource "aws_instance" "web1_east" {
  provider      = aws.east
  ami           = var.ami_east
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.web1_east_eni.id
    device_index         = 0
  }

  tags = { Name = "web1-east" }
}

# Web2 East
resource "aws_network_interface" "web2_east_eni" {
  provider        = aws.east
  subnet_id       = aws_subnet.subnet_1b_east.id
  private_ips      = ["172.3.1.20"]
  security_groups = [aws_security_group.sg_east.id]
  description     = "web2-east eth0"
}

resource "aws_eip" "web2_east_eip" {
  provider          = aws.east
  network_interface = aws_network_interface.web2_east_eni.id
}

resource "aws_instance" "web2_east" {
  provider      = aws.east
  ami           = var.ami_east
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.web2_east_eni.id
    device_index         = 0
  }

  tags = { Name = "web2-east" }
}

# DB East
resource "aws_network_interface" "db_east_eni" {
  provider        = aws.east
  subnet_id       = aws_subnet.subnet_1b_east.id
  private_ips      = ["172.3.1.100"]
  security_groups = [aws_security_group.sg_east.id]
  description     = "db-east eth0"
}

resource "aws_eip" "db_east_eip" {
  provider          = aws.east
  network_interface = aws_network_interface.db_east_eni.id
}

resource "aws_instance" "db_east" {
  provider      = aws.east
  ami           = var.ami_east
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.db_east_eni.id
    device_index         = 0
  }

  tags = { Name = "db-east" }
}

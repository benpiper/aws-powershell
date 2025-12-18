resource "aws_vpc" "webapp_vpc" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "webapp-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.webapp_vpc.id

  tags = {
    Name = "webapp-igw"
  }
}

resource "aws_subnet" "web_1a" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "172.31.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "web-1a"
  }
}

resource "aws_subnet" "web_1b" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "172.31.2.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "web-1b"
  }
}

resource "aws_subnet" "app_1a" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "172.31.101.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "app-1a"
  }
}

resource "aws_subnet" "app_1b" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "172.31.102.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "app-1b"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.webapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "webapp-rt"
  }
}

resource "aws_route_table_association" "web_1a" {
  subnet_id      = aws_subnet.web_1a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "web_1b" {
  subnet_id      = aws_subnet.web_1b.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "app_1a" {
  subnet_id      = aws_subnet.app_1a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "app_1b" {
  subnet_id      = aws_subnet.app_1b.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_instance" "web1" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.web_1a.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  private_ip                  = "172.31.1.21"

  tags = {
    Name = "web1"
  }
}

resource "aws_instance" "web2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.web_1b.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  private_ip                  = "172.31.2.22"

  tags = {
    Name = "web2"
  }
}

resource "aws_instance" "web3" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.web_1b.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  private_ip                  = "172.31.2.23"

  tags = {
    Name = "web3"
  }
}

resource "aws_instance" "app1" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.app_1a.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  private_ip                  = "172.31.101.21"

  tags = {
    Name = "app1"
  }
}

resource "aws_instance" "app2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.app_1b.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  private_ip                  = "172.31.102.22"

  tags = {
    Name = "app2"
  }
}

resource "aws_instance" "app3" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.app_1b.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  private_ip                  = "172.31.102.23"

  tags = {
    Name = "app3"
  }
}

resource "aws_instance" "db" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.app_1a.id
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  private_ip                  = "172.31.101.99"

  tags = {
    Name = "db"
  }
}

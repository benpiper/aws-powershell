variable "region_a" {
  type    = string
  default = "us-east-1"
}

variable "region_b" {
  type    = string
  default = "us-west-1"
}

variable "ami_east" {
  type    = string
  default = "ami-00d1bccc04cb4ae98"
}

variable "ami_west" {
  type    = string
  default = "ami-04ee69ce5f61ff15e"
}

variable "key_name" {
  type    = string
  default = "ccnetkeypair"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "allowed_ssh_cidr" {
  type    = string
  default = "24.96.0.0/16"
}

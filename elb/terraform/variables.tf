variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "The AMI to use for instances"
  type        = string
  default     = "ami-00d1bccc04cb4ae98"
}

variable "key_name" {
  description = "The name of the SSH keypair"
  type        = string
  default     = "ccnetkeypair"
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidr" {
  description = "The CIDR block for SSH access"
  type        = string
  default     = "24.96.0.0/16"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "east"
  region = var.region_a
}

provider "aws" {
  alias  = "west"
  region = var.region_b
}

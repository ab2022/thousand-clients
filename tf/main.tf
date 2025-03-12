terraform {
    required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 4.16"
        }
    }
    required_version = ">= 1.2.0"
}

provider "aws" {
    region  = "us-west-2"
    profile = "saml"
}

data "aws_security_group" "launchwizard2" {
  id = "sg-026e7af172962f936"
}

resource "aws_instance" "ab_server" {
    count         = 100
    ami           = "ami-00c257e12d6828491"
    instance_type = "c5a.4xlarge"
    vpc_security_group_ids = [data.aws_security_group.launchwizard2.id]
    user_data     = file("install.sh")
    tags = {
        Name = "Dash Clients ${count.index}"
    }
}


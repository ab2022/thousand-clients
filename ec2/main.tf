terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">=5.0"
        }
    }
}

provider "aws" {
    region  = "us-west-2"
    profile = "saml"
}

data "aws_security_group" "ab_subnet" {
    id = "sg-026e7af172962f936" #update to default subnet
}

resource "aws_key_pair" "deployer" {
    key_name   = "deployer-key"
    public_key = "${file("{/PATH/TO/PUBLIC_SSH_KEY}")}" #add path to public key
}

resource "aws_instance" "ab_server" {
    count         = 100
#    ami           = "ami-0acefc55c3a331fa8" #ubuntu for graviton in us-west-2
#    instance_type = "m8g.xlarge"
    ami           = "ami-00c257e12d6828491" #ubuntu for amd64/intel
    instance_type = "c5a.4xlarge"
    vpc_security_group_ids = [data.aws_security_group.ab_subnet.id]
    key_name      = "${aws_key_pair.deployer.id}"

    user_data     = file("install.sh")
    tags = {
        Name = "Dash Clients ${count.index}"
    }
}


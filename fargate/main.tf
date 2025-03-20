terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = ">=5.0"
        }
    }
}

provider "aws" {
    region  = "us-west-2"
    profile = "saml"
}

data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "my_cluster" {
    name = "thousands-cluster" # cluster name
}

resource "aws_cloudwatch_log_group" "my_log_group" {
    name = "/ecs/thousands"
}

resource "aws_ecs_task_definition" "app_task" {
    family                   = "thousands-first-task" # task name
    container_definitions    = <<DEFINITION
    [
        {
            "name": "thousands-first-task",
            "image": "341487011637.dkr.ecr.us-west-2.amazonaws.com/dashworld:latest",
            "essential": true,
            "memory": 512,
            "cpu": 256,
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-region": "us-west-2",
                    "awslogs-group": "/ecs/thousands",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]
    DEFINITION
    requires_compatibilities = ["FARGATE"] # use Fargate as the launch type
    network_mode             = "awsvpc"    # add the awsvpc network mode as this is required for Fargate
    memory                   = 512         # Specify the memory the container requires
    cpu                      = 256         # Specify the CPU the container requires
    execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
    name               = "CustomerManaged-ecsTaskExecutionRole"
    assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
    permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/BasicRole_Boundary"
}

data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
    role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Provide a reference to the default VPC
resource "aws_default_vpc" "default_vpc" {
}

# Provide references to the default subnets
resource "aws_default_subnet" "default_subnet_a" {
    # reference to subnet 1a
    availability_zone = "us-west-2a"
}

resource "aws_default_subnet" "default_subnet_b" {
    # reference to subnet 1b
    availability_zone = "us-west-2b"
}

resource "aws_ecs_service" "app_service" {
    name            = "thousands-first-service"                 # Name of the service
    cluster         = "${aws_ecs_cluster.my_cluster.id}"        # Reference the created Cluster
    task_definition = "${aws_ecs_task_definition.app_task.arn}" # Reference the task that the service will spin up
    launch_type     = "FARGATE"
    desired_count   = 5 # Set the number of containers

    network_configuration {
        subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}"]
        assign_public_ip = true                                                # Provide the containers with public IPs
        security_groups  = ["${aws_security_group.service_security_group.id}"] # Set up the security group
    }
}

resource "aws_security_group" "service_security_group" {
    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


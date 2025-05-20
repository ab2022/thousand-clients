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
    family                   = "thousands-taskdef" # task name
    container_definitions    = <<DEFINITION
    [
        {
            "name": "thousands-taskdef",
            "image": "341487011637.dkr.ecr.us-west-2.amazonaws.com/alpinechrome:new_3",
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
            },
            "command": [ "https://nightly-dot-shaka-player-demo.appspot.com/demo/#audiolang=en-US;textlang=en-US;cmcd.enabled=true;uilang=en-US;assetBase64=eyJuYW1lIjoic2t5IG5ld3MgIiwic2hvcnROYW1lIjoiIiwiaWNvblVyaSI6IiIsIm1hbmlmZXN0VXJpIjoiaHR0cHM6Ly9zYXRwb2MuY29tOjEyOTEwL2Rhc2gvU2VydmljZTIvbWFuaWZlc3QubXBkIiwic291cmNlIjoiQ3VzdG9tIiwiZm9jdXMiOmZhbHNlLCJkaXNhYmxlZCI6ZmFsc2UsImV4dHJhVGV4dCI6W10sImV4dHJhVGh1bWJuYWlsIjpbXSwiZXh0cmFDaGFwdGVyIjpbXSwiY2VydGlmaWNhdGVVcmkiOm51bGwsImRlc2NyaXB0aW9uIjpudWxsLCJpc0ZlYXR1cmVkIjpmYWxzZSwiZHJtIjpbIk5vIERSTSBwcm90ZWN0aW9uIl0sImZlYXR1cmVzIjpbIlZPRCJdLCJsaWNlbnNlU2VydmVycyI6eyJfX3R5cGVfXyI6Im1hcCJ9LCJvZmZsaW5lTGljZW5zZVNlcnZlcnMiOnsiX190eXBlX18iOiJtYXAifSwibGljZW5zZVJlcXVlc3RIZWFkZXJzIjp7Il9fdHlwZV9fIjoibWFwIn0sInJlcXVlc3RGaWx0ZXIiOm51bGwsInJlc3BvbnNlRmlsdGVyIjpudWxsLCJjbGVhcktleXMiOnsiX190eXBlX18iOiJtYXAifSwiZXh0cmFDb25maWciOm51bGwsImV4dHJhVWlDb25maWciOm51bGwsImFkVGFnVXJpIjpudWxsLCJpbWFWaWRlb0lkIjpudWxsLCJpbWFBc3NldEtleSI6bnVsbCwiaW1hQ29udGVudFNyY0lkIjpudWxsLCJpbWFNYW5pZmVzdFR5cGUiOm51bGwsIm1lZGlhVGFpbG9yVXJsIjpudWxsLCJtZWRpYVRhaWxvckFkc1BhcmFtcyI6bnVsbCwidXNlSU1BIjp0cnVlLCJtaW1lVHlwZSI6bnVsbH0=;panel=CUSTOM%20CONTENT;build=uncompiled" ]
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
    desired_count   = 50 # Set the number of containers

    network_configuration {
        subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}"]
        assign_public_ip = true                                                # Provide the containers with public IPs
        security_groups  = ["${aws_security_group.service_security_group.id}"] # Set up the security group
    }
}

resource "aws_ecs_service" "another_app_service" {
    name            = "thousands-second-service"                 # Name of the service
    cluster         = "${aws_ecs_cluster.my_cluster.id}"        # Reference the created Cluster
    task_definition = "${aws_ecs_task_definition.app_task.arn}" # Reference the task that the service will spin up
    launch_type     = "FARGATE"
    desired_count   = 50 # Set the number of containers

    network_configuration {
        subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}"]
        assign_public_ip = true                                                # Provide the containers with public IPs
        security_groups  = ["${aws_security_group.service_security_group.id}"] # Set up the security group
    }
}

resource "aws_ecs_service" "this_app_service" {
    name            = "thousands-third-service"                 # Name of the service
    cluster         = "${aws_ecs_cluster.my_cluster.id}"        # Reference the created Cluster
    task_definition = "${aws_ecs_task_definition.app_task.arn}" # Reference the task that the service will spin up
    launch_type     = "FARGATE"
    desired_count   = 50 # Set the number of containers

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


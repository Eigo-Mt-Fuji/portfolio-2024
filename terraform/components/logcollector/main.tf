provider "aws" {
  region = "ap-northeast-1"
}

# Variables
variable "ami_id" {
  description = "AMI ID for Amazon Linux 2023"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the environment"
  type        = string
}

variable "subnet_ids" {
  description = "List of Subnet IDs for the environment"
  type        = list(string)
}

variable "component" {
  description = "Component name used for naming resources"
  type        = string
}

variable "tags" {
  description = "Cost allocation tags"
  type        = map(string)
}

# ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = var.component

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

# ECS Capacity Provider
resource "aws_ecs_capacity_provider" "this" {
  name = "${var.component}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.this.arn
    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 80
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 100
    }
    managed_termination_protection = "ENABLED"
  }

  tags = var.tags
}

# Attach the capacity provider to the cluster
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = [aws_ecs_capacity_provider.this.name]

  tags = var.tags
}

# Launch Template for EC2 instances
resource "aws_launch_template" "this" {
  name_prefix = "${var.component}-launch-template-"
  
  instance_type = "r8g.large"
  ami_id        = var.ami_id

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  security_group_names = [aws_security_group.this.name]

  key_name = "example-key"

  user_data = filebase64("user_data.sh")

  tags = var.tags
}

# Auto Scaling Group for EC2 instances
resource "aws_autoscaling_group" "this" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = var.subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.component}-asg"
      propagate_at_launch = true
    },
    for k, v in var.tags : {
      key                 = k
      value               = v
      propagate_at_launch = true
    }
  ]
}

# ECS Service with Blue/Green Deployment
resource "aws_ecs_service" "this" {
  name            = "${var.component}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.this.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "example-container"
    container_port   = 80
  }

  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    weight            = 1
  }

  tags = var.tags
}

# ECS Task Definition
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.component}-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "fluent-bit"
      image     = "fluent/fluent-bit:latest"
      cpu       = 128
      memory    = 256
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.component}"
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = var.tags
}

# Network Load Balancer (NLB)
resource "aws_lb" "this" {
  name               = "${var.component}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  name     = "${var.component}-tg"
  port     = 10224
  protocol = "TCP"
  vpc_id   = var.vpc_id

  tags = var.tags
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 10224
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = var.tags
}

# IAM Role and Instance Profile for ECS Instances
resource "aws_iam_role" "this" {
  name = "${var.component}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
  ]

  tags = var.tags
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.component}-instance-profile"
  role = aws_iam_role.this.name

  tags = var.tags
}

# Security Group for Fluent-bit
resource "aws_security_group" "this" {
  name        = "${var.component}-sg"
  description = "Allow inbound traffic for Fluent-bit"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 10224
    to_port     = 10224
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_vpc_endpoint_service" "this" {
  acceptance_required    = true
  network_load_balancer_arns = [aws_lb.this.arn]

  allowed_principals = [
    "arn:aws:iam::123456789012:root", # 接続を許可するAWSアカウント
  ]

  tags = var.tags
}

// // エンドポイントサービスの承認 acceptance_required = trueとした場合、サービスプロバイダー側で接続要求を承認する必要があります。Terraformではなく、AWSコンソールまたはCLIを使用して承認を行います。
// // この設定により、異なるVPCからPrivateLinkを経由してNLBにアクセスすることができます。プライベートネットワーク内で安全に通信でき、アクセス制御も容易です。Terraformを使用してこの構成をデプロイする場合、VPC IDやサブネットID、IAMポリシーなどを適切に設定してください。
// resource "aws_vpc_endpoint" "this" {
//   vpc_id            = var.consumer_vpc_id
//   service_name      = aws_vpc_endpoint_service.this.service_name
//   vpc_endpoint_type = "Interface"
//   subnet_ids        = var.consumer_subnet_ids
//   security_group_ids = [aws_security_group.consumer_sg.id]
// 
//   tags = var.tags
// }

// resource "aws_security_group" "consumer_sg" {
//   name        = "${var.component}-consumer-sg"
//   description = "Allow access to NLB via PrivateLink"
//   vpc_id      = var.consumer_vpc_id
// 
//   ingress {
//     from_port   = 10224
//     to_port     = 10224
//     protocol    = "tcp"
//     cidr_blocks = ["0.0.0.0/0"]
//   }
// 
//   egress {
//     from_port   = 0
//     to_port     = 0
//     protocol    = "-1"
//     cidr_blocks = ["0.0.0.0/0"]
//   }
// 
//   tags = var.tags
// }

# modules/ecs/main.tf

variable "region" {
  default = "us-east-1"
}

variable "raw_stream_name" {}
variable "curated_stream_name" {}

# Look up default VPC
data "aws_vpc" "default" {
  default = true
}

# Get public subnets in the default VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get a security group for ECS tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-tasks-sg"
  description = "Allow ECS tasks to access the internet"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "firehose_cluster" {
  name = "firehose-ecs-cluster"
}

resource "aws_ecr_repository" "firehose_producer_repo" {
  name = "firehose-producer"
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole-producer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "firehose_producer" {
  family                   = "firehose-producer-task"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "producer"
      image     = "${aws_ecr_repository.firehose_producer_repo.repository_url}:latest"
      essential = true
      environment = [
        {
          name  = "RAW_STREAM"
          value = var.raw_stream_name
        },
        {
          name  = "TRANSFORMED_STREAM"
          value = var.curated_stream_name
        },
        {
          name  = "AWS_REGION"
          value = var.region
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "firehose_producer" {
  name            = "firehose-producer-service"
  cluster         = aws_ecs_cluster.firehose_cluster.id
  task_definition = aws_ecs_task_definition.firehose_producer.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = data.aws_subnets.public.ids
    security_groups = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.firehose_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.firehose_producer.name
}

output "ecr_repo_uri" {
  value = aws_ecr_repository.firehose_producer_repo.repository_url
}

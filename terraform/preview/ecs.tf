resource "aws_ecs_task_definition" "app" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name    = var.app_name
      image   = var.container_image

      portMappings = [
        {
          containerPort = 9292
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "REDIS_URL"
          value = var.redis_url
        },
        {
          name = "ENV_ID",
          value = var.env_id
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "${var.app_name}-${var.env_id}-task"
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app_name}-${var.env_id}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "Allow traffic from ALB"
    from_port       = 9292
    to_port         = 9292
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-ecs-tasks-sg"
  }
}

resource "aws_ecs_service" "app" {
  name            = "${var.app_name}-${var.env_id}-service"
  cluster         = var.ecs_cluster_id 
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = var.app_name
    container_port   = 9292
  }

  depends_on = [
    aws_lb_listener_rule.app
  ]

  tags = {
    Name = "${var.app_name}-service"
  }
}

resource "aws_security_group_rule" "redis_from_ecs" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_tasks.id
  security_group_id        = var.redis_sg_id
  description              = "Allow Redis access from ECS tasks"
}

resource "aws_ecs_cluster" "devops_cluster" {
  name = "${var.service_name}-${var.env}-cluster"
}

resource "aws_ecs_task_definition" "devops_task" {
  family                   = "${var.service_name}-${var.env}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name  = "${var.service_name}-${var.env}"
      image = "${aws_ecr_repository.devops_repo.repository_url}:latest"
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "ASPNETCORE_ENVIRONMENT", value = "Production" },
        { name = "JWT_SECRET", value = "REPLACE_WITH_SECRET" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.service_name}-${var.env}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.service_name}-${var.env}"
  retention_in_days = 14
}

resource "aws_ecs_service" "devops_service" {
  name            = "${var.service_name}-${var.env}"
  cluster         = aws_ecs_cluster.devops_cluster.id
  task_definition = aws_ecs_task_definition.devops_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = module.vpc.private_subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.devops_tg.arn
    container_name   = "${var.service_name}-${var.env}"
    container_port   = 80
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.devops_tg_433.arn
    container_name   = "${var.service_name}-${var.env}"
    container_port   = 433
  }
  depends_on = [
    aws_ecs_cluster.devops_cluster,
    aws_ecs_task_definition.devops_task,
    aws_security_group.ecs_sg,
    aws_lb_target_group.devops_tg,
    aws_lb_target_group.devops_tg_433,
    aws_lb_listener.devops_listener,
    aws_lb_listener.devops_listener_433
  ]
}

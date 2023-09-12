# Provision an nginx container in ECS Fargate

resource "aws_ecs_cluster" "dinhvt_ecs_cluster" {
  name = "dinhvt-ecs-cluster"

  # Enable logging
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "dinhvt_esc_service" {
  name            = "dinhvt-esc-service"
  cluster         = aws_ecs_cluster.dinhvt_ecs_cluster.id
  task_definition = aws_ecs_task_definition.dinhvt-task-definition.arn
  desired_count   = 1

  # This parameter is required if you are using a load balancer with your service,
  # but only if your task definition does not use the awsvpc network mode.
  # If using `awsvpc` network mode, do not specify this role.
  # If your account has already created the Amazon ECS service-linked role,
  # that role is used by default for your service unless you specify a role here.
  # iam_role = aws_iam_role.ecs_task_role.arn

  launch_type = "FARGATE"

  network_configuration {
    security_groups = [var.security_group_id]
    subnets         = [var.subnet_id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_load_balancer_target_group.arn
    container_name   = "dinhvt-container"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "dinhvt-task-definition" {
  family = "dinhvt-task"

  # Provision an simple nginx container
  container_definitions = jsonencode([{
    name  = "dinhvt-container"
    image = "nginx:latest"
    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]
  }])

  requires_compatibilities = ["FARGATE"]
  # Fargate task definitions require a network mode of awsvpc.
  network_mode = "awsvpc"

  # 0.25 vCPU
  cpu = 256

  # 512MB of memory
  memory = 512
}

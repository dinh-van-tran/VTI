resource "aws_lb" "ecs_load_balancer" {
  name                       = "ecs-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.security_group_id]
  subnets                    = var.subnet_ids
  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "dinhvt-lb-logs"
  #   enabled = true
  # }

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "ecs_load_balancer_target_group" {
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path = "/"
  }

  tags = {
    Name        = "example-tg"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "ecs_load_balancer_listener" {
  load_balancer_arn = aws_lb.ecs_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_load_balancer_target_group.arn
  }
}

resource "aws_lb" "devops_alb" {
  name               = "${var.service_name}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "devops_tg" {
  name        = "${var.service_name}-${var.env}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip" # ✅ Correcto para Fargate
  health_check {
    path                = "/DevOps"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "devops_listener" {
  load_balancer_arn = aws_lb.devops_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_tg.arn
  }
}

##########################################################
##########################################################
/*
resource "aws_lb_target_group" "devops_tg_433" {
  name        = "${var.service_name}-${var.env}-tg-433"
  port        = 433
  protocol    = "HTTPS"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip" # ✅ Correcto para Fargate
  health_check {
    path                = "/DevOps"
    protocol            = "HTTPS"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "devops_listener_433" {
  load_balancer_arn = aws_lb.devops_alb.arn
  port              = "433"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devops_tg_433.arn
  }
}
*/

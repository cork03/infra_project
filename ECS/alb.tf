resource "aws_lb" "alb" {
  name               = "${var.project}-${var.enviroment}-alb"
  load_balancer_type = "application"
  internal           = false
  idle_timeout       = 60
  # 練習用で何回も削除する予定
  enable_deletion_protection = false

  subnets = [
    aws_subnet.public-alb-subnet-1a.id,
    aws_subnet.public-alb-subnet-1c.id
  ]

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id,
  ]
}

resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "これは「HTTP通信」です。"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "ecs-target" {
  name        = "${var.project}-${var.enviroment}-target-group"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  port        = 80
  protocol    = "HTTP"
  # ターゲット解除時の待ち時間
  deregistration_delay = 10

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [
    aws_lb.alb
  ]
}

resource "aws_lb_listener_rule" "ecs-listener-rule" {
  listener_arn = aws_lb_listener.http-listener.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-target.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}


module "http_sg" {
  source      = "../security_group"
  name        = "http_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source      = "../security_group"
  name        = "https_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "http_redirect_sg" {
  source      = "../security_group"
  name        = "http_redirect_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 8080
  cidr_blocks = ["0.0.0.0/0"]
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

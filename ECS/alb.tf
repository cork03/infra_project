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
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "これは「HTTP通信」です。"
      status_code = "200"
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

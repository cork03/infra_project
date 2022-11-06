resource "aws_lb" "alb" {
  name = "${var.project}-${var.enviroment}-alb"
  load_balancer_type = "application"
  internal = false
  idle_timeout = 60
  # 練習用で何回も削除する予定
  enable_deletion_protection = false
}

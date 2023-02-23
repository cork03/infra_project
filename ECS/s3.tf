#################
# alb_log bucket
#################
resource "aws_s3_bucket" "alb_log" {
  bucket = "${var.project}-${var.enviroment}-alb-log"
  force_destroy = true
}
resource "aws_s3_bucket_lifecycle_configuration" "alb_log_licecycle" {
  bucket = aws_s3_bucket.alb_log.bucket
  rule {
    id = "alb_log"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}

#################
# バケットポリシー
#################
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}
data "aws_iam_policy_document" "alb_log" {
  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type = "AWS"
      identifiers = ["582318560864"]
    }
  }
}

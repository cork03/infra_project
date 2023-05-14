resource "aws_acm_certificate" "infrapj" {
  domain_name = aws_route53_record.infra-pj.name
  subject_alternative_names = []
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

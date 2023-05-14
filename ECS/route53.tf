data "aws_route53_zone" "infra-pj" {
  name = "tsinfrapj.net"
}

resource "aws_route53_record" "infra-pj" {
  zone_id = data.aws_route53_zone.infra-pj.zone_id
  name = data.aws_route53_zone.infra-pj.name

  type = "A"

  alias {
    name = aws_lb.alb.dns_name
    zone_id = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cert" {
  zone_id = data.aws_route53_zone.infra-pj.zone_id
  for_each = {
    for dvo in aws_acm_certificate.infrapj.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name = each.value.name
  records = [ each.value.record ]
  type = each.value.type
  ttl = 60
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn = aws_acm_certificate.infrapj.arn
  validation_record_fqdns = [ for record in aws_route53_record.cert : record.fqdn ]
}

# 実行時に標準出力に表示
output "domain_name" {
  value = aws_route53_record.infra-pj.name
}


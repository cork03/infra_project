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

output "domain_name" {
  value = aws_route53_record.infra-pj.name
}


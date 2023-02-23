resource "aws_ssm_parameter" "db_username" {
  name        = "/db/username"
  value       = "root"
  type        = "String"
  description = "DB root UserName"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/db/password"
  value       = "password"
  type        = "SecureString"
  description = "DB password"

  lifecycle {
    ignore_changes = [value]
  }
}

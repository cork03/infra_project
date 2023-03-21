variable "name" {}
variable "policy" {}
variable "identifier" {}

# IAMロール
resource "aws_iam_role" "default" {
  # 入力された名前
  name = var.name
  # 指定したidentifierにassumrRoleしている
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# ポリシードキュメント
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [var.identifier]
    }
  }
}

# IAMポリシー
resource "aws_iam_policy" "default" {
  name = var.name
  policy = var.policy
}

# IAMロールにIAMポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "example" {
  role = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}

output "iam_role_name" {
  value = aws_iam_role.default.name
}

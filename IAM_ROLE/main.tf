variable "name" {}
variable "policy" {}
variable "identifier" {}

resource "aws_iam_role" "default" {
  name = var.name
}

resource "aws_iam_policy_document" "assume_role" {

}

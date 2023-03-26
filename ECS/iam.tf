data "aws_iam_policy" "ecs_task_excution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_excution" {
  source_policy_documents = [data.aws_iam_policy.ecs_task_excution_role_policy.policy]
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt", "secretsmanager:GetSecretValue"]
    resources = ["*"]
  }
}

module "ecs_task_excution_role" {
  source     = "../iam_role"
  name       = "ecs-task-excution-role"
  policy     = data.aws_iam_policy_document.ecs_task_excution.json
  identifier = "ecs-tasks.amazonaws.com"
}

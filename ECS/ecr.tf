resource "aws_ecr_repository" "example" {
  name = "example"
}

resource "aws_ecr_lifecycle_policy" "name" {
  repository = aws_ecr_repository.example.name

  # releaseのタグがついているものを30個までに制限
  policy = <<EOF
  [
    "rule": [
      {
        "rulePriority": 1,
        "description": "Keep last 30 release tagged images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["release"],
          "countType": "imageCountMoreThan",
          "countNumber": 30,
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  ]
EOF
}

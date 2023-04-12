aws_region = "us-east-1"
project_name = "backend-infra-app-react"
environment = "dev"
users_ready_only = [
  "arn:aws:iam::012345678901:user/viniciustrainotti"
]
users_write_permissions = [
  "arn:aws:iam::012345678901:user/viniciustrainotti"
]
tags = {
  "Environment" = "dev"
  "Project" = "backend-infra-app-react"
  "ManagedBy" = "Terraform"
}
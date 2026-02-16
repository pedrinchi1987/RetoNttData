data "aws_lb" "devops_alb" {
  name = "${var.service_name}-${var.env}-alb"
}

data "aws_iam_role" "lambda_exec_role" {
  name = "lambdaAuthorizerExecRole-${var.env}"
}

output "alb" {
  value = data.aws_lb.devops_alb
}

output "role" {
  value = data.aws_iam_role.lambda_exec_role
}
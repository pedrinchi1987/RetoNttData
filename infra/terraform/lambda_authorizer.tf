/*
resource "aws_lambda_function" "jwt_authorizer" {
  filename         = "${path.module}/lambda/lambda_authorizer.zip"
  function_name    = "${var.service_name}-jwt-authorizer"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  source_code_hash = filebase64sha256("${path.module}/lambda/lambda_authorizer.zip")
  timeout          = 10
  environment {
    variables = {
      JWT_SECRET = "REPLACE_WITH_SECRET"
    }
  }
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.jwt_authorizer.function_name
  principal     = "apigateway.amazonaws.com"
}
*/

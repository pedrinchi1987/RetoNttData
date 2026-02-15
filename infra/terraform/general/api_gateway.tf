resource "aws_api_gateway_rest_api" "devops_api" {
  name        = "${var.service_name}-${var.env}-api"
  description = "API Gateway for DevOps Microservice"
}

resource "aws_api_gateway_resource" "devops_resource" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id
  parent_id   = aws_api_gateway_rest_api.devops_api.root_resource_id
  path_part   = "DevOps"
}

resource "aws_api_gateway_method" "devops_post" {
  rest_api_id   = aws_api_gateway_rest_api.devops_api.id
  resource_id   = aws_api_gateway_resource.devops_resource.id
  http_method   = "POST"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.devops_authorizer.id
  request_parameters = {
    "method.request.header.X-Parse-REST-API-Key" = true
  }
}

resource "aws_api_gateway_integration" "devops_integration" {
  rest_api_id             = aws_api_gateway_rest_api.devops_api.id
  resource_id             = aws_api_gateway_resource.devops_resource.id
  http_method             = aws_api_gateway_method.devops_post.http_method
  type                    = "HTTP"
  integration_http_method = "POST"
  uri                     = "http://${data.aws_lb.devops_alb.dns_name}/DevOps"
  connection_type         = "INTERNET"
}

resource "aws_api_gateway_authorizer" "devops_authorizer" {
  name                             = "devops-authorizer-${var.env}"
  rest_api_id                      = aws_api_gateway_rest_api.devops_api.id
  authorizer_uri                   = aws_lambda_function.jwt_authorizer.invoke_arn
  authorizer_result_ttl_in_seconds = 0
  identity_source                  = "method.request.header.X-JWT-KWY"
  type                             = "REQUEST"
}

resource "aws_cloudwatch_log_group" "apigw_logs" {
  name              = "/aws/apigateway/${var.service_name}-${var.env}"
  retention_in_days = 14
}

resource "aws_api_gateway_account" "api_account" {
  cloudwatch_role_arn = aws_iam_role.apigw_cloudwatch_role.arn

  depends_on = [
    aws_iam_role.apigw_cloudwatch_role,    
    aws_iam_role_policy_attachment.apigw_cloudwatch_policy
  ]
}

resource "aws_api_gateway_deployment" "devops_deployment" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id

  depends_on = [
    aws_api_gateway_integration.devops_integration
  ]
}

resource "aws_api_gateway_stage" "devops_stage" {
  stage_name    = var.env
  rest_api_id   = aws_api_gateway_rest_api.devops_api.id
  deployment_id = aws_api_gateway_deployment.devops_deployment.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigw_logs.arn

    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      caller         = "$context.identity.caller"
      user           = "$context.identity.user"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  xray_tracing_enabled = true

  depends_on = [
    aws_api_gateway_account.api_account
    aws_api_gateway_rest_api.devops_api,
    aws_api_gateway_deployment.devops_deployment,
    aws_cloudwatch_log_group.apigw_logs
  ]
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.devops_api.id
  stage_name  = aws_api_gateway_stage.devops_stage.stage_name
  method_path = "*/*"

  settings {
    logging_level      = "INFO" # ERROR | INFO
    metrics_enabled    = true
    data_trace_enabled = true # Cuidado en prod (puede loggear payloads)
  }

  depends_on = [
    aws_api_gateway_rest_api.devops_api,
    aws_api_gateway_stage.devops_stage
  ]
}

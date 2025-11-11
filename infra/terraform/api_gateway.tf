/*
resource "aws_api_gateway_rest_api" "devops_api" {
  name        = "${var.service_name}-api"
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
  uri                     = "http://${aws_lb.devops_alb.dns_name}/DevOps"
  connection_type         = "INTERNET"
}

resource "aws_api_gateway_authorizer" "devops_authorizer" {
  name                             = "devops-authorizer"
  rest_api_id                      = aws_api_gateway_rest_api.devops_api.id
  authorizer_uri                   = aws_lambda_function.jwt_authorizer.invoke_arn
  authorizer_result_ttl_in_seconds = 0
  identity_source                  = "method.request.header.X-JWT-KWY"
  type                             = "REQUEST"
}
*/

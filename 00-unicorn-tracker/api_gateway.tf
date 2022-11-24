resource "aws_apigatewayv2_api" "unicorn" {
  name          = "unicorn"
  protocol_type = "HTTP"
}

resource "aws_lambda_permission" "apigw" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.unicorn_lambda.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.unicorn.execution_arn}/*/*"
}

resource "aws_apigatewayv2_route" "getAllItems" {
  api_id    = aws_apigatewayv2_api.unicorn.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda-get.id}"
}

resource "aws_apigatewayv2_route" "putItem" {
  api_id    = aws_apigatewayv2_api.unicorn.id
  route_key = "PUT /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda-get.id}"
}

resource "aws_apigatewayv2_route" "getItemId" {
  api_id    = aws_apigatewayv2_api.unicorn.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda-get.id}"
}

resource "aws_apigatewayv2_route" "DeleteItem" {
  api_id    = aws_apigatewayv2_api.unicorn.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda-get.id}"
}

resource "aws_apigatewayv2_integration" "lambda-get" {
  api_id           = aws_apigatewayv2_api.unicorn.id
  integration_type = "AWS_PROXY"

  connection_type        = "INTERNET"
  description            = "This is our Lambda integration"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.unicorn_lambda.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"

  lifecycle {
    ignore_changes = [
      passthrough_behavior
    ]
  }
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.unicorn.id
  name        = "prod"
  auto_deploy = true

  lifecycle {
    ignore_changes = [
      deployment_id,
      default_route_settings
    ]
  }
}

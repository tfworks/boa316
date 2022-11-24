output "api_gateway_url" {
  value = aws_apigatewayv2_stage.prod.invoke_url
}

output "lambda_url" {
  value = aws_lambda_function_url.unicorn_api.function_url
}

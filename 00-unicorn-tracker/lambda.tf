resource "aws_iam_role_policy" "unicorn" {
  name = "unicorn_policy"
  role = aws_iam_role.unicorn.id

  policy = templatefile("files/policy.tftpl", {
    dynamodbarn = aws_dynamodb_table.unicorntracker.arn
  })
}

resource "aws_iam_role" "unicorn" {
  name               = "unicorn_lambda"
  assume_role_policy = file("files/assume_role_policy.json")
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_api.js"
  output_path = "${path.module}/files/lambda_api.zip"
}

resource "aws_lambda_function" "unicorn_lambda" {
  filename         = "${path.module}/files/lambda_api.zip"
  function_name    = "unicorn_dynamo"
  role             = aws_iam_role.unicorn.arn
  handler          = "lambda_api.handler"
  source_code_hash = filebase64sha256("${path.module}/files/lambda_api.zip")
  runtime          = "nodejs12.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function_url" "unicorn_api" {
  function_name      = aws_lambda_function.unicorn_lambda.function_name
  authorization_type = "NONE"
}

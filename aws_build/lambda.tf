data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "iot_publish" {
  statement {
    effect = "Allow"

    actions = ["iot:Publish"]

    resources = [
      "arn:aws:iot:*:735140960268:topic/github/*",
      "arn:aws:iot:*:735140960268:topic/gitlab/*",
    ]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name                = "pipeline-dashboard-api"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  inline_policy {
    name   = "iot_publish"
    policy = data.aws_iam_policy_document.iot_publish.json
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "../fn_code/"
  output_path = "../lambda_function_payload.zip"
}

resource "aws_lambda_function" "api_handler" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "../lambda_function_payload.zip"
  function_name = "pipeline-dashboard-api"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "src/index.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs18.x"
}

resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example.execution_arn}/*"
}

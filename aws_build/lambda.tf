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

resource "aws_iam_role" "iam_for_lambda" {
  name               = "pipeline-dashboard-api"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
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

locals {
  oas_template = file("oas.json")
  # oas = merge(local.oas_template, {
  #   paths = {
  #     "/inbound/{provider}/{repo}" = {
  #       "x-amazon-apigateway-any-method" = {
  #         "x-amazon-apigateway-integration" = {
  #           uri = "arn:aws:apigateway:${var.AWS_REGION}:lambda:path/2015-03-31/functions/${aws_lambda_function.api_handler.arn}"
  #         }
  #       }
  #     }
  #   }
  # })
  oas = replace(replace(local.oas_template, "AWS_REGION", var.AWS_REGION), "LAMBDA_ARN", aws_lambda_function.api_handler.arn)
}

resource "aws_api_gateway_rest_api" "example" {
  body = local.oas

  name = "example"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

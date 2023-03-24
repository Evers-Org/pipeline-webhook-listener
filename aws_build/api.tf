resource "aws_api_gateway_rest_api" "example" {
  body = jsonencode(file("oas.json"))

  name = "example"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

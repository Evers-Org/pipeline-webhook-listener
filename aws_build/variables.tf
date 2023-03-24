variable "AWS_REGION" {
  type    = string
  default = "us-east-2"
}

variable "AWS_ACCESS_KEY" {
  type = string
}

variable "AWS_SECRET_KEY" {
  type = string
}

variable "STAGE_NAME" {
  type    = string
  default = "dev"
}

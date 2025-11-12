variable "aws_region" {
  type    = string
  default = "us-east-1"
}

/*
variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}
*/

variable "service_name" {
  type    = string
  default = "devops-service"
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-west-2"
}

variable "aws_account" {
  description = "Account number to create aws resources in. This variable should be defined in the terraform cloud workspace settings"
}
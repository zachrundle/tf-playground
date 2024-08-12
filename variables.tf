variable "name" {
  type = string
}

variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "aws_account" {
  description = "Account number to create AWS resources in. This variable should be defined in the Terraform Cloud workspace settings"
}
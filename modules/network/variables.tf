variable "name" {
  description = "Provide the name of the project"
}

variable "vpc_cidr" {
  description = "Provide the /16 cidr for the vpc"
}

variable "create_ngw" {
  default = false
}
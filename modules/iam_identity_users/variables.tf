variable "users" {
  description = "Map of user identifiers to user details including their team."
  type = map(object({
    first_name = string
    last_name  = string
  }))
}

variable "email_domain" {
    description = "Domain of the company"
    type = string
    default = "example.com"
}
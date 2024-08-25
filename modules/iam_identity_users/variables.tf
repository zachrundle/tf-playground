variable "users" {
  description = "Map of user identifiers to user details including their team."
  type = map(object({
    first_name = string
    last_name  = string
    # TODO: add support in case a user needs to belong to multiple groups
    groups     = string
  }))
}

variable "email_domain" {
  description = "Domain used for user email accounts"
  type        = string
  default     = "example.com"
}

variable "groups" {
  description = "List of IAM identity center groups to create"
  type        = set(string)
  default     = []
}
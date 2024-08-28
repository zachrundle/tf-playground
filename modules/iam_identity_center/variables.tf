variable "permission_sets" {
  type = list(object({
    name               = string
    description        = string
    relay_state        = string
    session_duration   = string
    tags               = map(string)
    inline_policy      = string
    policy_attachments = list(string)
    customer_managed_policy_attachments = list(object({
      name = string
      path = optional(string, "/")
    }))
  }))

  default = []
}

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

variable "aws_account" {
  description = "Account number to create aws resources in. This variable should be defined in the terraform cloud workspace settings"
}

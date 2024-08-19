variable "aws_account" {
  description = "Account number to create aws resources in. This variable should be defined in the terraform cloud workspace settings"
}

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
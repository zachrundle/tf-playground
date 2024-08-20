data "aws_ssoadmin_instances" "this" {}



resource "aws_identitystore_user" "this" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  display_name = format("%s %s", users.first_name,  users.last_name)
  user_name    = format("%s%s", substr(lower( users.first_name), 0, 1), lower( users.last_name))

  name {
    given_name  =  users.first_name
    family_name =  users.last_namee
  }

  emails {
    value = join("@", [format("%s.%s", lower( users.first_name), lower( users.last_name)), var.email_domain])
  }
}
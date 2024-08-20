data "aws_ssoadmin_instances" "this" {}



resource "aws_identitystore_user" "this" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  display_name = format("%s %s", each.value.first_name, each.value.last_name)
  user_name    = format("%s%s", substr(lower(each.value.first_name), 0, 1), lower(each.value.last_name))

  name {
    given_name  = each.value.first_name
    family_name = each.value.last_name
  }

  emails {
    value = join("@", [format("%s.%s", lower(each.value.first_name), lower(each.value.last_name)), var.email_domain])
  }
}
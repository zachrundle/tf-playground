# Fetching SSO Instance
data "aws_ssoadmin_instances" "this" {}

# Create SSO Groups
resource "aws_identitystore_group" "this" {
  for_each          = { for group_name in var.groups : group_name => group_name }
  display_name      = each.value
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# Create SSO Users
resource "aws_identitystore_user" "this" {
  for_each = var.users
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

# Assign Users to Groups
resource "aws_identitystore_group_membership" "this" {
  for_each =  var.users
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.this.group_id
  member_id         = aws_identitystore_user.this.user_id
}
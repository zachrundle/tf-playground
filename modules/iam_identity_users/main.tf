# Fetching SSO Instance
data "aws_ssoadmin_instances" "this" {}

# Define locals to structure the group and user data
locals {
  group_lists = [
    for group_name in var.groups : {
      group_name = group_name
      description = format("SSO group for %s", group_name)
    }
  ]

  user_lists = [
    for user_key, user in var.users : {
      user_key    = user_key
      display_name = format("%s %s", user.first_name, user.last_name)
      user_name    = format("%s%s", substr(lower(user.first_name), 0, 1), lower(user.last_name))
      email        = join("@", [format("%s.%s", lower(user.first_name), lower(user.last_name)), var.email_domain])
      groups       = user.groups
    }
  ]

  # Flatten user-group pairs for membership creation
  user_group_pairs = flatten([
    for user in local.user_lists : [
      for group_name in user.groups : {
        user_key   = user.user_key
        group_name = group_name
      }
    ]
  ])
}

# Create SSO Groups
resource "aws_identitystore_group" "this" {
  for_each = { for g in local.group_lists : g.group_name => g }

  display_name      = each.value.group_name
  description       = each.value.description
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# Create SSO Users
resource "aws_identitystore_user" "this" {
  for_each = { for u in local.user_lists : u.user_key => u }

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  display_name = each.value.display_name
  user_name    = each.value.user_name

  name {
    given_name  = each.value.display_name.split(" ")[0]
    family_name = each.value.display_name.split(" ")[1]
  }

  emails {
    value = each.value.email
  }
}

# Assign Users to Groups
resource "aws_identitystore_group_membership" "this" {
  for_each = {
    for pair in local.user_group_pairs : 
    format("%s-%s", pair.user_key, pair.group_name) => {
      group_id  = aws_identitystore_group.this[pair.group_name].id
      member_id = aws_identitystore_user.this[pair.user_key].id
    }
  }

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = each.value.group_id
  member_id         = each.value.member_id
}

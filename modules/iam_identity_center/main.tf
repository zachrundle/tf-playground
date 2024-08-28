data "aws_ssoadmin_instances" "this" {}

locals {
  sso_instance_arn    = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_map  = { for ps in var.permission_sets : ps.name => ps }
  inline_policies_map = { for ps in var.permission_sets : ps.name => ps.inline_policy if ps.inline_policy != "" }
  managed_policy_map  = { for ps in var.permission_sets : ps.name => ps.policy_attachments if length(ps.policy_attachments) > 0 }
  managed_policy_attachments = flatten([
    for ps_name, policy_list in local.managed_policy_map : [
      for policy in policy_list : {
        policy_set = ps_name
        policy_arn = policy
      }
    ]
  ])
  managed_policy_attachments_map = {
    for policy in local.managed_policy_attachments : "${policy.policy_set}.${policy.policy_arn}" => policy
  }
  customer_managed_policy_map = { for ps in var.permission_sets : ps.name => ps.customer_managed_policy_attachments if length(ps.customer_managed_policy_attachments) > 0 }
  customer_managed_policy_attachments = flatten([
    for ps_name, policy_list in local.customer_managed_policy_map : [
      for policy in policy_list : {
        policy_set  = ps_name
        policy_name = policy.name
        policy_path = policy.path
      }
    ]
  ])
  customer_managed_policy_attachments_map = {
    for policy in local.customer_managed_policy_attachments : "${policy.policy_set}.${policy.policy_path}${policy.policy_name}" => policy
  }
}

resource "aws_ssoadmin_permission_set" "this" {
  for_each         = local.permission_set_map
  name             = each.key
  description      = each.value.description
  instance_arn     = local.sso_instance_arn
  relay_state      = each.value.relay_state != "" ? each.value.relay_state : null
  session_duration = each.value.session_duration != "" ? each.value.session_duration : null
  tags             = each.value.tags != "" ? each.value.tags : null
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each           = local.inline_policies_map
  inline_policy      = each.value
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each           = local.managed_policy_attachments_map
  instance_arn       = local.sso_instance_arn
  managed_policy_arn = each.value.policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.policy_set].arn
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "this" {
  for_each           = local.customer_managed_policy_attachments_map
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.policy_set].arn
  customer_managed_policy_reference {
    name = each.value.policy_name
    path = coalesce(each.value.policy_path, "/")
  }
}

resource "aws_identitystore_group" "this" {
  for_each          = { for group_name in var.groups : group_name => group_name }
  display_name      = each.value
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

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

resource "aws_identitystore_group_membership" "this" {
  for_each =  var.users
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id          = aws_identitystore_group.this[each.value.groups].group_id
  member_id         = aws_identitystore_user.this[each.key].user_id
}

resource "aws_ssoadmin_account_assignment" "this" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.policy_set].arn

  principal_id   = data.aws_identitystore_group.this.group_id
  principal_type = "GROUP"

  target_id   = var.aws_account
  target_type = "AWS_ACCOUNT"
}

module "users" {
  source           = "./modules/iam_identity_users"
  users = {
    "user" = {
      first_name = "Zach"
      last_name   = "Rundle"
    },
    "user" = {
      first_name = "Maverick"
      last_name   = "Dog"
    },
  }
}
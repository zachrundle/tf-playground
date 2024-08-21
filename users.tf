module "users" {
  source = "./modules/iam_identity_users"
  
  users = {
    "Zach Rundle" = {
      first_name = "Zach"
      last_name  = "Rundle"
      groups     = ["administrators"]
    },
    "Maverick Dog" = {
      first_name = "Maverick"
      last_name  = "Dog"
      groups     = ["developers", "qa"]
    },
  }
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "cloudcodecoffee"
    workspaces { name = "playground" }
  }
}
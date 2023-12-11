# --- root/backend.tf ---

terraform {
  backend "s3" {
    bucket = "jenkinsbucket091296"
    key    = "remote.tfstate"
    region = "ca-central-1"
  }
}

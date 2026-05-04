data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket = "diaa-terraform-state-bucket"
    key    = "eks/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

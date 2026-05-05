terraform {
  backend "s3" {
    bucket         = "diaa-terraform-state-backend"
    key            = "eks/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
   }
}

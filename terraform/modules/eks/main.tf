module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name    = "backend-eks"
  cluster_version = "1.29"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  enable_irsa = true   #IAM Roles for Service Accounts

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      labels = {
        role = "backend"
      }

      tags = {
        Environment = "dev"
      }
    }
  }

  tags = {
    Project = "k8s-scalable-backend"
  }
}

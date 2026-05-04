resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set = [
    {
      name  = "clusterName"
      value = data.terraform_remote_state.infra.outputs.cluster_name
    },
    {
      name  = "region"
      value = "us-east-1"
    },
    {
      name  = "vpcId"
      value = data.terraform_remote_state.infra.outputs.vpc_id
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    }
  ]
}

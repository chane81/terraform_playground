locals {
  eks_cluster_name = "eks-mos-dev-CfW6rBl9"
}

data "aws_eks_cluster" "cluster" {
  name = local.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.eks_cluster_name
}

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }

# aws-load-balancer-controller 라는 k8s 서비스 계정에 대한 IAM 역할 연결
# resource "null_resource" "helm-eks-repo" {
#   provisioner "local-exec" {
#     command     = "helm repo add eks https://aws.github.io/eks-charts;helm repo update;"
#     interpreter = ["/bin/sh", "-c"]
#   }
# }


provider "helm" {
  # kubernetes {
  #   config_path = "~/.kube/config"
  # }

  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "helm_release" "aws-alb-controller" {
  # depends_on = [
  #   null_resource.helm-eks-repo
  # ]

  // repository = "https://aws.github.io/eks-charts"
  name      = "aws-load-balancer-controller"
  chart     = "eks/aws-load-balancer-controller"
  namespace = "kube-system"


  # set {
  #   name  = "name"
  #   value = "aws-load-balancer-controller"
  # }

  set {
    name  = "clusterName"
    value = local.eks_cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  # set {
  #   name  = "image.repository"
  #   value = var.alb-controller-image
  # }

  # set {
  #   name  = "region"
  #   value = var.aws_region
  # }

  # set {
  #   name  = "vpcId"
  #   value = var.vpc-id
  # }
}

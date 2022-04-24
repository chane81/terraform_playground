data "aws_eks_cluster" "cluster" {
  name = "test-eks-cluster"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

  # kubernetes {
  #   host                   = data.aws_eks_cluster.cluster.endpoint
  #   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  #   #token                  = data.aws_eks_cluster_auth.cluster.token
  #   #load_config_file = "false"
  # }
}

resource "helm_release" "aws-load-balancer-controller" {
  // repository = "https://aws.github.io/eks-charts"
  name      = "aws-load-balancer-controller"
  chart     = "eks/aws-load-balancer-controller"
  namespace = "kube-system"


  set {
    name  = "name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = var.cluster-name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "image.repository"
    value = var.alb-controller-image
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = var.vpc-id
  }
}

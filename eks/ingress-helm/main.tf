data "aws_eks_cluster" "cluster" {
  name = "test-eks-cluster"
}

# aws-load-balancer-controller 라는 k8s 서비스 계정에 대한 IAM 역할 연결
resource "null_resource" "helm-eks-repo" {
  provisioner "local-exec" {
    command = "helm repo add eks https://aws.github.io/eks-charts;helm repo update;"
    interpreter = ["/bin/sh", "-c"]
  }
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
  depends_on = [
    null_resource.helm-eks-repo
  ]

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

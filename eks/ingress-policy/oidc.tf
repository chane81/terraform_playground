data "aws_eks_cluster" "eks-cluster" {
  name = var.cluster-name
}

# OIDC config
resource "aws_iam_openid_connect_provider" "oidc" {
  depends_on = [
    aws_iam_policy.policy
  ]

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = []
  url             = data.aws_eks_cluster.eks-cluster.identity.0.oidc.0.issuer
}

# aws-load-balancer-controller 라는 k8s 서비스 계정에 대한 IAM 역할 연결
resource "null_resource" "iam-service-account" {
  depends_on = [
    aws_iam_openid_connect_provider.oidc
  ]

  provisioner "local-exec" {
    command = "eksctl create iamserviceaccount --cluster=${var.cluster-name} --namespace=kube-system --name=aws-load-balancer-controller --attach-policy-arn=${aws_iam_policy.policy.arn} --override-existing-serviceaccounts --approve"
    interpreter = ["/bin/sh", "-c"]
  }
}

# aws alb 용 iam policy
resource "aws_iam_policy" "policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "aws alb iam policy"

  policy = file("iam-policy-eks-alb.json")
}

# aws-load-balancer-controller 라는 k8s 서비스 계정에 대한 IAM 역할 연결
# resource "null_resource" "iam-service-account" {
#   depends_on = [
#     module.eks
#   ]

#   provisioner "local-exec" {
#     command     = "eksctl create iamserviceaccount --cluster=${local.eks_cluster_name} --namespace=kube-system --name=aws-load-balancer-controller --attach-policy-arn=${aws_iam_policy.policy.arn} --override-existing-serviceaccounts --approve"
#     interpreter = ["/bin/sh", "-c"]
#   }
# }

## eks alb ingress 사용을 위한 policy 생성
resource "aws_iam_policy" "test-iam-role-eks-cluster" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  path = "/"
  description = "aws eks alb policy"

  policy = file("iam-policy-alb.json")
}

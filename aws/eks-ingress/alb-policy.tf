resource "aws_iam_policy" "policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "aws alb iam policy"

  policy = file("iam-policy-eks-alb.json")
}

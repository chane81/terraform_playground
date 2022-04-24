variable "aws_region" {
  default = "ap-northeast-2"
}

variable "cluster-name" {
  default = "test-eks-cluster"
  type    = string
}

variable "vpc-id" {
  default = "vpc-0d69a827b9697bf86"
  type    = string
}

variable "service-account" {
  default = "aws-load-balancer-controller"
  type    = string
}

variable "alb-controller-policy-arn" {
  default = "arn:aws:iam::292667926659:policy/AWSLoadBalancerControllerIAMPolicy"
  type    = string
}

variable "alb-controller-image" {
  default = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/amazon/aws-load-balancer-controller"
  type    = string
}


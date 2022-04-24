variable "aws_region" {
  default = "ap-northeast-2"
}

variable "cluster-name" {
  default = "test-eks-cluster"
  type    = string
}

variable "vpc-id" {
  default = "vpc-0d69a827b9697bf86"
  type = string
}
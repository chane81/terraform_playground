data "aws_availability_zones" "available" {
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket         = "mos-terraform-infra"
    region         = "ap-northeast-2"
    key            = "env:/${terraform.workspace}/aws/eks/terraform.tfstate"
    dynamodb_table = "terraform-lock"
    acl            = "bucket-owner-full-control"
  }
}

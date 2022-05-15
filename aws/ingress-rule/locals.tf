locals {
  environment = terraform.workspace
  region      = data.terraform_remote_state.eks.outputs.region
  vpc_id      = data.terraform_remote_state.eks.outputs.vpc_id
  cluster_id  = data.terraform_remote_state.eks.outputs.cluster_id
}

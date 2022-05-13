terraform {
  required_version = ">= 0.14.8"

  required_providers {
    aws        = ">= 3.72.0"
    local      = ">= 1.4"
    random     = ">= 2.1"
    kubernetes = ">= 2.10"
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  backend "s3" {
    bucket         = "mos-terraform-infra"
    key            = "aws/ingress/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-lock"
  }
}

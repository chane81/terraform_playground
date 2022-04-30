terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws        = ">= 3.72.0"
    local      = ">= 1.4"
    random     = ">= 2.1"
    kubernetes = ">= 2.10"
  }

  # backend "s3" {
  #   bucket         = "mos-infra"
  #   key            = "aws/eks/terraform.tfstate"
  #   region         = "ap-northeast-2"
  #   dynamodb_table = "terraform-lock"
  # }
}

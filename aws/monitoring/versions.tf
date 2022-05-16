terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws        = ">= 3.72.0"
    local      = ">= 1.4"
    random     = ">= 2.1"
    kubernetes = ">= 2.10"
    # helm       = ">= 2.1.1"
  }

  backend "s3" {
    bucket         = "mos-terraform-infra"
    key            = "aws/monitoring/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-lock"
  }
}

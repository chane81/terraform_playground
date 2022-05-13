resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  env = {
    dev = {
      region                    = "ap-northeast-2"
      subdomain                 = "dev"
      cluster_name              = ""
      vpc_name = ""
    }

    prod = {
      region                    = "ap-northeast-2" // 서울
      subdomain                 = "prod"
      cluster_name              = ""
      vpc_name = ""
    }
  }

  name        = "mos"
  environment = terraform.workspace
  subdomain   = local.env[terraform.workspace].subdomain
  region      = local.env[terraform.workspace].region

  postfix                   = random_string.suffix.result
  vpc_name                  = "vpc-${local.name}-${local.environment}-${local.postfix}"
  cluster_name              = local.env[terraform.workspace].cluster_name
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  region                    = "ap-northeast-2"
  ip_range_prefix           = "172.31"
  # cluster_service_ipv4_cidr = "10.20.0.0/16"
  subdomain                 = "dev"
  node_groups = {
    mos-apps-dev = {
      min_size     = 2
      max_size     = 5
      desired_size = 2

      # 4cpu 16GB RAM
      # t2.xlarge 0.2304
      # t3a.xlarge 0.1872

      # 2cpu 15.3GB RAM
      # r4.large 0.16

      # 2cpu 15GB RAM
      # r3.large 0.2

      instance_types = ["r4.large", "r3.large"]

      /** SPOT / ON_DEMAND */
      capacity_type = "SPOT"

      labels = {
        Environment = local.environment,
        target      = "application-service"
      }

      tags = {
        Name     = "${local.eks_cluster_name}-app"
        ExtraTag = "application"
      }

      # s3 access policy attach
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonS3FullAccess"
      ]

      update_config = {
        max_unavailable_percentage = 50
      }
    }
  }

  name        = "mos"
  environment = terraform.workspace
  subdomain   = local.env[terraform.workspace].subdomain
  region      = local.env[terraform.workspace].region

  postfix                   = random_string.suffix.result
  vpc_name                  = "vpc-${local.name}-${local.environment}-${local.postfix}"
  eks_cluster_name          = "eks-${local.name}-${local.environment}-${local.postfix}"
  ip_range_prefix           = local.env[terraform.workspace].ip_range_prefix
  cluster_service_ipv4_cidr = local.env[terraform.workspace].cluster_service_ipv4_cidr

  subnet-main-id  = module.vpc.private_subnets[2]
  subnet-alter-id = module.vpc.private_subnets[0]
}

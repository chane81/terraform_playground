resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  env = {
    dev = {
      region                    = "ap-northeast-2"
      ip_range_prefix           = "172.31"
      cluster_service_ipv4_cidr = "10.31.0.0/16"
      subdomain                 = "dev"
      node_groups = {
        mos_apps_dev = {
          name         = "mos-apps-dev"
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

          instance_types = ["t3.large"]

          /** SPOT / ON_DEMAND */
          capacity_type = "ON_DEMAND"

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

          disk_size = 50
          disk_type = "gp3"

          update_config = {
            max_unavailable_percentage = 50
          }
        }
      }
    }

    prod = {
      region                    = "ap-northeast-2" // 서울
      ip_range_prefix           = "172.41"
      cluster_service_ipv4_cidr = "10.41.0.0/16"
      subdomain                 = "prod"
      # node_groups = {
      #   apps-c = {
      #     subnets          = ["subnet-031c41c5412fa4b34"] // az-c
      #     name_prefix      = "live-0eRNgcbz-apps-c-"

      #     desired_capacity = 3
      #     max_capacity     = 20
      #     min_capacity     = 2

      #     instance_types  = ["m6i.2xlarge" /* 0.472 USD */]
      #     disk_size       = 48
      #     disk_type       = "gp3"
      #     disk_throughput = 130
      #     disk_iops       = 1000

      #     #          create_launch_template = true
      #     k8s_labels             = {
      #       Environment = local.environment,
      #       target = "service.application"
      #     }
      #     additional_tags        = { ExtraTag = "application" }
      #     update_config          = { max_unavailable_percentage = 50 /* or set `max_unavailable` */ }
      #   }
      # }
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

  # alb 컨트롤러 설정 관련
  lb_controller_iam_role_name        = "role-${local.name}-${local.environment}-lb-controller"
  lb_controller_service_account_name = "account-${local.name}-${local.environment}-lb"
}

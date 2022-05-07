resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  env = {
    monitoring = {
      region                    = "ap-northeast-2"
      ip_range_prefix           = "172.20"
      cluster_service_ipv4_cidr = "10.20.0.0/16"
      subdomain                 = "monitoring"
      node_groups = {
        mos_monitoring = {
          name = "mos-monitoring"

          min_size     = 1
          max_size     = 5
          desired_size = 1

          # 2cpu 8GB RAM
          # t3a.large 0.0936

          # 4cpu 16GB RAM
          # t2.xlarge 0.2304
          # t3a.xlarge 0.1872

          # 2cpu 15.3GB RAM
          # r4.large 0.16

          # 2cpu 15GB RAM
          # r3.large 0.2

          # devtron 권고상 적어도 아래 2개 인스턴스 타입을 명시해야함 - At least two instance types should be specified
          # https://devtron.ai/blog/creating-production-grade-kubernetes-eks-cluster-eksctl/
          instance_types = ["r4.large", "r3.large"]
          # instance_types = ["t3.medium", "t3.large"]

          /** SPOT / ON_DEMAND */
          capacity_type = "ON_DEMAND"

          labels = {
            Environment = local.environment,
            target      = "dev-ops-service"
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

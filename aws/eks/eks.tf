module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  # depends_on = [module.vpc]

  cluster_name    = local.eks_cluster_name
  cluster_version = "1.21"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_service_ipv4_cidr = local.cluster_service_ipv4_cidr

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # cluster_encryption_config = [{
  #   provider_key_arn = "ac01234b-00d9-40f6-ac95-e42345f78b00"
  #   resources        = ["secrets"]
  # }]

  tags = {
    Environment = local.environment
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets


  eks_managed_node_group_defaults = {
    disk_size      = 32
    instance_types = ["t3.medium"]
  }

  # eks_managed_node_groups = local.env[terraform.workspace].node_groups
  eks_managed_node_groups = {
    mos-apps-dev = {
      min_size     = 2
      max_size     = 5
      desired_size = 2

      instance_types = ["t3.medium"]

      /** SPOT / ONDEMAND */
      capacity_type = "SPOT"

      labels = {
        Environment = local.environment,
        target      = "application-service"
      }

      tags = {
        Name     = "${local.eks_cluster_name}-app"
        ExtraTag = "application"
      }

      update_config = {
        max_unavailable_percentage = 50
      }
    }
  }


  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles    = var.map_roles
  aws_auth_users    = var.map_users
  aws_auth_accounts = var.map_accounts
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  # depends_on = [module.vpc]

  cluster_name    = local.eks_cluster_name
  cluster_version = "1.21"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_service_ipv4_cidr       = local.cluster_service_ipv4_cidr

  # alb-ingress 사용을 위해 필요
  # 아래 에러 대응(ingress.yml 파일 배포시 에러)
  # Error from server (InternalError): error when creating "ingress.yaml": Internal error occurred: failed calling webhook "vingress.elbv2.k8s.aws": Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/validate-networking-v1-ingress?timeout=10s": context deadline exceeded
  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
  }
  #node_security_group_description = "elbv2.k8s.aws/targetGroupBinding=shared"

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


  # node group 설정 ===========================
  eks_managed_node_group_defaults = {
    disk_size      = 32
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = local.env[terraform.workspace].node_groups

  # self_managed_node_group_defaults = {
  #   instance_type                          = "m6i.large"
  #   update_launch_template_default_version = true
  #   iam_role_additional_policies = [
  #     "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  #   ]
  # }

  # self_managed_node_groups = {
  #   mos-monitoring = {
  #     name = "mos-monitoring"

  #     min_size      = 2
  #     max_size      = 5
  #     desired_size  = 2
  #     instance_type = "r4.large"

  #     bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"

  #     block_device_mappings = {
  #       xvda = {
  #         device_name = "/dev/xvda"
  #         ebs = {
  #           delete_on_termination = false
  #           encrypted             = false
  #           volume_size           = 100
  #           volume_type           = "gp3"
  #         }

  #       }
  #     }
  #   }
  # }
  # node group 설정 ===========================

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles    = var.map_roles
  aws_auth_users    = var.map_users
  aws_auth_accounts = var.map_accounts
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  # depends_on = [module.vpc]

  cluster_name                    = local.eks_cluster_name
  cluster_version                 = "1.22"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_service_ipv4_cidr       = local.cluster_service_ipv4_cidr

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node all port"
      protocol                   = "-1"
      from_port                  = 0
      to_port                    = 0
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    # alb-ingress 사용을 위해 필요
    # 아래 에러 대응(ingress.yml 파일 배포시 에러)
    # Error from server (InternalError): error when creating "ingress.yaml": Internal error occurred: failed calling webhook "vingress.elbv2.k8s.aws": Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/validate-networking-v1-ingress?timeout=10s": context deadline exceeded
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }

    # node간의 통신 네트워크통신에 대한 설정
    # 이부분이 빠지면 devtron 이 1 node에선 작동하나 멀티 노드에서는
    # 작동이 되지 않는다.
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }


    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # cluster_encryption_config = [{
  #   provider_key_arn = "ac01234b-00d9-40f6-ac95-e42345f78b00"
  #   resources        = ["secrets"]
  # }]

  tags = {
    Environment = local.environment
  }


  eks_managed_node_group_defaults = {
    disk_size      = 32
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = local.env[terraform.workspace].node_groups


  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles    = var.map_roles
  aws_auth_users    = var.map_users
  aws_auth_accounts = var.map_accounts
}

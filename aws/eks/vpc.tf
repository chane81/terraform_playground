module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name                 = local.vpc_name
  cidr                 = "${local.ip_range_prefix}.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets  = [
    "${local.ip_range_prefix}.200.0/22",
    "${local.ip_range_prefix}.204.0/22",
    "${local.ip_range_prefix}.208.0/22",
    "${local.ip_range_prefix}.212.0/22"
  ]
  private_subnets = [
    "${local.ip_range_prefix}.100.0/22",
    "${local.ip_range_prefix}.104.0/22",
    "${local.ip_range_prefix}.108.0/22",
    "${local.ip_range_prefix}.112.0/22"
  ]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "Name" = "subnet-${local.vpc_name}-public"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                          = "1"
  }

  private_subnet_tags = {
    "Name" = "subnet-${local.vpc_name}-private"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = "1"
  }
}


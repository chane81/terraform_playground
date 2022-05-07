resource "aws_eip" "nat" {
  count = 3

  vpc = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name = local.vpc_name
  cidr = "${local.ip_range_prefix}.0.0/16"
  azs  = data.aws_availability_zones.available.names
  public_subnets = [
    "${local.ip_range_prefix}.200.0/23",
    "${local.ip_range_prefix}.210.0/23",
    "${local.ip_range_prefix}.220.0/23"
  ]
  private_subnets = [
    "${local.ip_range_prefix}.100.0/23",
    "${local.ip_range_prefix}.110.0/23",
    "${local.ip_range_prefix}.120.0/23"
  ]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  reuse_nat_ips       = true             # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = aws_eip.nat.*.id # <= IPs specified here as input to the module

  public_subnet_tags = {
    "Name"                                            = "subnet-${local.vpc_name}-public"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                          = "1"
  }

  private_subnet_tags = {
    "Name"                                            = "subnet-${local.vpc_name}-private"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                 = "1"
  }
}

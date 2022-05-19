output "region" {
  value = local.region
}

output "environment" {
  value = local.environment
}

output "subdomain" {
  value = local.subdomain
}

output "cluster_name" {
  value = local.eks_cluster_name
}

output "ip_range_prefix" {
  description = "ip range prefix"
  value       = local.ip_range_prefix
}

output "share_name" {
  value = "${local.name}-${local.environment}-${local.postfix}"
}

output "vpc_name" {
  value = local.vpc_name
}

output "vpc_id" {
  description = "vpc id - EKS Cluster"
  value       = module.vpc.vpc_id
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "cluster_id" {
  description = "cluster id"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "cluster security-group-id"
  value       = module.eks.cluster_security_group_id
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.aws_auth_configmap_yaml
}

output "node_groups" {
  description = "eks-managed node-groups"
  value       = module.eks.eks_managed_node_groups
}

output "argocd_alb_host" {
  description = "argocd alb host"
  value       = data.kubernetes_ingress_v1.argocd_ingress.status.0.load_balancer.0.ingress.0.hostname
}


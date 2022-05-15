output "region" {
  value = local.region
}

output "vpc_id" {
  description = "vpc id - EKS Cluster"
  value       = local.vpc_id
}

output "cluster_id" {
  description = "cluster id"
  value       = local.cluster_id
}

output "service_ingress" {
  description = "service ingress"
  value       = data.kubernetes_ingress_v1.service_ingress.status.0.load_balancer.0.ingress
}

output "prometheus_ingress" {
  description = "prometheus ingress"
  value       = data.kubernetes_ingress_v1.prometheus_ingress.status.0.load_balancer.0.ingress
}

output "ingress_ALB_host_name" {
  description = "ingress hostname"
  value       = data.kubernetes_ingress_v1.service_ingress.status.0.load_balancer.0.ingress.0.hostname
}

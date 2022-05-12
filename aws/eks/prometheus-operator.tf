# resource "kubernetes_namespace" "prometheus_namespace" {
#   metadata {
#     name = "prometheus"
#   }
# }

# module "prometheus" {
#   source  = "basisai/prometheus/helm"
#   version = "6.0.1"
#   # insert the 2 required variables here

#   depends_on = [
#     kubernetes_namespace.prometheus_namespace
#   ]

#   chart_namespace = "prometheus"
#   alertmanager_chart_namespace = "prometheus"
#   kube_state_metrics_chart_namespace = "prometheus"
#   kube_state_metrics_collection_namespace = "prometheus"
#   node_exporter_chart_namespace = "prometheus"


#   alertmanager_service_type = "NodePort"
#   kube_state_metrics_service_type= "NodePort"
#   node_exporter_service_type = "NodePort"
#   pushgateway_service_type = "NodePort"
#   server_service_type = "NodePort"

#   server_ingress_annotations = {
#     "alb.ingress.kubernetes.io/scheme" = "internet-facing"
#     "alb.ingress.kubernetes.io/target-type" = "ip"
#     "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
#   }
#   server_ingress_enabled = true
#   server_ingress_path = "/"

#   server_pv_size = "100Gi"
# }
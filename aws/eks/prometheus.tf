resource "helm_release" "prometheus" {
  name = "prometheus"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "35.2.0"
  namespace  = "prometheus"

  values = [
    "${file("./prometheus/values.yml")}"
  ]
}

# 그라파나 external 서비스
resource "kubernetes_service" "grafana_external_service" {
  metadata {
    name      = "grafana-external-service"
    namespace = "prometheus"
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = "prometheus"
      "app.kubernetes.io/name"     = "grafana"
    }
    port {
      port        = 80
      target_port = 3000
      protocol    = "TCP"
    }

    type = "NodePort"
  }

  depends_on = [
    helm_release.prometheus
  ]
}


# 프로메테우스 external 서비스
# resource "kubernetes_service" "prometheus_external-service" {
#   metadata {
#     name      = "prometheus-external-service"
#     namespace = "prometheus"
#   }
#   spec {
#     selector = {
#       "app.kubernetes.io/name" = "prometheus"
#       "prometheus"             = "prometheus-kube-prometheus-prometheus"
#     }
#     port {
#       port        = 80
#       target_port = 9090
#       protocol    = "TCP"
#     }

#     type = "NodePort"
#   }

#   depends_on = [
#     helm_release.prometheus
#   ]
# }

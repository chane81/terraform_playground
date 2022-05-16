resource "helm_release" "argocd" {
  name = "argo"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.6.0"
  namespace  = "argocd"

  values = [
    "${file("./argocd/values.yml")}"
  ]

  depends_on = [
    module.eks
  ]
}

# 그라파나 external 서비스
# resource "kubernetes_service" "argocd_external_service" {
#   metadata {
#     name      = "argocd-external-service"
#     namespace = "argocd"
#     labels = {
#       "app.kubernetes.io/component" = "server"
#       "app.kubernetes.io/instance" = "argo"
#       "app.kubernetes.io/managed-by" = "Helm"
#       "app.kubernetes.io/name" = "argocd-server"
#       "app.kubernetes.io/part-of" = "argocd"
#       "helm.sh/chart" = "argo-cd-4.6.0"
#     }
#     annotations = {
#       "meta.helm.sh/release-name": "argo"
#       "meta.helm.sh/release-namespace": "argocd"
#     }
#   }
#   spec {
#     selector = {
#       "app.kubernetes.io/instance" = "argo"
#       "app.kubernetes.io/name"     = "argocd-server"
#     }

#     port {
#       name = "http"
#       port        = 80
#       target_port = "server"
#       protocol    = "TCP"
#     }

#     port {
#       name = "https"
#       port = 443
#       target_port = "server"
#       protocol = "TCP"
#     }

#     type = "NodePort"
#   }

#   depends_on = [
#     helm_release.argocd
#   ]
# }

# resource "kubernetes_service" "argocd_grpc_service" {
#   metadata {
#     name      = "argogrpc"
#     namespace = "argocd"
#     labels = {
#       app = "argogrpc"
#     }
#     annotations = {
#       "alb.ingress.kubernetes.io/backend-protocol-version" = "HTTP2"
#     }
#   }
#   spec {
#     selector = {
#       "app.kubernetes.io/name" = "argocd-server"
#     }

#     port {
#       name        = "443"
#       port        = 443
#       target_port = 8080
#       protocol    = "TCP"
#     }

#     session_affinity = "None"
#     type             = "NodePort"
#   }

#   depends_on = [
#     helm_release.argocd
#   ]
# }

# # 서비스 인그레스 생성
resource "kubernetes_manifest" "argocd_ingress" {
  manifest = yamldecode(file("./argocd/argocd.ingress-rule.yml"))

  # lagacy 코드
  # wait_for = {
  #   complete = true

  #   fields = {
  #     "status.loadBalancer.ingress[0].hostname" = "*"
  #   }
  # }

  wait {
    fields = {
      "status.loadBalancer.ingress[0].hostname" = "*"
    }
  }

  # depends_on = [
  #   helm_release.argocd
  #   # kubernetes_service.argocd_grpc_service
  # ]
}

data "kubernetes_ingress_v1" "argocd_ingress" {
  metadata {
    name      = "argocd-ingress"
    namespace = "argocd"
  }

  depends_on = [
    kubernetes_manifest.argocd_ingress
  ]
}

data "aws_route53_zone" "zone" {
  name         = "mosaicsquare.io."
  private_zone = false
}

resource "aws_route53_record" "route53" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "argocd.mosaicsquare.io"
  type    = "CNAME"
  ttl     = "300"
  records = [
    data.kubernetes_ingress_v1.argocd_ingress.status.0.load_balancer.0.ingress.0.hostname,
  ]
}

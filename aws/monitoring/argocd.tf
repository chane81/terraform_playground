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

# Ingress 생성
resource "kubernetes_manifest" "argocd_ingress" {
  manifest = yamldecode(file("./argocd/ingress.yml"))

  wait {
    fields = {
      "status.loadBalancer.ingress[0].hostname" = "*"
    }
  }

  # depends_on = [
  #   helm_release.argocd
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

# ArgoCD Rollout 설치
# 참고: https://argoproj.github.io/argo-rollouts/
resource "helm_release" "argo-rollouts" {
  name = "argocd-rollouts"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-rollouts"
  version    = "2.14.0"
  namespace  = "argocd"

  set {
    name  = "dashboard.enabled"
    value = true
  }

  depends_on = [
    helm_release.argocd
  ]
}

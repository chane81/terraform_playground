# module "eks-ingress-nginx" {
#   source  = "lablabs/eks-ingress-nginx/aws"
#   version = "0.4.1"
# }

# module "nginx-controller" {
#   source  = "terraform-iaac/nginx-controller/helm"
#   version = "2.0.4"

#   additional_set = [
#     {
#       name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
#       value = "nlb"
#       type  = "string"
#     },
#     {
#       name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
#       value = "true"
#       type  = "string"
#     }
#   ]
# }


# kubernetes 에서 제공하는 nginx controller helm
# resource "helm_release" "nginx-ingress" {
#   name       = "ingress-nginx"
#   chart      = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   namespace  = "ingress-nginx"

#   dynamic "set" {
#     for_each = {
#       "controller.ingressClassResource.name"    = "ingress-nginx"
#       "controller.ingressClassResource.enabled" = "true"
#       "controller.ingressClassByName"           = "true"
#     }
#     content {
#       name  = set.key
#       value = set.value
#     }
#   }
# }

# nginx 에서 제공하는 nginx controller helm
resource "helm_release" "nginx-ingress" {
  name       = "ingress-nginx"
  chart      = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"
  namespace  = "kube-system"
}


# ingress 와 route 53 hostname 매핑
# data "kubernetes_ingress" "ingress" {
#   metadata {
#     name = "ingress-2048"
#   }
# }

data "aws_route53_zone" "zone" {
  name         = "mosaicsquare.link."
  private_zone = false
}

resource "aws_route53_record" "route53" {
  depends_on = [
    resource.kubernetes_ingress_v1.nginx-ingress
  ]

  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "*.mosaicsquare.link"
  type    = "CNAME"
  ttl     = "300"
  records = [resource.kubernetes_ingress_v1.nginx-ingress.status.0.load_balancer.0.ingress.0.hostname]
}

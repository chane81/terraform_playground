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
#       "controller.admissionWebhooks.enabled" = "false"
#     }
#     content {
#       name  = set.key
#       value = set.value
#     }
#   }
# }

# nginx 에서 제공하는 nginx controller helm
# resource "helm_release" "nginx-ingress" {
#   name       = "ingress-nginx"
#   chart      = "nginx-ingress"
#   repository = "https://helm.nginx.com/stable"
#   namespace  = "kube-system"

#   # dynamic "set" {
#   #   for_each = {
#   #     "controller.image.repository" = "myregistry.example.com/nginx-plus-ingress"
#   #     "controller.nginxplus"        = "false"
#   #     # "controller.admissionWebhooks.enabled" = "false"
#   #   }
#   #   content {
#   #     name  = set.key
#   #     value = set.value
#   #   }
#   # }
# }

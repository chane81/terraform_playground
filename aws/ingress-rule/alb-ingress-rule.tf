# # 로드밸런서 생성(인그레스 생성에 따른 생성)
# resource "kubernetes_manifest" "alb_ingress" {
#   manifest = yamldecode(file("./spec-file/${local.environment}.ingress-rule.yml"))

#   wait_for = {
#     complete = true

#     fields = {
#       "status.loadBalancer.ingress[0].hostname" = "*"
#     }
#   }

#   # timeouts {
#   #   create = "5s"
#   #   update = "5s"
#   #   delete = "5s"
#   # }

#   depends_on = [
#     module.eks
#   ]
# }

# data "kubernetes_ingress_v1" "alb_ingress" {
#   metadata {
#     name = "mosaic-square-ingress"
#     namespace = "dev"
#   }

#   depends_on = [
#     kubernetes_manifest.alb_ingress
#   ]
# }

# data "aws_route53_zone" "zone" {
#   name         = "mosaicsquare.io."
#   private_zone = false
# }

# # ROUTE 53 레코드 생성 및 해당 로드벨런에 매핑
# resource "aws_route53_record" "route53" {
#   zone_id = data.aws_route53_zone.zone.zone_id
#   name    = "*.mosaicsquare.io"
#   type    = "CNAME"
#   ttl     = "300"
#   # records = [resource.kubernetes_manifest.alb_ingress.status.0.load_balancer.0.ingress.0.hostname]
#   records = [data.kubernetes_ingress_v1.alb_ingress.status.0.load_balancer.0.ingress.0.hostname]
#   # records =  ["k8s-dev-mosaicsq-369b0ce8b3-765456684.ap-northeast-2.elb.amazonaws.com"]

  
# }

# output "ingress" {
#   value = data.kubernetes_ingress_v1.alb_ingress.status.0.load_balancer.0.ingress.0.hostname
# }
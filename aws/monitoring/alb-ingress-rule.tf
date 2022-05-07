# resource "kubernetes_ingress_v1" "alb-ingress" {
#   wait_for_load_balancer = true

#   metadata {
#     name = "kube-ingress"
#     annotations = {
#       "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
#       "alb.ingress.kubernetes.io/target-type" = "ip"
#     }
#   }
#   spec {
#     ingress_class_name = "alb"
#     rule {
#       # host = "2048.mosaicsquare.link"
#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = "service-2048"
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }

#     # rule {
#     #   host = "next.mosaicsquare.link"
#     #   http {
#     #     path {
#     #       path      = "/"
#     #       path_type = "Prefix"
#     #       backend {
#     #         service {
#     #           name = "service-nextjs"
#     #           port {
#     #             number = 80
#     #           }
#     #         }
#     #       }
#     #     }
#     #   }
#     # }
#   }
# }


# # data "aws_route53_zone" "zone" {
# #   name         = "mosaicsquare.link."
# #   private_zone = false
# # }

# # resource "aws_route53_record" "route53" {
# #   zone_id = data.aws_route53_zone.zone.zone_id
# #   name    = "*.mosaicsquare.link"
# #   type    = "CNAME"
# #   ttl     = "300"
# #   records = [kubernetes_ingress_v1.alb-ingress.status.0.load_balancer.0.ingress.0.hostname]

# #   depends_on = [
# #     kubernetes_ingress_v1.alb-ingress
# #   ]
# # }

# resource "helm_release" "prometheus" {
#   depends_on = [kubernetes_namespace.monitoring]

#   name = "prometheus"

#   repository = "prometheus-community"
#   chart      = "prometheus"
#   namespace  = "monitoring"

#   values = [file("config/prometheus/values_${local.environment}.yaml")]
# }

# resource "helm_release" "grafana" {
#   depends_on = [kubernetes_namespace.monitoring]

#   name = "grafana"

#   repository = "grafana"
#   chart      = "grafana"
#   namespace  = "monitoring"

#   values = [file("config/grafana/values_${local.environment}.yaml")]
# }

# resource "kubernetes_manifest" "gateway_grafana_gateway" {
#   depends_on = [helm_release.grafana]
#   manifest = {
#     "apiVersion" = "networking.istio.io/v1alpha3"
#     "kind"       = "Gateway"
#     "metadata" = {
#       "name"      = "grafana-gateway"
#       "namespace" = "monitoring"
#     }
#     "spec" = {
#       "selector" = {
#         "istio" = "ingress-internal"
#       }
#       "servers" = [
#         {
#           "hosts" = [
#             "grafana.${local.subdomain}.cha",
#           ]
#           "port" = {
#             "name"     = "http"
#             "number"   = 80
#             "protocol" = "HTTP"
#           }
#         },
#       ]
#     }
#   }
# }

# # resource "kubernetes_manifest" "virtualservice_grafana" {
# #   depends_on = [helm_release.grafana]
# #   manifest = {
# #     "apiVersion" = "networking.istio.io/v1alpha3"
# #     "kind" = "VirtualService"
# #     "metadata" = {
# #       "name" = "grafana"
# #       "namespace" = "monitoring"
# #     }
# #     "spec" = {
# #       "gateways" = [
# #         "grafana-gateway",
# #       ]
# #       "hosts" = [
# #         "grafana.${local.subdomain}.cha",
# #       ]
# #       "http" = [
# #         {
# #           "match" = [
# #             {
# #               "uri" = {
# #                 "prefix" = "/"
# #               }
# #             },
# #           ]
# #           "route" = [
# #             {
# #               "destination" = {
# #                 "host" = "grafana"
# #                 "port" = {
# #                   "number" = 80
# #                 }
# #               }
# #             },
# #           ]
# #         },
# #       ]
# #     }
# #   }
# # }

resource "kubernetes_ingress_v1" "alb_ingress" {
  metadata {
    name = "kube-ingress"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }
  spec {
    ingress_class_name = "alb"
    rule {
      host = "2048.mosaicsquare.link"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "service-2048"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "next.mosaicsquare.link"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "service-nextjs"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

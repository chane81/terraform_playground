resource "kubernetes_ingress_v1" "nginx-ingress" {
  metadata {
    name = "kube-ingress"
    annotations = {
      "nginx.org/proxy-connect-timeout" = "30s"
      "nginx.org/proxy-read-timeout"    = "20s"
      "nginx.org/client-max-body-size"  = "4m"
    }
  }
  spec {
    ingress_class_name = "nginx"
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

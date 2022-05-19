resource "kubernetes_namespace" "env_namespae" {
  metadata {
    name = local.environment
  }
}

# 서비스 인그레스 생성
resource "kubernetes_manifest" "service_ingress" {
  manifest = yamldecode(file("./spec-file/${local.environment}.service.ingress-rule.yml"))

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

  depends_on = [
    local.cluster_id,
    kubernetes_namespace.env_namespae
  ]
}

# 프로메테우스 인그레스 생성
resource "kubernetes_manifest" "prometheus_ingress" {
  manifest = yamldecode(file("./spec-file/${local.environment}.prometheus.ingress-rule.yml"))

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

  depends_on = [
    local.cluster_id,
    kubernetes_namespace.env_namespae
  ]
}

data "kubernetes_ingress_v1" "service_ingress" {
  metadata {
    name      = "service-ingress"
    namespace = "default"
  }

  depends_on = [
    kubernetes_manifest.service_ingress
  ]
}

data "kubernetes_ingress_v1" "prometheus_ingress" {
  metadata {
    name      = "prometheus-ingress"
    namespace = "prometheus"
  }

  depends_on = [
    kubernetes_manifest.prometheus_ingress
  ]
}

data "aws_route53_zone" "zone" {
  name         = "mosaicsquare.io."
  private_zone = false
}

# resource "aws_route53_zone" "zone" {
#   name = "${terraform.workspace}.mosaicsquare.io"

#   tags = {
#     Environment = "${terraform.workspace}"
#   }
# }

# route 53 레코드 생성 및 해당 로드벨런에 매핑
resource "aws_route53_record" "route53" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "*.mosaicsquare.io"
  type    = "CNAME"
  ttl     = "300"
  records = [
    data.kubernetes_ingress_v1.service_ingress.status.0.load_balancer.0.ingress.0.hostname,
    data.kubernetes_ingress_v1.prometheus_ingress.status.0.load_balancer.0.ingress.0.hostname
  ]
}

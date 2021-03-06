resource "kubernetes_namespace" "devtroncd_namespace" {
  metadata {
    name = "devtroncd"
  }
}

# data "http" "devtron_bom" {
#   url = "https://raw.githubusercontent.com/devtron-labs/devtron/main/manifests/devtron-bom.yaml"
# }


# devtron 설치
resource "helm_release" "devtron" {
  name       = "devtron"
  chart      = "devtron-operator"
  repository = "https://helm.devtron.ai"
  namespace  = "devtroncd"

  # values = [
  #   data.http.devtron_bom.body
  # ]

  dynamic "set" {
    for_each = {
      "installer.modules" = "{cicd}"
      "installer.release" = "v0.4.3"
    }
    content {
      name  = set.key
      value = set.value
    }
  }

  # 설치시 대략 30분정도 걸리므로 wait false 로 설정
  # install 상태확인 watch
  # kubectl -n devtroncd get installers installer-devtron -o jsonpath='{.status.sync.status}'
  # kubectl logs -f -l app=inception -n devtroncd
  wait = false

  depends_on = [
    kubernetes_namespace.devtroncd_namespace,
    module.eks
  ]
}

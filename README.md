# Terraform Playground

## terraform 명령 가이드

```bash
  # 테라폼 workspace 생성
  $ terraform workspace new dev

  # 현재 나의 workspace 확인
  $ terraform workspace list

  # 테라폼 init
  $ terraform init

  # aws 리소스 생성
  $ terraform apply

  # aws 리소스 제거
  $ terraform destroy

  # backend state 와의 migrate
  terraform init -migrate-state
```

## terraform backend state

- 테라폼 backend state 관리
- global > base

  ```bash
  terraform apply
  ```

## command

- eks

  ```bash
  aws eks update-kubeconfig --name <eks 명>

  aws sts get-caller-identity
  ```

- helm

  ```bash
  # helm 추가
  helm repo add eks https://aws.github.io/eks-charts
  helm repo update
  ```

- terraform

  ```bash
  # workspace
  terraform workspace list
  terraform workspace new dev
  terraform workspace select dev
  terraform workspace delete dev

  # base command
  terraform init
  terraform init -upgrade
  terraform validate
  terraform plan
  terraform apply
  terraform graph -draw-cycles

  # terraform 수행시 특정 이유로 lock이 걸린 상태에서 해제가 안된채로 끝나 있을 경우 사용
  terraform force-unlock [LOCK_ID]

  terraform state list
  terraform state rm <resource name>
  # 모든 state 삭제
  terraform state list | cut -f 1 -d '[' | xargs -L 0 terraform state rm
  ```

## issue

- 만약 eks 클러스터 리소스관련 수정이 있고, apply 명령 수행시 'kubernetes cluster unreachable' 에러 메시지가 나온다면 아래와 같이 provider.tf 를 수정해서 적용
  - 참고: https://lifesaver.codes/answer/kubernetes-cluster-unreachable-invalid-configuration-no-configuration-has-been-provided-try-setting-kubernetes-master-environment-variable-1234

```bash

provider "kubectl" {
  # host                   = data.aws_eks_cluster.cluster.endpoint
  # cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  # token                  = data.aws_eks_cluster_auth.cluster.token
  # load_config_file       = false

  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  # host                   = data.aws_eks_cluster.cluster.endpoint
  # cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  # token                  = data.aws_eks_cluster_auth.cluster.token

  config_path = "~/.kube/config"

  experiments {
    manifest_resource = true
  }
}

provider "helm" {
  # kubernetes {
  #   host                   = data.aws_eks_cluster.cluster.endpoint
  #   token                  = data.aws_eks_cluster_auth.cluster.token
  #   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  # }
  kubernetes {
    config_path = "~/.kube/config"
  }
}
```

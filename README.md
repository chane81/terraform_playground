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
  terraform force-unlock [LOCK_ID]
  ```

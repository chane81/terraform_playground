# Terraform Playground

## terraform backend state

- 테라폼 backend state 관리
- global > base

  ```bash
  terraform apply
  ```

## command

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

# Terraform prod, dev, staging eks 환경 구성

## 세팅

- 각 workspace 이름별로 환경이 생성됩니다. 아래 명령어로 생성할 환경에 대해 먼저 workspace를 세팅해주세요

```bash
# 각 환경별 workspace 생성
$ terraform workspace new dev
$ terraform workspace new prod
$ terraform workspace new staging

# dev 기준 환경세팅시
$ terraform workspace select dev
$ terraform init
$ terraform plan
$ terraform apply
```

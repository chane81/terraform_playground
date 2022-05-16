# Terraform 각 환경별 ingress 설정

## Terraform prod, dev, staging eks 환경 구성 (모니터링 제외)

- 각 workspace 별로 생성된 환경별 ingress 룰을 설정합니다.
- eks 생성시 저장된 tstate 를 remote 로 가져와 참고 합니다.

## 세팅

```bash
# 각 환경별 workspace 생성
$ terraform workspace new dev && new prod && new staging
$ terraform workspace new prod
$ terraform workspace new staging

# dev 기준 환경세팅시
$ terraform workspace select dev
$ terraform init
$ terraform plan
$ terraform apply
```

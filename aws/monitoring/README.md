# Terraform Devtron 구성

## 참고

- 테라폼 apply 이후 devtron 설치가 30분~40분 정도 소요가 됩니다. 아래 로그 watch 명령어로 설치 log 확인이 가능합니다.

  ```bash
  # install 상태확인 watch
  # kubectl -n devtroncd get installers installer-devtron -o jsonpath='{.status.sync.status}'
  # kubectl logs -f -l app=inception -n devtroncd
  ```

- devtron 설치이후

  ```bash
  # dashboard url 확인
  $ kubectl get svc -n devtroncd devtron-service -o jsonpath='{.status.loadBalancer.ingress}'

  # admin 계정의 비번 확인
  $ kubectl -n devtroncd get secret devtron-secret -o jsonpath='{.data.ACD_PASSWORD}' | base64 -d
  ```

## 설치 command

```bash
# workspace monitoring 생성
$ terraform workspace new monitoring
$ terraform workspace list

$ terraform plan
$ terraform apply
```

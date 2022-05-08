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

## devtron 웹 > k8s cluster server account 설정 및 token get

- devtron 설치가 끝났다면 웹 UI 에서 K8S Cluster 등록을 해야한다.
- 등록할 클러스터로 cmd 로그인 후 (aws update-kubeconfig --name [클러스터명])
- 아래 명령어를 수행하여 해당 클러스터에 devtron 용 service account 생성 및 토큰을 받고
- devtron web ui > Global configurations > Clusters & Environments > Add cluster 에서 Server URL(eks api url) 을 입력
- Bearer token 에 아래 명령어 수행 후 나온 토큰 값을 입력 후 Save
- 참고로 kubernetes_export_sa.sh 수행시 에러가 난다면. sh 구문에 "base64 --decode" -> "base64 -di"로 변경 및 저장 후 실행하면 된다.

```bash
bash ./devtron-cluster-sh/kubernetes_export_sa.sh cd-user devtroncd https://raw.githubusercontent.com/devtron-labs/utilities/main/kubeconfig-exporter/clusterrole.yaml

# service account 삭제 처리할 경우 아래 입력
kubectl delete serviceaccount -n devtroncd cd-user
```

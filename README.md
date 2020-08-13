# Pressure test for grpc with istio

### Requirement:
* helm : 安裝測試環境
* wrk (optional) : 壓測工具

### 安裝測試流程：

1. add helm repo
```
$ helm repo add bb https://duanwinds.github.io/helm-chart/
```

2. check sample chart
```
$ helm search repo sample-app // if use helm 3
$ helm search sample-app // if use helm 2
```

3. environment initial
```
$ kubectl create ns test
$ kubectl label ns test istio-injection=enabled
```

4. deploy to default namespace (no isito)

* 不限制 pod 部署在哪一個 worker node
```
$ ./deploy.sh
```
* 所有 pod 部署在名稱為 "ns1" 的 worker node
```
$ NODE=ns1 ./deploy.sh
```

5. deploy to test namespace (istio injection enabled)

* 不限制 pod 部署在哪一個 worker node
```
$ NS=test ./deploy.sh
```
* 所有 pod 部署在名稱為 "ns1" 的 worker node
```
$ NS=test NODE=ns1 ./deploy.sh
```

6. 使用 wrk 對 namespace 為 test 的部署環境進行壓測

* 假設對 node ip 192.168.1.100 進行壓測，預設以 16 thread 以及每個 thread 2500 request per second 進行壓測，每項測試持續 5 分鐘
```
$ NODE=192.168.1.100 ./pressure.sh
```
* 如果要調整為 thread 為 4 以及每個 thread 100 個 reqeust per second 進行壓測，並且每項測試持續時間 10 秒鐘
```
$ NODE=192.168.1.100 THREAD=4 CC=100 TIME=10 ./pressure.sh
```

7. 刪除部署在 namespace 為 test 上的 helm package
```
$ NS=test ./destroy.sh
```

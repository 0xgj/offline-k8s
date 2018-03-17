# kubernetes offline installation

## use *make release* to package kubernetes-v1.9.4 and contiv-1.1.1:

1. use kubeadm;
2. self contained, no extra package required;
3. linux os release independent;

```
gcr.io/google_containers/etcd-amd64:3.1.1
gcr.io/google_containers/kube-apiserver-amd64:v1.9.
gcr.io/google_containers/kube-controller-manager-amd64:v1.9.
gcr.io/google_containers/kube-scheduler-amd64:v1.9.4
gcr.io/google_containers/kube-proxy-amd64:v1.9.4
gcr.io/google_containers/pause-amd64:3.0
gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.7
gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.7
gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.7
docker.io/library/nginx:latest
docker.io/contiv/netplugin:1.1.1
docker.io/contiv/auth_proxy:1.1.1
quay.io/coreos/etcd:v2.3.8
```


RELEASE=v1.9.4
CNI_VERSION=v0.6.0
CONTIV_VERSION=1.1.1
IMAGES := \
gcr.io/google_containers/etcd-amd64:3.1.11\
gcr.io/google_containers/kube-apiserver-amd64:v1.9.4\
gcr.io/google_containers/kube-controller-manager-amd64:v1.9.4\
gcr.io/google_containers/kube-scheduler-amd64:v1.9.4\
gcr.io/google_containers/kube-proxy-amd64:v1.9.4\
gcr.io/google_containers/pause-amd64:3.0\
gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.7\
gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.7\
gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.7\
docker.io/library/nginx:1.12\
docker.io/contiv/netplugin:1.1.1\
docker.io/contiv/auth_proxy:1.1.1\
quay.io/coreos/etcd:v2.3.8\
quay.io/coreos/etcd:v3.1.10\
quay.io/calico/node:v3.0.3\
quay.io/calico/cni:v2.0.1\
quay.io/calico/kube-controllers:v2.0.1
TARGET_REPO = caogj/kubeadm-v1.9.4
TARGET_REPO_PUB = caogj/kubeadm-pub-v1.9.4
TARGET_TAG = v0.2
DOCKER_VERSION = 17.12.1

release:
	rm -rf docker cni bin services images images.tgz contiv* kubeadm.tar
	mkdir -p cni/bin images services bin
	curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-amd64-${CNI_VERSION}.tgz" | tar -C cni/bin -xz
	cd bin && curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/{kubeadm,kubelet,kubectl} && chmod +x *
	curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/kubelet.service" | sed "s:/usr/bin:/opt/bin:g" > services/kubelet.service
	curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/10-kubeadm.conf" | sed "s:/usr/bin:/opt/bin:g" > services/10-kubeadm.conf
	curl -sSL "https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml" > services/calico.yaml
	curl -L -O https://github.com/contiv/install/releases/download/${CONTIV_VERSION}/contiv-${CONTIV_VERSION}.tgz
	tar xf contiv-${CONTIV_VERSION}.tgz
	curl -sSL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}-ce.tgz | tar -zxvf -
	for image in ${IMAGES}; do docker pull $${image}; done
	for image in ${IMAGES}; do filename=$$(echo $${image} | cut -f 3 -d '/'); docker save $${image} > images/$${filename}.tar; done
	tar -czvf images.tgz images && rm -rf images
	for i in $$(docker images | awk '{print $$3}' | grep ${TARGET_REPO}| sort | uniq); do docker rmi $${i}; done
	docker build -t ${TARGET_REPO}:${TARGET_TAG} .
	rm -rf docker cni bin services images images.tgz contiv* kubeadm.tar

pub: install.sh
	docker build -t $${TARGET_REPO_PUB}:$${TARGET_TAG} -f Dockerfile.pub
	docker push $${TARGET_REPO_PUB}:$${TARGET_TAG} 

install.sh: release
	cat install.sh.in >install.sh
	echo "PAYLOAD:" >> install.sh
	docker save ${TARGET_REPO}:${TARGET_TAG} >>install.sh
	chmod +x install.sh

# Ubuntu EC2'de Kubernetes Cluster Kurulum Rehberi
## 1 Master + 1 Worker Node

## Ön Gereksinimler

### EC2 Instance Gereksinimleri

**Master Node:**
- Instance Type: t3.medium veya üzeri (minimum 2 vCPU, 4GB RAM)
- Storage: 20GB
- OS: Ubuntu 22.04 LTS veya 20.04 LTS

**Worker Node:**
- Instance Type: t3.small veya üzeri (minimum 1 vCPU, 2GB RAM)
- Storage: 20GB
- OS: Ubuntu 22.04 LTS veya 20.04 LTS

### Security Group Ayarları

**Master Node Security Group:**
| Port | Protocol | Source | Açıklama |
|------|----------|--------|----------|
| 22 | TCP | 0.0.0.0/0 | SSH |
| 6443 | TCP | Worker IP | Kubernetes API Server |
| 2379-2380 | TCP | Master IP | etcd server client API |
| 10250 | TCP | Master + Worker IP | Kubelet API |
| 10251 | TCP | Master IP | kube-scheduler |
| 10252 | TCP | Master IP | kube-controller-manager |

**Worker Node Security Group:**
| Port | Protocol | Source | Açıklama |
|------|----------|--------|----------|
| 22 | TCP | 0.0.0.0/0 | SSH |
| 10250 | TCP | Master IP | Kubelet API |
| 30000-32767 | TCP | 0.0.0.0/0 | NodePort Services |

**Not:** Production ortamında kaynak IP'leri daha kısıtlayıcı tutun.

---

## BÖLÜM 1: MASTER NODE KURULUMU

Master node olacak EC2 instance'ınıza SSH ile bağlanın:

```bash
ssh -i your-key.pem ubuntu@<MASTER-PUBLIC-IP>
```

### Adım 1.1: Sistemi Güncelleyin

```bash
sudo apt update && sudo apt upgrade -y
```

### Adım 1.2: Gerekli Paketleri Kurun

```bash
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

### Adım 1.3: Docker Kurulumu

```bash
# Docker kurulumu
sudo apt install -y docker.io

# Docker servisini başlat ve otomatik başlatmayı etkinleştir
sudo systemctl enable docker
sudo systemctl start docker

# Docker durumunu kontrol et
sudo systemctl status docker

# Kullanıcıyı docker grubuna ekle (opsiyonel)
sudo usermod -aG docker $USER
```

### Adım 1.4: Kubernetes Repository'sini Ekleyin

```bash
# Kubernetes GPG anahtarını ekle
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Kubernetes repository'sini ekle
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

### Adım 1.5: Kubernetes Bileşenlerini Kurun

```bash
# Repository'yi güncelle
sudo apt update

# Kubernetes bileşenlerini kur
sudo apt install -y kubelet kubeadm kubectl

# Paketleri güncellemeye karşı sabitle
sudo apt-mark hold kubelet kubeadm kubectl

# Versiyon kontrolü
kubeadm version
kubelet --version
kubectl version --client
```

### Adım 1.6: Swap'ı Devre Dışı Bırakın

Kubernetes swap ile çalışmaz, devre dışı bırakılmalıdır:

```bash
# Geçici olarak swap'ı kapat
sudo swapoff -a

# Kalıcı olarak devre dışı bırak
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Kontrol et (çıktı boş olmalı)
sudo swapon --show
```

### Adım 1.7: Kernel Modüllerini Yükleyin

```bash
# Gerekli modülleri yükle
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Sysctl parametrelerini ayarla
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Parametreleri uygula
sudo sysctl --system

# Kontrol et
lsmod | grep br_netfilter
lsmod | grep overlay
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
```

### Adım 1.8: Kubernetes Master'ı Başlatın

```bash
# Master node'u başlat
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

**Önemli:** Bu komut 3-5 dakika sürebilir. Komut başarılı olunca şuna benzer bir çıktı alacaksınız:

```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.31.X.X:6443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**ÇOK ÖNEMLİ:** `kubeadm join` komutunu bir yere kaydedin! Worker node'u eklerken kullanacaksınız.

### Adım 1.9: kubectl Yapılandırması

```bash
# .kube dizinini oluştur
mkdir -p $HOME/.kube

# Config dosyasını kopyala
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

# Dosya sahipliğini düzenle
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Adım 1.10: Pod Network (Flannel) Kurun

Kubernetes'te pod'ların birbiriyle iletişim kurabilmesi için bir network plugin gereklidir:

```bash
# Flannel network plugin'ini kur
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

### Adım 1.11: Master Node Durumunu Kontrol Edin

```bash
# Node durumunu kontrol et
kubectl get nodes

# Çıktı (STATUS "Ready" olmalı):
# NAME               STATUS   ROLES           AGE   VERSION
# ip-172-31-x-x      Ready    control-plane   5m    v1.28.x

# Tüm pod'ları kontrol et
kubectl get pods -A

# Tüm pod'lar Running durumunda olmalı
```

### Adım 1.12: (Opsiyonel) Master Node'da Pod Çalıştırmaya İzin Verin

Varsayılan olarak master node'da uygulama pod'ları çalışmaz. Test ortamında izin vermek isterseniz:

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

---

## BÖLÜM 2: WORKER NODE KURULUMU

Worker node olacak EC2 instance'ınıza SSH ile bağlanın:

```bash
ssh -i your-key.pem ubuntu@<WORKER-PUBLIC-IP>
```

### Adım 2.1-2.7: Master Node ile Aynı Adımları Uygulayın

Worker node'da da **Adım 1.1 ile 1.7 arasındaki tüm adımları** uygulayın:

1. Sistem güncellemesi
2. Gerekli paketler
3. Docker kurulumu
4. Kubernetes repository ekleme
5. Kubernetes bileşenlerini kurma
6. Swap'ı kapatma
7. Kernel modüllerini yükleme

**Not:** `kubeadm init` komutunu ÇALIŞTIRMAYIN! Sadece 1.1-1.7 arası adımlar.

### Adım 2.8: Worker Node'u Cluster'a Ekleyin

Master node'dan aldığınız `kubeadm join` komutunu çalıştırın:

```bash
sudo kubeadm join <MASTER-IP>:6443 --token <TOKEN> \
        --discovery-token-ca-cert-hash sha256:<HASH>
```

Örnek:
```bash
sudo kubeadm join 172.31.45.123:6443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef
```

Başarılı olursa şu çıktıyı alacaksınız:
```
This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```

### Adım 2.9: Master Node'dan Worker'ı Kontrol Edin

**Master node**'a geri dönün ve worker node'un eklendiğini kontrol edin:

```bash
kubectl get nodes
```

Çıktı:
```
NAME               STATUS   ROLES           AGE   VERSION
ip-172-31-x-x      Ready    control-plane   15m   v1.28.x
ip-172-31-y-y      Ready    <none>          2m    v1.28.x
```

Worker node'un STATUS'ü birkaç dakika içinde **"Ready"** olacaktır.

```bash
# Detaylı bilgi için
kubectl get nodes -o wide

# Tüm sistem pod'larını kontrol et
kubectl get pods -A
```

---

## BÖLÜM 3: CLUSTER'I TEST ETME

### Test 1: Nginx Deployment Oluşturma

Master node'da:

```bash
# Nginx deployment oluştur
kubectl create deployment nginx --image=nginx

# Deployment'ı kontrol et
kubectl get deployments

# Pod'u kontrol et
kubectl get pods

# Pod'un hangi node'da çalıştığını gör
kubectl get pods -o wide
```

### Test 2: Deployment'ı Scale Etme

```bash
# 3 replika oluştur
kubectl scale deployment nginx --replicas=3

# Pod'ların dağılımını kontrol et
kubectl get pods -o wide
```

### Test 3: Service Oluşturma

```bash
# NodePort service oluştur
kubectl expose deployment nginx --type=NodePort --port=80

# Service'i kontrol et
kubectl get services

# Service detaylarını gör
kubectl describe service nginx
```

Service'in NodePort değerini not edin (örn: 30080). Tarayıcınızda şu adresi açın:
```
http://<WORKER-NODE-PUBLIC-IP>:<NODE-PORT>
```

Nginx karşılama sayfasını görmelisiniz!

### Test 4: Temizlik

```bash
# Test kaynaklarını sil
kubectl delete service nginx
kubectl delete deployment nginx

# Kontrol et
kubectl get all
```

---

## BÖLÜM 4: YARDIMCI KOMUTLAR

### Cluster Bilgileri

```bash
# Cluster bilgisi
kubectl cluster-info

# Cluster durumu
kubectl get componentstatuses

# Node'ların detaylı bilgisi
kubectl describe nodes

# Tüm namespace'lerdeki kaynaklar
kubectl get all --all-namespaces
```

### Log ve Debug

```bash
# Pod loglarını görüntüle
kubectl logs <pod-name>

# Pod'a bağlan
kubectl exec -it <pod-name> -- /bin/bash

# Pod olaylarını gör
kubectl describe pod <pod-name>

# Node olaylarını gör
kubectl describe node <node-name>
```

### Token ve Join Komutu

Eğer worker node join komutunu kaybettiyseniz veya yeni bir worker eklemek istiyorsanız:

**Master node'da:**

```bash
# Yeni token oluştur ve join komutunu görüntüle
kubeadm token create --print-join-command
```

Bu komut size kullanıma hazır bir `kubeadm join` komutu verecektir.

### Mevcut Token'ları Listele

```bash
# Token'ları listele
kubeadm token list

# Token süresi 24 saattir, süresi dolanlar silinir
```

---

## BÖLÜM 5: SORUN GİDERME

### Worker Node "NotReady" Durumunda

```bash
# Master node'da worker durumunu kontrol et
kubectl describe node <worker-node-name>

# Worker node'da kubelet loglarını kontrol et
sudo journalctl -u kubelet -f

# Kubelet'i yeniden başlat
sudo systemctl restart kubelet
```

### Pod'lar "Pending" Durumunda

```bash
# Pod detaylarını incele
kubectl describe pod <pod-name>

# Node kaynaklarını kontrol et
kubectl top nodes  # (metrics-server gerektirir)
kubectl describe nodes
```

### Network Sorunları

```bash
# Flannel pod'larını kontrol et
kubectl get pods -n kube-flannel

# Flannel loglarını incele
kubectl logs -n kube-flannel <flannel-pod-name>

# Flannel'i yeniden başlat
kubectl delete pods -n kube-flannel --all
```

### Cluster'ı Tamamen Sıfırlama

**Her iki node'da da:**

```bash
# Cluster'dan ayrıl
sudo kubeadm reset

# iptables kurallarını temizle
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X

# CNI yapılandırmasını temizle
sudo rm -rf /etc/cni/net.d

# Kubelet'i yeniden başlat
sudo systemctl restart kubelet
```

Sonra master node kurulumunu baştan yapın.

---

## BÖLÜM 6: EK ARAÇLAR ve İYİLEŞTİRMELER

### Kubectl Autocomplete (Master Node)

```bash
# Bash autocomplete kur
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc

# Değişiklikleri uygula
source ~/.bashrc
```

### Kubernetes Dashboard Kurulumu (Opsiyonel)

```bash
# Dashboard'u kur
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

# Dashboard service account oluştur
kubectl create serviceaccount dashboard-admin-sa
kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa

# Token al
kubectl create token dashboard-admin-sa

# Dashboard'a proxy ile eriş
kubectl proxy
```

Tarayıcıda: `http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`

### Metrics Server Kurulumu (Kaynak Kullanımını İzleme)

```bash
# Metrics server'ı kur
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Metrics server'ı test et
kubectl top nodes
kubectl top pods
```

---

## BÖLÜM 7: ÖNEMLİ NOTLAR

### Güvenlik

1. **Production ortamında:**
   - Security Group kurallarını minimum gerekli portlarla sınırlayın
   - Private subnet kullanın
   - Bastion host üzerinden erişim sağlayın
   - RBAC (Role-Based Access Control) kullanın

2. **Token güvenliği:**
   - Join token'ları 24 saat sonra otomatik olarak sona erer
   - Token'ları güvenli bir yerde saklayın
   - Kullanılmayan token'ları silin

### Backup

Master node'daki önemli dosyalar:
```bash
# etcd backup
sudo ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-snapshot.db \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# Kubernetes config
sudo cp -r /etc/kubernetes /backup/kubernetes-backup
```

### Güncelleme

Kubernetes versiyonunu güncellerken:
1. Önce master node'u güncelleyin
2. Sonra worker node'ları tek tek güncelleyin
3. Her adımda testler yapın

---

## Kontrol Listesi

Kurulumunuzun başarılı olup olmadığını kontrol etmek için:

**Master Node:**
- [ ] `kubectl get nodes` komutu her iki node'u da "Ready" gösteriyor
- [ ] `kubectl get pods -A` komutu tüm sistem pod'larını "Running" gösteriyor
- [ ] Docker servisi çalışıyor: `sudo systemctl status docker`
- [ ] Kubelet servisi çalışıyor: `sudo systemctl status kubelet`

**Worker Node:**
- [ ] Docker servisi çalışıyor
- [ ] Kubelet servisi çalışıyor
- [ ] Master node ile iletişim kurabiliyor

**Network:**
- [ ] Flannel pod'ları çalışıyor: `kubectl get pods -n kube-flannel`
- [ ] Pod'lar arası iletişim çalışıyor
- [ ] NodePort servislere dışarıdan erişim var

**Test:**
- [ ] Nginx deployment başarıyla oluşturuldu
- [ ] Pod'lar worker node'da çalışıyor
- [ ] Service üzerinden erişim sağlanabiliyor

Tüm maddeler işaretliyse Kubernetes cluster'ınız çalışır durumda! 🎉

---

## Ek Kaynaklar

- **Kubernetes Resmi Dokümantasyon:** https://kubernetes.io/docs/
- **kubeadm Kurulum:** https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/
- **kubectl Komutları:** https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- **Flannel Dokümantasyon:** https://github.com/flannel-io/flannel

---

**Son Güncelleme:** Kasım 2025  
**Hedef Platform:** AWS EC2 - Ubuntu 22.04 LTS  
**Kubernetes Version:** v1.28.x  
**Hazırlayan:** Kubernetes Cluster Kurulum Rehberi
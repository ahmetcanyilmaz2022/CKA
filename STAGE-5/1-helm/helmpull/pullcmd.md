1️⃣ Grafana repo’sunu ekle
helm repo add grafana https://grafana.github.io/helm-charts
cd grafana 


2️⃣ Repo listesini kontrol et
helm repo list

3️⃣ Repo’yu güncelle (her zaman iyi bir alışkanlık)
helm repo update

4️⃣ Artık chart’ı indirebilirsin
helm pull grafana/grafana --untar

🔹 --untar dersen klasör olarak açar
🔹 Demezsen .tgz dosyası indirir (örnek: grafana-7.3.0.tgz)

5️⃣ Artık klasör yapısını görebilirsin

grafana/
 ├── Chart.yaml
 ├── values.yaml
 ├── templates/
 ├── charts/
 └── README.md


# Test
helm repo list




# ÇALIŞTIR 
helm install mygrafana ./grafana


3. Login with the password from step 1 and the username: admin
#################################################################################
######   WARNING: Persistence is disabled!!! You will lose your data when   #####
######            the Grafana pod is terminated.                            #####
#################################################################################

kubectl get all =)

ARA YÜZ ÜZERİNDEN ULAŞMAK İÇİN TERMİNALE :)

# values yaml üzerinden servis tipini NodePort yap ve :
> helm upgrade mygrafana ./grafana
helm history mygrafana 
kubectl get svc


veya hiç bunu yapma :)

🧩 1️⃣ Servis tipini NodePort’a çevir :)
kubectl patch svc mygrafana -n default -p '{"spec": {"type": "NodePort"}}'

test:kubectl get svc

# NOT: grafana şifreni öğren :),

kubectl get secret --namespace default mygrafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo



# ===============================
# Helm & Kubernetes Temizlik Rehberi
# ===============================

# 1️⃣ Tüm Helm release'lerini listele
helm list -A

# 2️⃣ Tek bir release'i sil (örnek: mygrafana)
helm uninstall mygrafana -n default

# 3️⃣ Tüm release'leri tek tek silmek (default namespace)
helm list -n default -q | xargs -n1 -I{} helm uninstall {} -n default

# 4️⃣ Tüm release'leri tüm namespace'lerde silmek
for ns in $(kubectl get ns -o jsonpath="{.items[*].metadata.name}"); do
  helm list -n $ns -q | xargs -n1 -I{} helm uninstall {} -n $ns
done

# 5️⃣ Helm repository'lerini listele
helm repo list

# 6️⃣ Kullanılmayan veya artık istemediğin repo'ları kaldır
helm repo remove grafana
helm repo remove bitnami

# 7️⃣ Repo listesini tekrar kontrol et
helm repo list

# 8️⃣ Tüm Kubernetes objelerini kontrol et (opsiyonel)
kubectl get all -A

# 9️⃣ Grafana secret ve diğer secret'ları kontrol et
kubectl get secrets -A | grep grafana

# 10️⃣ Gerekirse tüm namespace'lerdeki pod, svc, deploy, cm, secret vs temizle
for ns in $(kubectl get ns -o jsonpath="{.items[*].metadata.name}"); do
  kubectl delete all --all -n $ns
  kubectl delete configmap --all -n $ns
  kubectl delete secret --all -n $ns
done

# 11️⃣ Kontrol et, her şey temizlenmiş mi
helm list -A
kubectl get all -A
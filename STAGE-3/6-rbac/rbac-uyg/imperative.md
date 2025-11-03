1️⃣ Namespace oluşturma
kubectl create namespace app-team1
---------------------------------------------------------------------------------------------------


2️⃣ ServiceAccount oluşturma
kubectl create serviceaccount cicd-token -n app-team1

---------------------------------------------------------------------------------------------------


3️⃣ ClusterRole oluşturma
	•	kubectl create clusterrole ile direkt izin veriyoruz:


kubectl create clusterrole deployment-clusterrole \
  --verb=create \
  --resource=deployments,statefulsets,daemonsets

# Kubectl ClusterRole Komutu Açıklaması

# 1️⃣ kubectl create clusterrole deployment-clusterrole
# - Kubernetes’te bir ClusterRole oluşturur.
# - deployment-clusterrole → ClusterRole’un adı.

# 2️⃣ --verb=create
# - Rolün hangi eylemleri yapabileceğini belirler.
# - Burada sadece create izni verilmiş.
#   Yani kullanıcı veya ServiceAccount yalnızca Deployment, StatefulSet veya DaemonSet oluşturabilir.
# - İstersen get, list, update, delete gibi başka eylemleri de ekleyebilirsin.

# 3️⃣ --resource=deployments,statefulsets,daemonsets
# - Rolün hangi kaynaklarda geçerli olduğunu belirler.
# - Yalnızca deployments, statefulsets ve daemonsets üzerinde izin verir.

# Not
# - ClusterRole cluster çapında geçerlidir; bu yüzden namespace belirtmeye gerek yoktur.
# - Eğer sadece belirli bir namespace için yetki vermek istiyorsan Role kullanmalı ve RoleBinding ile bağlamalısın.


---------------------------------------------------------------------------------------------------


4️⃣ ClusterRoleBinding ile ServiceAccount’a bağlama

kubectl create clusterrolebinding cicd-token-binding \
  --clusterrole=deployment-clusterrole \
  --serviceaccount=app-team1:cicd-token

# Kubectl ClusterRoleBinding Komutu Açıklaması

# 1️⃣ kubectl create clusterrolebinding cicd-token-binding
# - Kubernetes’te bir ClusterRoleBinding oluşturur.
# - cicd-token-binding → ClusterRoleBinding’in adı.

# 2️⃣ --clusterrole=deployment-clusterrole
# - Hangi ClusterRole’ün bağlanacağını belirtir.
# - Yani cicd-token Binding, deployment-clusterrole üzerindeki izinleri alacak.

# 3️⃣ --serviceaccount=app-team1:cicd-token
# - Hangi ServiceAccount’a rolün uygulanacağını belirtir.
# - Burada app-team1 namespace’inde cicd-token ServiceAccount’una bağlanıyor.

# Not
# - ClusterRoleBinding cluster çapında geçerlidir ve ServiceAccount’un bu rolün izinlerini almasını sağlar.

---------------------------------------------------------------------------------------------------

5️⃣ Token oluşturma (Kubernetes 1.24+)
kubectl create token cicd-token -n app-team1


---------------------------------------------------------------------------------------------------


6️⃣ Deployment oluşturma (imperative)
kubectl run cicd-test \
  --image=bitnami/kubectl \
  --replicas=1 \
  --namespace=app-team1 \
  --serviceaccount=cicd-token \
  -- sleep 3600
---------------------------------------------------------------------------------------------------

7️⃣ Test
kubectl describe sa cicd-token -n app-team1
kubectl auth can-i create deployments --as=system:serviceaccount:app-team1:cicd-token

	•	✅ yes → her şey doğru
	•	❌ no → ClusterRoleBinding veya isim hatası var


# Kubernetes Role vs ClusterRole Karşılaştırması

## Özet
- **ClusterRole** → global yetki (tüm cluster ve namespace’lerde geçerli)  
- **Role** → namespace sınırında yetki (sadece belirli namespace içinde geçerli)  

## Karşılaştırma Tablosu

# Kubernetes Role vs ClusterRole Karşılaştırması

## Kapsam
- **ClusterRole:** Cluster çapında (tüm namespace’ler)  
- **Role:** Sadece bir namespace içinde  

## Kullanım
- **ClusterRole:** ClusterRoleBinding ile ServiceAccount’a bağlanır  
- **Role:** RoleBinding ile ServiceAccount’a bağlanır  

## Örnek
- **ClusterRole:** Deployment, StatefulSet, DaemonSet gibi kaynakları tüm cluster’da yönetmek  
- **Role:** Sadece `app-team1` namespace’inde podları yönetmek  

## Namespace Parametresi
- **ClusterRole:** Gerek yok  
- **Role:** Zorunlu (hangi namespace için izin verildiği belirtilmeli)  



# ÖZET
	ClusterRole → global yetki
	•	Role → namespace sınırında yetki
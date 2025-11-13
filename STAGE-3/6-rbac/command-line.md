KUBERNETES RBAC SENARYO VE TESTLER
RBAC (Role-Based Access Control), Kubernetes’te kimin hangi kaynaklara hangi yetkilerle erişebileceğini kontrol etmek için kullanılır.
	•	Kimler: Kullanıcılar veya servis account’lar
	•	Hangi kaynaklar: Pod, Service, Secret, ConfigMap vb.
	•	Hangi yetkiler: Okuma (get/list), yazma (create/update/delete), izleme (watch)

Özetle: RBAC, cluster güvenliğini sağlamak ve erişimi sınırlandırmak için kullanılan izin mekanizmasıdır.

Örnek:
	•	Geliştirici sadece kendi namespace’inde pod’ları görebilir ve değiştirebilir,
	•	Operasyon ekibi tüm cluster’daki pod’ları izleyebilir ve yönetebilir.

==========================================
1️⃣ ROLE & ROLEBINDING (Namespace bazlı)
==========================================

# Namespace oluştur
kubectl create namespace acme

# ServiceAccount oluştur
kubectl create serviceaccount myapp -n acme

# Role oluştur (pod okuma izni)
kubectl create role pod-reader \
  --verb=get --verb=list --verb=watch \
  --resource=pods \
  -n acme

# RoleBinding oluştur
kubectl create rolebinding myapp-pod-reader-binding \
  --role=pod-reader \
  --serviceaccount=acme:myapp \
  -n acme

# Kısa yetki testi (yes/no)
kubectl auth can-i list pods --as=system:serviceaccount:acme:myapp -n acme
kubectl auth can-i list services --as=system:serviceaccount:acme:myapp -n acme

==========================================
2️⃣ CLUSTERROLE & CLUSTERROLEBINDING (Küme genelinde)
==========================================

# Namespace oluştur
kubectl create namespace devops

# ServiceAccount oluştur
kubectl create serviceaccount myapp -n devops

# ClusterRole oluştur (tüm cluster pod okuma izni)
kubectl create clusterrole pod-reader \
  --verb=get,list,watch \
  --resource=pods

# ClusterRoleBinding oluştur
kubectl create clusterrolebinding myapp-view-binding \
  --clusterrole=pod-reader \
  --serviceaccount=devops:myapp

# Kısa yetki testleri (yes/no)
kubectl auth can-i list pods --as=system:serviceaccount:devops:myapp -n devops
kubectl auth can-i list pods --as=system:serviceaccount:devops:myapp -n default
kubectl auth can-i list pods --as=system:serviceaccount:devops:myapp -n kube-system
kubectl auth can-i list secrets --as=system:serviceaccount:devops:myapp -A
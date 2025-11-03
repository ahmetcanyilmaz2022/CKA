
# Kubernetes RBAC & Deployment Rehberi - Tek Blok

# UYUM ZİNCİRİ
# Namespace → ServiceAccount → ClusterRole → ClusterRoleBinding → Deployment

# UYGULAMA SIRASI
kubectl apply -f ns.yaml
kubectl apply -f sa.yaml
kubectl apply -f cluster-role-b.yaml
kubectl apply -f role-bind.yaml
kubectl apply -f deployment.yaml

# ÖNEMLİ NOT
# Kubernetes 1.24 sonrası, ServiceAccount için otomatik Secret/token artık kullanılmıyor.
kubectl create token cicd-token -n app-team1

# TEST
kubectl describe sa cicd-token -n app-team1
kubectl auth can-i create deployments --as=system:serviceaccount:app-team1:cicd-token

# ✅ Eğer çıktı yes → her şey doğru.
# ❌ Eğer çıktı no → bir bağlama (binding) veya isim hatası var.

# CLUSTERROLE AÇIKLAMASI
# Bu YAML bir “ClusterRole” tanımıdır.
# Kubernetes’te izinlerin (yetkilerin) nasıl olacağını belirleyen bir rol şablonu.
# Ama bu rol kendi başına hiçbir kullanıcıya verilmiş değildir.
# Yani sadece “bu yetkileri taşıyan bir rol tanımı” yapıyoruz.


# ÖRNEK SENARYO
# Diyelim ki bir CI/CD sistemi (GitLab Runner, Jenkins, GitHub Actions vs.) var.
# Bu sistem Kubernetes’e bağlanıp Deployment oluşturmak istiyor.
# Ama sistemin doğrudan root erişimi olmamalı.
# İşte o yüzden:
# 1. Ona özel bir ServiceAccount (cicd-token) oluşturuyoruz
# 2. Sadece Deployment oluşturma izni (ClusterRole) veriyoruz
# 3. ClusterRoleBinding ile ServiceAccount’u rol ile eşleştiriyoruz
# Böylece güvenli şekilde sadece bu işi yapabilir.



# ÖZET
# 1️⃣ Namespace → Kaynakların çalışacağı alan
# 2️⃣ ServiceAccount → Pod veya CI/CD için kimlik
# 3️⃣ ClusterRole → Yetki tanımı (Deployment, StatefulSet, DaemonSet oluşturabilir)
# 4️⃣ ClusterRoleBinding → Yetkiyi ServiceAccount’a bağlar
# 5️⃣ Deployment → Bu kimlik ile çalışan uygulama

# MODERN TOKEN KULLANIMI (Kubernetes 1.24+)
# Token artık otomatik yaratılmaz
kubectl create token cicd-token -n app-team1

# Test için:
kubectl auth can-i create deployments --as=system:serviceaccount:app-team1:cicd-token

# ✅ yes → her şey doğru
# ❌ no → ClusterRoleBinding veya isim hatası var
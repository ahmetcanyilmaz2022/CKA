#!/bin/bash
# ===============================================
# Kubernetes Deployment Komut Eğitim Dosyası
# ===============================================

# 1️⃣ Deployment oluşturma (imperative)
# kubectl create deployment opslab --image=nginx --replicas=3
# Açıklama: 'opslab' isimli deployment oluşturur, 3 pod çalıştırır, her pod nginx container içerir.

# 2️⃣ Deployment düzenleme (edit)
# kubectl edit deployment opslab
# Açıklama: Deployment'i interaktif olarak düzenler. Pod şablonunda değişiklik yapılabilir.

# 3️⃣ Deployment ölçeklendirme (scale)
# kubectl scale deployment opslab --replicas=5
# Açıklama: Pod sayısını 3’ten 5’e çıkarır. ReplicaSet yeni pod’lar oluşturur.

# 4️⃣ Deployment güncelleme (set image)
# kubectl set image deployment opslab nginx=nginx:latest
# Açıklama: Deployment içindeki 'nginx' container’ının imajını günceller.

# 5️⃣ Deployment detaylarını gösterme (describe)
# kubectl describe deployment opslab
# Açıklama: Deployment hakkında ayrıntılı bilgi verir (replicas, pod durumu, events)

# 6️⃣ Deployment listesini gösterme (get)
# kubectl get deployments
# Açıklama: Cluster’daki tüm Deployment’ları listeler.

# 7️⃣ Deployment durumu kontrol etme (rollout status)
# kubectl rollout status deployment opslab
# Açıklama: Deployment’in rollout (güncelleme) durumunu gösterir.

# 8️⃣ Deployment geri alma (rollback)
# kubectl rollout undo deployment opslab
# Açıklama: Deployment’i bir önceki sürüme geri alır.

# 9️⃣ Deployment silme (delete)
# kubectl delete deployment opslab
# Açıklama: Deployment’i ve bağlı pod’ları siler.

# 10️⃣ Deployment geçmişi görüntüleme (rollout history)
# kubectl rollout history deployment opslab
# Açıklama: Deployment’in geçmiş rollout versiyonlarını listeler.

# 11️⃣ Deployment manifestini dosyaya yazdırma (dry-run)
# kubectl create deployment opslab --image=nginx --dry-run=client -o yaml > opslab.yaml
# Açıklama: Deployment’i oluşturur gibi yapar ve YAML manifestini dosyaya kaydeder.

# 12️⃣ Pod’ları listeleme (Deployment pod’ları)
# kubectl get pods -l app=opslab
# Açıklama: Deployment tarafından yönetilen pod’ları label selector ile listeler.

# 13️⃣ Pod loglarını alma
# kubectl logs <pod-name>
# Açıklama: Pod içindeki container loglarını gösterir.

# 14️⃣ Pod’a bağlanma
# kubectl exec -it <pod-name> -- /bin/bash
# Açıklama: Pod içinde interaktif terminal açar.
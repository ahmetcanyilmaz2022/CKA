#!/bin/bash
# ========================================
# Kubernetes Deployment Revision Demo
# Hazırlayan: Ahmet Can Yılmaz 
# ========================================

# Deployment adı
DEPLOYMENT_NAME="mydeploy"

kubectl get deploy

kubectl create deployment mydeploy --image=nginx:1.25

echo "🔹 İlk rollout revision'ı oluşturuldu."
kubectl rollout history deploy mydeploy


"=============================="
"🧩 REVISION 2 - Yeni image versiyonu"
"=============================="
kubectl set image deploy mydeploy nginx=nginx:1.26 --record

 "🔹 Rollout durumu izleniyor..."
kubectl rollout status deploy mydeploy

 "🔹 Şu anki rollout geçmişi:"
kubectl rollout history deploy mydeploy


"=============================="
"🧩 REVISION 3 - Yeni image versiyonu"
kubectl set image deploy mydeploy nginx=nginx:1.27 --record
kubectl rollout status deploy mydeploy

"🔹 Güncel rollout geçmişi:"
kubectl rollout history deploy mydeploy

"=============================="
"♻️  REVISION 2'ye geri dönülüyor"
"=============================="
kubectl rollout undo deploy mydeploy --to-revision=2
kubectl rollout status deploy mydeploy

"🔹 Güncel rollout geçmişi (rollback sonrası):"
kubectl rollout history deploy mydeploy


"=============================="
"📊 Deployment detayı"
"=============================="
kubectl get deploy mydeploy -o wide
kubectl get pods 


kubectl rollout history deploy mydeploy

"=============================="
"🔄  ROLLOUT RESTART İŞLEMİ"
"=============================="
kubectl rollout restart deploy mydeploy
kubectl rollout status deploy mydeploy

"🔹 Restart sonrası yeni revision durumu:"

kubectl rollout history deploy $DEPLOYMENT_NAME

# kubectl rollout restart deployment opslab ?????
rollout restart, bir Deployment’ın Pod’larını yeniden başlatmak için kullanılır.
Ama dikkat: bu, Pod’ları silip yeniden oluşturur, yani image değişmeden yeni bir
 rollout başlatır.
 	•	Yeni environment variable’lar yüklendiğinde
	•	ConfigMap veya Secret güncellendiğinde
	•	Ama image değişmediğinde
➡️ Bu durumda yeni rollout başlatmaz; işte burada rollout restart kullanırız.

#!/bin/bash
# ========================================
# Kubernetes Deployment Revision Demo
# Hazırlayan: Ahmet Can Yılmaz 
# ========================================

# Deployment adı
DEPLOYMENT_NAME="opslab"

echo "🔹 Mevcut deployment'ları kontrol ediliyor..."
kubectl get deploy

echo "🔹 Eğer $DEPLOYMENT_NAME deployment'ı yoksa örnek bir tane oluşturuluyor..."
kubectl create deployment $DEPLOYMENT_NAME --image=nginx:1.25

echo "🔹 Pod'ların durumunu kontrol et..."
kubectl get pods -l app=$DEPLOYMENT_NAME

echo "🔹 İlk rollout revision'ı oluşturuldu."
kubectl rollout history deploy $DEPLOYMENT_NAME

echo
echo "=============================="
echo "🧩 REVISION 2 - Yeni image versiyonu"
echo "=============================="
kubectl set image deploy $DEPLOYMENT_NAME nginx=nginx:1.26 --record

echo "🔹 Rollout durumu izleniyor..."
kubectl rollout status deploy $DEPLOYMENT_NAME

echo "🔹 Şu anki rollout geçmişi:"
kubectl rollout history deploy $DEPLOYMENT_NAME

echo
echo "=============================="
echo "🧩 REVISION 3 - Yeni image versiyonu"
echo "=============================="
kubectl set image deploy $DEPLOYMENT_NAME nginx=nginx:1.27 --record
kubectl rollout status deploy $DEPLOYMENT_NAME

echo "🔹 Güncel rollout geçmişi:"
kubectl rollout history deploy $DEPLOYMENT_NAME

echo
echo "=============================="
echo "♻️  REVISION 2'ye geri dönülüyor"
echo "=============================="
kubectl rollout undo deploy $DEPLOYMENT_NAME --to-revision=2
kubectl rollout status deploy $DEPLOYMENT_NAME

echo "🔹 Güncel rollout geçmişi (rollback sonrası):"
kubectl rollout history deploy $DEPLOYMENT_NAME

echo
echo "=============================="
echo "📊 Deployment detayı"
echo "=============================="
kubectl get deploy $DEPLOYMENT_NAME -o wide
kubectl get pods -l app=$DEPLOYMENT_NAME

echo
echo "✅ Demo tamamlandı! Şimdi rollout geçmişini tekrar inceleyebilirsin:"
echo "kubectl rollout history deploy $DEPLOYMENT_NAME"

echo
echo "=============================="
echo "🔄  ROLLOUT RESTART İŞLEMİ"
echo "=============================="
kubectl rollout restart deploy $DEPLOYMENT_NAME
kubectl rollout status deploy $DEPLOYMENT_NAME

echo "🔹 Restart sonrası yeni revision durumu:"





kubectl rollout history deploy $DEPLOYMENT_NAME

# kubectl rollout restart deployment opslab ?????
rollout restart, bir Deployment’ın Pod’larını yeniden başlatmak için kullanılır.
Ama dikkat: bu, Pod’ları silip yeniden oluşturur, yani image değişmeden yeni bir
 rollout başlatır.
 	•	Yeni environment variable’lar yüklendiğinde
	•	ConfigMap veya Secret güncellendiğinde
	•	Ama image değişmediğinde
➡️ Bu durumda yeni rollout başlatmaz; işte burada rollout restart kullanırız.

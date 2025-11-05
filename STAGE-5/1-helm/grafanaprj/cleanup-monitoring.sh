#!/bin/bash
# 🧹 Kubernetes Monitoring Cleanup Script
# Bu script, Prometheus ve Grafana'yı Helm üzerinden tamamen kaldırır.

echo "🚀 Başlatılıyor: Prometheus & Grafana temizleme işlemi..."

# 1️⃣ Helm release'lerini kaldır
echo "🔸 Helm release'leri kaldırılıyor..."
helm uninstall grafana -n monitoring --ignore-not-found
helm uninstall prometheus -n monitoring --ignore-not-found

# 2️⃣ Namespace siliniyor
echo "🔸 'monitoring' namespace siliniyor..."
kubectl delete namespace monitoring --ignore-not-found

# 3️⃣ Helm repoları kaldırılıyor
echo "🔸 Helm repoları kaldırılıyor..."
helm repo remove grafana 2>/dev/null
helm repo remove prometheus-community 2>/dev/null
helm repo remove stable 2>/dev/null

# 4️⃣ Helm cache ve metadata temizliği
echo "🔸 Helm cache & config temizleniyor..."
rm -rf ~/.cache/helm ~/.config/helm ~/.local/share/helm

# 5️⃣ Kontrol
echo "✅ Temizlik tamamlandı!"
echo "Kalan repolar:"
helm repo list || echo "Hiç repo kalmadı."

echo "Kalan Helm release'leri:"
helm list -A || echo "Hiç release kalmadı."

echo "🎯 İşlem başarıyla tamamlandı."
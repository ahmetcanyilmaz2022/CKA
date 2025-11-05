#!/bin/bash
# 🚀 Helm Reset & Cleanup Tool
# Grafana, Prometheus veya tüm Helm verilerini temizlemek için etkileşimli araç.

set -e

echo ""
echo "🧹 Helm Reset Tool"
echo "--------------------------"
echo "1️⃣  Sadece Prometheus ve Grafana'yı kaldır"
echo "2️⃣  Tüm Helm release'lerini kaldır (tüm namespace'lerde)"
echo "3️⃣  Tüm Helm repolarını kaldır"
echo "4️⃣  Tam sıfırlama (release + repo + cache)"
echo "--------------------------"
read -p "Ne yapmak istiyorsun? (1/2/3/4): " choice
echo ""

case $choice in
  1)
    echo "🔸 Prometheus & Grafana kaldırılıyor..."
    helm uninstall grafana -n monitoring --ignore-not-found
    helm uninstall prometheus -n monitoring --ignore-not-found
    kubectl delete namespace monitoring --ignore-not-found
    ;;
  2)
    echo "⚠️  Tüm Helm release’leri kaldırılacak!"
    read -p "Emin misin? (y/n): " confirm
    if [[ $confirm == "y" ]]; then
      helm list -A -q | xargs -r -I {} helm uninstall {} -n $(kubectl get ns -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep -E '^default|monitoring|kube.*' | uniq)
      echo "✅ Tüm release’ler kaldırıldı."
    else
      echo "❌ İşlem iptal edildi."
    fi
    ;;
  3)
    echo "🔸 Helm repoları kaldırılıyor..."
    helm repo list -q | xargs -r -I {} helm repo remove {}
    echo "✅ Tüm repolar kaldırıldı."
    ;;
  4)
    echo "⚠️  TAM SIFIRLAMA BAŞLATILIYOR..."
    read -p "Emin misin? (y/n): " confirm
    if [[ $confirm == "y" ]]; then
      echo "🔸 Release’ler kaldırılıyor..."
      helm list -A -q | xargs -r -I {} helm uninstall {} -n $(kubectl get ns -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | uniq)
      echo "🔸 Repolar kaldırılıyor..."
      helm repo list -q | xargs -r -I {} helm repo remove {}
      echo "🔸 Cache & config temizleniyor..."
      rm -rf ~/.cache/helm ~/.config/helm ~/.local/share/helm
      echo "✅ Tüm Helm sistemi sıfırlandı."
    else
      echo "❌ İşlem iptal edildi."
    fi
    ;;
  *)
    echo "Geçersiz seçim. Çıkılıyor..."
    ;;
esac

echo ""
echo "🎯 İşlem tamamlandı!"
helm repo list || echo "Hiç repo kalmadı."
helm list -A || echo "Hiç release kalmadı."
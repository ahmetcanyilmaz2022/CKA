# Dev ortamı deploy
kubectl apply -k overlays/dev

# Prod ortamı deploy
kubectl apply -k overlays/prod


Kustomize Base–Overlay Yapısı (Dev & Prod Örneği)
Bu örnekte, Kustomize kullanarak tek bir “base” yapıdan iki farklı ortam (dev ve prod) oluşturuyoruz.
Amaç: YAML dosyalarını kopyalamadan, sadece farklı ortamlara özgü farkları overlay yapılarıyla tanımlamak.
🎯 Neden Kustomize?
Kustomize, Kubernetes manifest dosyalarını modüler hâle getirir.
Aynı uygulamayı farklı ortamlarda çalıştırırken, sadece farkları belirtmemizi sağlar.
Örneğin:
Dev ortamında: test için farklı imaj versiyonu veya namespace
Prod ortamında: daha güncel versiyon, farklı etiketler veya kaynak limitleri


8-kustomization/
│
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── hpa.yaml
│   └── kustomization.yaml
│
└── overlays/
    ├── dev/
    │   └── kustomization.yaml
    └── prod/
        └── kustomization.yaml

Sonuç
Kustomize sayesinde:
Tek bir base yapı oluşturduk.
Ortamlar arasında sadece farkları overlay olarak tanımladık.
YAML kopyalamadan, sade ve yönetilebilir bir mimari elde ettik.
commonLabels, namePrefix ve images gibi alanlarla ortamlar arasında kolayca özelleştirme sağladık.
Bu yapı, CI/CD pipeline’larında da mükemmel çalışır — her ortam için sadece farklı overlay dizinini uygularsın.
Sonuç: temiz, sürdürülebilir, profesyonel Kubernetes yönetimi. 💼



# SİLELİM 
kubectl delete -k overlays/prod 

kubectl delete -k overlays/dev
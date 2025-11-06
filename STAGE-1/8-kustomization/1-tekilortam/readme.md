# 🧩 Kustomize Nedir?

**Kustomize**, Kubernetes manifest dosyalarını (`.yaml`) **şablon kullanmadan** özelleştirmeye yarayan, `kubectl` içerisine entegre edilmiş yerleşik bir araçtır.

Farklı ortamlar (dev, test, prod) için aynı YAML dosyalarını tekrar tekrar kopyalayıp değiştirmek yerine,  
tek bir temel yapıdan (base) *katmanlı değişiklikler* (overlay) oluşturmamızı sağlar.

---

## ⚙️ Kustomize Ne İşe Yarar?

Kustomize sayesinde:

- YAML dosyalarını **şablon kullanmadan** özelleştirirsin.
- **Farklı ortamlar (dev, test, prod)** için aynı yapıdan varyasyonlar türetirsin.
- **Ortak etiketler, namespace ve imaj versiyonlarını** merkezi olarak yönetirsin.
- Tüm YAML’ları tek komutla uygularsın:
  ```bash
  kubectl apply -k .



myapp/
├── deployment.yaml
├── service.yaml
├── hpa.yaml
└── kustomization.yaml


# kubectl apply -k myapp/

Bu komut, tüm YAML dosyalarını Kustomize aracılığıyla birleştirip tek seferde uygular.
Sıra önemli değildir; Kubernetes gerekli objeleri uygun sırada yaratır.

kubectl get all
kubectl get hpa

NAME                         READY   STATUS    RESTARTS   AGE
pod/myapp-xxxxx              1/1     Running   0          10s
service/myapp                ClusterIP   10.x.x.x   <none>   80/TCP   10s
deployment.apps/myapp        1/1     1          1         10s
horizontalpodautoscaler.autoscaling/myapp-hpa   ...

# Kustomize
YAML dosyalarını tek manifest haline getirir.

# toplu sil
kubectl delete -k myapp/


# notlar
commonLabels ile yazdığın etiket,
➡️ tüm Deployment, Service, Pod, HPA, ConfigMap gibi objelere otomatik olarak eklenir.
Yani elle her YAML’a labels: yazmana gerek kalmaz.
kubectl get all -l project=autoscaling-demo

---------------------



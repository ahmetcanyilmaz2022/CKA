🧱 Örnek Senaryo
Diyelim ki myapp adında bir Deployment var.
Başlangıçta 1 pod çalışıyor, CPU artarsa 10 poda kadar çıkmasını istiyoruz.


# ÖNCELİKLE metric server 
cluster yapımızda bir metric server olasım lazım 
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

> DOCKER DESKTOP İSE:
kubectl edit deployment metrics-server -n kube-system

>spec.template.spec.containers.args kısmına bu satırı ekle:
        - --kubelet-insecure-tls

> deployment ı tekrar başlat 
kubectl rollout restart deployment metrics-server -n kube-system


>kontrol:
kubectl get pods -n kube-system | grep metrics
>çıktı:
metrics-server-68cf79589b-mw8nl          1/1     Running   0              34s


<🔍 Ne işe yarar?
Kubernetes’te her pod, container ve node’un CPU ve bellek (RAM) kullanımını ölçer ve bu verileri toplayıp API olarak sunar.
Bu veriler sayesinde bazı sistemler otomatik kararlar verebilir:>



# Deployment oluştur
kubectl apply -f myapp.yaml

# HPA oluştur
kubectl apply -f autoscale.yaml

# HPA durumunu izle
kubectl get hpa

# TEST ZAMANI :)

CPU yükü oluşturmak için aşağıdaki komutla stress aracı içeren bir Pod çalıştırabilirsin:

kubectl run -it load-generator --image=busybox --restart=Never -- /bin/sh

Pod içerisinde : stres oluşturalım:)

while true; do wget -q -O- http://myapp; done


Bir süre sonra:

kubectl get hpa
NAME        REFERENCE          TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
myapp-hpa   Deployment/myapp   cpu: 0%/50%   1         10        1          63s


kubectl get pods

NAME                     READY   STATUS    RESTARTS   AGE
load-generator           1/1     Running   0          63s
myapp-584879f864-zvzds   1/1     Running   0          109s


Pod sayısının otomatik arttığını göreceksin 🚀

fakat hemen değil:)

Metrics Server her 15 saniyede bir CPU/RAM verilerini toplar.
HPA ise bu metrikleri 30 saniyede bir değerlendirir.
Ortalama CPU kullanımı hedef değeri (örneğin %50) birkaç döngü boyunca yüksek kalırsa, pod sayısını artırır.
🎯 Yani:
Genelde 1 ila 2 dakika içinde pod sayısının artmaya başladığını görürsün.

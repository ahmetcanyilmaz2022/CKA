# 🌐 Kubernetes Ingress ve Ingress Controller

## 🚪 Ingress Nedir?
Kubernetes’te **Ingress**, dış dünyadan (örneğin tarayıcı veya kullanıcı) gelen **HTTP/HTTPS trafiğini** cluster içindeki **servislere yönlendiren bir yapı**dır.

Yani Ingress = **“HTTP trafiğini yöneten akıllı kapı”** gibidir.

---

## ⚙️ Ingress Controller Nedir?
Ingress nesnesi sadece yönlendirme kurallarını tanımlar.  
Ama bu kuralları **uygulayacak bir motora** ihtiyaç vardır.  
İşte o motor **Ingress Controller**’dır.

📄 `Ingress` → Kuralları belirtir  
⚙️ `Ingress Controller` → Bu kuralları çalıştırır  

Ingress Controller olmadan `Ingress` nesnesi **tek başına işe yaramaz**.

---

## 🧱 NGINX Ingress Controller Kurulumu
Kubernetes’te en sık kullanılan Ingress Controller, **NGINX Ingress Controller**’dır.

Kurulum komutu:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.1/deploy/static/provider/cloud/deploy.yaml


----------------------------------------------------------------------------------------------------------------------------------------


# docker dektop üzerinde çalışıyorsak Ingress Controller kurulumu 
<kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.1/deploy/static/provider/cloud/deploy.yaml>

> kontrol
<kubectl get pods -n ingress-nginx>

#	Burada localhost <test için kullanacağınız dns varsayalım> adresini /etc/hosts dosyasında Docker Desktop IP’sine yönlendirebilirsin:
<echo "$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}') localhost" | sudo tee -a /etc/hosts>

ilgili varsayılan dns i örn: localhost dedik docker desktop local de pratik yapacağımız için > /etc/hosts ile host yönlendirmesi yaparsan tarayıcıdan test edebilirsin.

spec:
  rules:
  - host: localhost   #Tarayıcıdan bu isimle erişim yapılacak. burası prod ortamda www.xxxxxx.com gibi olacak 
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web
            port:
              number: 80


> kontrol edelim 
echo "192.168.65.3 localhost" | sudo tee -a /etc/hosts

"192.168.65.3 localhost" | sudo tee -a /etc/hosts
192.168.65.3 localhost
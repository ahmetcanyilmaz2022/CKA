
<kubectl create secret generic db-user-pass \
    --from-literal=username=admin \
    --from-literal=password='S!B\*d$zDsb='>


# use source files:

<echo -n 'admin' > ./username.txt
echo -n 'S!B\*d$zDsb=' > ./password.txt>

<kubectl create secret generic db-user-pass \
    --from-file=./username.txt \
    --from-file=./password.txt>


# 🔐 Kubernetes Secret Türleri

Kubernetes'te `Secret`, gizli verileri (ör. şifre, token, sertifika) güvenli şekilde tutmak için kullanılır.  
Aşağıda en sık kullanılan Secret türleri listelenmiştir:

| Secret Tipi | Açıklama | Kullanım Alanı | Oluşturma Örneği |
|--------------|-----------|----------------|------------------|
| **generic** | Genel amaçlı, kullanıcı tanımlı secret’tır. | Şifreler, API token’ları, kullanıcı adları | `kubectl create secret generic mysecret --from-literal=user=admin --from-literal=pass=123` |
| **docker-registry** | Docker Registry kimlik bilgilerini içerir. | Private image’leri çekmek için | `kubectl create secret docker-registry regcred --docker-username=USER --docker-password=PASS --docker-email=EMAIL` |
| **tls** | SSL/TLS sertifikaları içerir. | HTTPS/Ingress için | `kubectl create secret tls my-tls --cert=cert.pem --key=key.pem` |
| **service-account-token** | ServiceAccount’a bağlı otomatik token secret’tır. | API erişimi ve RBAC yetkilendirmesi için | Kubernetes tarafından otomatik oluşturulur |

---

### 🔍 Secret Görüntüleme
```bash
kubectl get secrets
kubectl describe secret <secret-name>
kubectl get secret <secret-name> -o yaml
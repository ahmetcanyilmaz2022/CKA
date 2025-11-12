# from literal secret oluştur
kubectl create secret generic db-user-pass --from-literal=username=admin --from-literal=password=123456

> kubectl describe secret db-user-pass
> kubectl edit secret db-user-pass
> kubectl get secret db-user-pass -o yaml


# from file secret oluştur
echo -n 'admin' > username.txt
echo -n '123456' > password.txt

kubectl create secret generic db-user-pass --from-file=username.txt --from-file=password.txt
> kubectl describe secret db-user-pass
> kubectl edit secret db-user-pass
> kubectl get secret db-user-pass -o yaml

# base 64
>code:
echo -n 'admin' | base64
>decode
echo 'YWRtaW4=' | base64 --decode

# 🔐 Kubernetes Secret Türleri
Kubernetes’te dört temel Secret türü bulunur. Generic Secret, genel amaçlı ve kullanıcı tanımlı bir secrettır. Genellikle şifreler, API token’ları veya kullanıcı adları gibi hassas verileri saklamak için kullanılır. Örnek oluşturma komutu:
# kubectl create secret generic mysecret --from-literal=user=admin --from-literal=pass=123

Docker Registry Secret, Docker Registry kimlik bilgilerini içerir ve özel (private) image’lerin bulunduğu registry’lerden image çekmek için kullanılır. Örnek oluşturma komutu:
# kubectl create secret docker-registry regcred --docker-username=USER --docker-password=PASS --docker-email=EMAIL

TLS Secret, SSL/TLS sertifikalarını içerir ve genellikle HTTPS bağlantıları veya Ingress kaynakları için kullanılır. Örnek oluşturma komutu:
# kubectl create secret tls my-tls --cert=cert.pem --key=key.pem

Service Account Token Secret ise bir ServiceAccount’a otomatik olarak bağlı olan token secret’tır. Kubernetes API erişimi ve RBAC (Role-Based Access Control) yetkilendirmesi için kullanılır. Bu tür secret’lar Kubernetes tarafından otomatik olarak oluşturulur ve manuel olarak tanımlanmaz.


---

### 🔍 Secret Görüntüleme
```bash
kubectl get secrets
kubectl describe secret <secret-name>
kubectl get secret <secret-name> -o yaml
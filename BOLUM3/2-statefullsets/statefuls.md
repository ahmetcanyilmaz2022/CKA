# Kubernetes: Deployment vs StatefulSet

Kubernetes’te **Deployment** ve **StatefulSet** yapıları YAML olarak benzer görünebilir, ancak davranış ve kullanım amaçları farklıdır.  

---
<StatefulSet, Kubernetes’te veri tutan uygulamalar için kullanılır ve pod’ları sıralı olarak oluşturur ve siler. Bu, her pod’un bir öncekinden sonra başlamasını sağlar. Örneğin bir veritabanı cluster’ında önce pod-0 primary olarak çalışır, sonra pod-1 ve pod-2 replica olarak bağlanır. Böylece uygulama başlatılırken veri bütünlüğü korunur ve hata riski azalır. Pod’lar silinirken de ters sırayla kapanır, yani replica’lar önce kapanır, primary pod en son kapanır. Bu mekanizma sayesinde StatefulSet, dağıtık sistemlerde doğru başlatma sırası, veri güvenliği ve kesintisiz çalışmayı garanti eder.
StatefulSet, veri tutan ve pod kimliğinin önemli olduğu uygulamalarda gerekir; örneğin veritabanı cluster’ları, Kafka/Zookeeper, Redis veya Elasticsearch cluster’ları.>

## 1. Temel Kavramlar

### Deployment
- Stateless uygulamalar için kullanılır.
- Pod’lar birbirinin yerine geçebilir, kimlikleri önemli değildir.
- Örnek: Web sunucuları, API servisleri.

### StatefulSet
- Stateful (veri tutan) uygulamalar için kullanılır.
- Pod’lar benzersiz kimliğe sahiptir (`pod-0`, `pod-1`).
- Her pod’a bağlı PersistentVolume kalıcıdır.
- Sıralı deploy ve scaling yapılır.
- Örnek: Veritabanları, Kafka, Zookeeper.

---

## 2. Pod Kimliği ve İsmi

| Özellik        | Deployment                      | StatefulSet                                   |
|----------------|---------------------------------|-----------------------------------------------|
| Pod isimleri   | Rastgele (`mypod-xyz123`)      | Kararlı ve sıra numaralı (`mypod-0`, `pod-1`) |
| Kimlik önemi   | Yok                            | Var, her pod eşsizdir                          |

---

## 3. Storage / Volume

| Özellik        | Deployment                         | StatefulSet                                   |
|----------------|------------------------------------|-----------------------------------------------|
| PVC davranışı  | Pod silinse PVC otomatik bağlanmaz | Her pod’a benzersiz PV bağlanır, pod yeniden başlasa da veri korunur |

---

## 4. Deployment ve Scaling

| Özellik             | Deployment         | StatefulSet                  |
|---------------------|--------------------|------------------------------|
| Pod oluşturma/silme | Aynı anda          | Sırasıyla (0 → 1 → 2)        |
| Rolling update      | Rastgele           | Sıralı ve kontrollü          |

---

## 5. DaemonSet ile Karşılaştırma (Bugünkü Notlar)

```yaml
apiVersion: apps/v1
kind: DaemonSet   # Her node’da bir pod oluşturur
metadata:
  name: opslab
spec:
  selector:
    matchLabels:
      name: opslab   # DaemonSet, bu label’a sahip podları yönetir
  template:
    metadata:
      labels:
        name: opslab   # Pod label’ı selector ile eşleşmeli
    spec:
      tolerations:   # Master/control-plane node’larda da çalışmasını sağlar
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
      containers:
      - name: nginx
        image: nginx   # Container image
        resources:    # Requests ≤ Limits olmalı
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
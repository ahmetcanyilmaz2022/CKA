
# bir node yapısına taint ekleme
kubectl taint nodes <node-adi> key=value:NoSchedule
kubectl describe node node01     veya     <kubectl describe node <node-name> | grep -i taints>
Bir taint, belirli koşullarda pod’ların o node’a schedule edilmesini engeller.

Bu örnekte:
	•	key → taint’in anahtar adı
	•	value → taint’in değeri
	•	NoSchedule → etki (effect) kısmıdır; bu, pod’ların o node’a atanmamasını (schedule edilmemesini) söyler.
---------------------------------
# bir pod yapısına taint ekleme
---
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: nginx
    image: nginx
  tolerations:
  - key: "env"               
    operator: "Equal"        # key ve value birebir eşleşiyorsa tolerasyon geçerli olur.
    value: "prod"      
    effect: "NoSchedule"
# açıklaması ? “Ben env=production:NoSchedule taint’ine sahip bir node’a yerleşebilirim, bundan rahatsız olmam.”
Operator
# Equal
key ve value birebir eşleşiyorsa tolerasyon geçerli olur.
key: "env", value: "production" → sadece env=production taint’ini tolere eder.
# Exists
key varsa (değer fark etmeksizin) tolerasyon geçerlidir.
key: "env" → env=anything taint’lerini tolere eder.

-----------------------------------------------------------
# node üzerinden taini kaldırır "-"
<kubectl taint nodes <node-adi> key=value:NoSchedule->

----------------------------------------------------------

# deployment üzerinde örneği
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
      tolerations:
      - key: "env"                # Taint key'i (örneğin: env)
        operator: "Equal"         # Key ve value birebir eşleşirse geçerli olur
        value: "production"       # Taint'in value'su
        effect: "NoSchedule"      # Bu taint varsa, sadece tolerasyonu olan pod'lar o node'a schedule edilir
---

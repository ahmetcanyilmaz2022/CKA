# Node üzerinde etiket label ekleme komutu 
<kubectl label nodes node-name etiketkey=etiketvalue>

# Node üzerinden etiket kaldırmak için 
<kubectl label node node-name etiketkey=etiketvalue->

# Node yapıları üzerlerindeki label ları göster 
<kubectl get nodes --show-labels>
-------------------------------------------------------

# Label ekleyerek pod oluşturma:
<kubectl run mypod --image=nginx --labels="env=prod,team=devops">

# Etiketleri kontrol etmek için:
<kubectl get pods --show-labels>

# veya sadece label’ları listelemek istersen:
<kubectl get pod mypod --show-labels>
   


########## pod yapısı label ############,

apiVersion: v1
kind: Pod
metadata:
  name: label-pod
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    env: prod


########## deployment yapısı label ############,

apiVersion: apps/v1
kind: Deployment
metadata:
  name: label-deploy
spec:
  replicas: 4
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      nodeSelector:
        env: prod     # Bu deployment sadece "env=prod" etiketi olan node'lara pod yerleştirir
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80









## taints tol. den farkı etiketlenmiş podları vs sadece burada çalıstır etiket yoksa başka pod kabul etmem değil .... label da her pod bu nodda çalışabilir ama label var sa o kesinlikle bende çalışmalı :) 


# EXPOSE
kubectl expose pod podname --port=80 --target-port=80 --name=nginx-service --type=ClusterIP
kubectl expose deployment deploy --port=80 --target-port=80 --name=deploysvc --type=NodePort
## etc

kubectl get ep
# ep = Endpoints
	•	Bu komut, Service’in bağlı olduğu pod IP’lerini gösterir.

# LİSTELE
kubectl get service

# İNCELE
kubectl describe service <svc-name>

# SİL
kubectl delete service  <SVC-NAME>

# DÜZENLE
kubectl edit service <svc-name>

## ADD SPESIFIC PORT NUMBER 
kubectl expose pod nginx-pod --name nginx-service --port 80 --type NodePort -o yaml --dry-run=client > nginx-service.yaml


# deployment expose svc 
kubectl create deploy svcdeploy --image=redis --replicas=3 
kubectl expose deploy svcdeploy --name deploysvc --port 80 --type NodePort
kubectl get pods -o wide 
kubectl get ep

# Imperative env ile pod olustur
<kubectl run mypod --image=nginx --env="MODE=production">

# yaml 
kubectl run mypod --image=nginx --env="MODE=production" --dry-run=client -o yaml

# pod içerisindeki env görüntüle
<kubectl exec -it mypod -- env>
printenv | grep -i "mode".    :)

# birden fazla env ekle 
kubectl run myapp --image=busybox --env="ENV=dev" --env="VERSION=1.0" --command -- sh -c "sleep 3600"



>Halihazırda çalışan bir Pod’a doğrudan env eklenemez — çünkü Pod’lar immutable’dır (değiştirilemez).
Yani bir Pod oluşturulduktan sonra içindeki container spec’lerini (örneğin env, image, command, vb.) değiştiremezsin.

>Pod tek başına (Deployment yok)
Pod’u silip YAML ile yeniden oluştur

>Pod bir Deployment tarafından yönetiliyor
<kubectl set env deployment <deploy_adı> VAR=value>


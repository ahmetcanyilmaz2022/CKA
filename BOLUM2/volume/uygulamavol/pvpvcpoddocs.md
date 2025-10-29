# local path üzerinde: pvnin direk volume olarak görmesi için ;
# macos kullanıcısı için :
sudo mkdir /Users/kullanıcıadı/k8sdata
cd /users/kullanıcıadı/k8sdata
sudo touch index.html
sudo chmod 777 index.html      # klasör okunabilir ve execute olmalı pod için
vim index.html ile html içeriği içerisine koyulmalı ki nginx pod bu volumden almalı 

# Windows docker desktop
# Windows üzerinde PowerShell veya CMD'de:
mkdir C:\Users\USERNAME\k8sdata
cd C:\Users\USERNAME\k8sdata
echo <h1>Merhaba Kubernetes!</h1> > index.html
pv hostPath:
  path: "/run/desktop/mnt/host/c/Users/USERNAME/k8sdata"



##### pv,pvc,pod ayağa kaldırılmalı fakat pod hortpath yolu users/kullanıcıadı/k8sdata olmalı yeni oluşturulan index.html dizini 

          
# kubectl exec -it task-pv-pod -- /bin/bash

cd /usr/share/nginx/html


# Be sure to run these 3 commands inside the root shell that comes from
# running "kubectl exec" in the previous step
apt update
apt install vim 
vim index.html      #düzenle ve çık
apt install curl
curl http://localhost/

## veya podu service ile expose ederek localhosttan test edilebilir

<kubectl expose pod task-pv-pod --port=80 --name=volumesvc --type=NodePort -o yaml --dry-run=client > svc.yaml>

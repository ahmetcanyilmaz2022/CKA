KUBERNETES RBAC SENARYO VE TESTLER

==========================================
1️⃣ ROLE & ROLEBINDING (Namespace bazlı)
==========================================

# Namespace oluştur
kubectl create namespace acme

# ServiceAccount oluştur
kubectl create serviceaccount myapp -n acme

# Role oluştur (pod okuma izni)
kubectl create role pod-reader \
  --verb=get --verb=list --verb=watch \
  --resource=pods \
  -n acme

# RoleBinding oluştur
kubectl create rolebinding myapp-pod-reader-binding \
  --role=pod-reader \
  --serviceaccount=acme:myapp \
  -n acme

# Kısa yetki testi (yes/no)
kubectl auth can-i list pods --as=system:serviceaccount:acme:myapp -n acme
kubectl auth can-i list services --as=system:serviceaccount:acme:myapp -n acme

==========================================
2️⃣ CLUSTERROLE & CLUSTERROLEBINDING (Küme genelinde)
==========================================

# Namespace oluştur
kubectl create namespace devops

# ServiceAccount oluştur
kubectl create serviceaccount myapp -n devops

# ClusterRole oluştur (tüm cluster pod okuma izni)
kubectl create clusterrole pod-reader \
  --verb=get,list,watch \
  --resource=pods

# ClusterRoleBinding oluştur
kubectl create clusterrolebinding myapp-view-binding \
  --clusterrole=pod-reader \
  --serviceaccount=devops:myapp

# Kısa yetki testleri (yes/no)
kubectl auth can-i list pods --as=system:serviceaccount:devops:myapp -n devops
kubectl auth can-i list pods --as=system:serviceaccount:devops:myapp -n default
kubectl auth can-i list pods --as=system:serviceaccount:devops:myapp -n kube-system
kubectl auth can-i list secrets --as=system:serviceaccount:devops:myapp -A
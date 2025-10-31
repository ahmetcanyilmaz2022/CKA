CKA-CKAD RBAC CEVAPLARI
ServiceAccount Oluşturma

kubectl create serviceaccount cicd-token --namespace=app-team1
ClusterRole Oluşturma
deployment-clusterrole adında bir ClusterRole oluşturacağız. Bu role, sadece Deployment, StatefulSet ve DaemonSet kaynaklarını oluşturma izni verecek 

kubectl create clusterrole deployment-clusterrole --verb=create --resource=deployments,statefulsets,daemonsets
ClusterRoleBinding Oluşturma
Son olarak, deployment-clusterrole rolünü cicd-token ServiceAccount'ına bağlamak için bir ClusterRoleBinding oluşturacağız. Bu bağlamada, rol sadece app-team1 namespace'inde geçerli olacaktır.

kubectl create rolebinding cicd-token-binding --clusterrole=deployment-clusterrole --serviceaccount=app-team1:cicd-token \
 --namespace=app-team1
ClusterRole oluşturduk (deployment-clusterrole).
ServiceAccount oluşturduk (cicd-token).
ClusterRoleBinding ile bu rolü ServiceAccount'a bağladık ve bunu sadece app-team1 namespace'ine sınırladık.
A1:

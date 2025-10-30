<kubectl create cm cmname --form-literal=key=value --from-literal=key=value>

veya file yapısından değerleri almak istiyorsak 
<kubectl create configmap mycm \
  --from-file=USER=user.txt \
  --from-file=PASS=pass.txt>
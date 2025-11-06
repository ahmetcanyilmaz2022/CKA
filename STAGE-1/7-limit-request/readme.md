Kubernetes’te Requests ve Limits Nedir?
Kubernetes, her pod’un CPU ve bellek kullanımını yönetebilmek için iki önemli kaynak tanımı kullanır:
🟢 requests
Pod’un minimum ihtiyaç duyduğu kaynaktır.
Scheduler (planlayıcı), pod’u yerleştirirken bu miktara göre node seçer.
Örnek: cpu: 100m → pod’un çalışabilmesi için en az bu kadar CPU gerekir.
🔴 limits
Pod’un kullanabileceği maksimum kaynaktır.
Uygulama daha fazlasını kullanmak isterse Kubernetes bunu kısıtlar.
Örnek: cpu: 500m → pod en fazla bu kadar CPU kullanabilir.



1️⃣ CPU limitini aşarsa
Kubernetes CPU’yu “paylaşılabilir” bir kaynak olarak görür.
Eğer container CPU limitini aşmaya çalışırsa, throttling (yavaşlatma) uygular.
👉 Yani container çalışmaya devam eder ama CPU erişimi kısıtlanır.
Uygulama yavaşlar, ama çökmez.
kubectl top pods çıktısında CPU %100 görünebilir ama tepki süresi uzar.

2️⃣ Memory limitini aşarsa
RAM limitleri CPU’dan farklıdır: aşılırsa container anında öldürülür (OOMKilled).
“Out Of Memory” hatası alırsın.
Kubernetes, container’ı yeniden başlatır.


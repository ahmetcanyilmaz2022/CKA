Pod Name               | READY | STATUS               | RESTARTS | AGE  | Açıklama
----------------------+-------+--------------------+----------+------+---------------------------------------------------------
example-job-bzlkr     | 0/1   | Pending             | 0        | 0s   | Pod scheduler tarafından node’a atanıyor
example-job-bzlkr     | 0/1   | Pending             | 0        | 0s   | Henüz container başlamadı
example-job-bzlkr     | 0/1   | ContainerCreating   | 0        | 0s   | Container image çekiliyor ve pod başlatılıyor
example-job-bzlkr     | 0/1   | Completed           | 0        | 3s   | Pod içindeki komut başarıyla tamamlandı
example-job-bzlkr     | 0/1   | Completed           | 0        | 4s   | Pod artık Job’un bir parçası olarak tamamlandı
example-job-9n7r6     | 0/1   | Pending             | 0        | 0s   | Yeni pod oluşturuluyor, Node ataması yapılacak
example-job-9n7r6     | 0/1   | Pending             | 0        | 0s   | Container henüz başlamadı
example-job-bzlkr     | 0/1   | Completed           | 0        | 5s   | Önceki pod tamamlandı, Job toplam completions sayısını ilerletiyor
example-job-9n7r6     | 0/1   | ContainerCreating   | 0        | 0s   | Container image yükleniyor
example-job-9n7r6     | 0/1   | Completed           | 0        | 2s   | Pod içindeki komut tamamlandı
example-job-9n7r6     | 0/1   | Completed           | 0        | 3s   | Pod artık Job’un tamamlanan pod’ları arasında
example-job-48zjq     | 0/1   | Pending             | 0        | 0s   | Son pod oluşturuluyor, Node ataması bekleniyor
example-job-48zjq     | 0/1   | Pending             | 0        | 0s   | Container henüz başlamadı
example-job-9n7r6     | 0/1   | Completed           | 0        | 4s   | Önceki pod tamamlandı, Job completions ilerliyor
example-job-48zjq     | 0/1   | ContainerCreating   | 0        | 0s   | Container image yükleniyor
example-job-48zjq     | 0/1   | Completed           | 0        | 2s   | Pod içindeki komut başarıyla tamamlandı
example-job-48zjq     | 0/1   | Completed           | 0        | 3s   | Pod artık Job’un tamamlanan pod’ları arasında
example-job-48zjq     | 0/1   | Completed           | 0        | 4s   | Job için gerekli 3 pod tamamlandı, Job Completed oldu

---

# test :::::
<kubectl logs podname>

### Job Özeti

- Bu Job, **`completions: 3`** olarak tanımlandığı için **3 ayrı pod çalıştırdı** ve her biri sırayla veya paralel şekilde çalıştı.  
- Her pod içindeki **komut `"echo Merhaba, Kubernetes Job çalışıyor!"`** başarıyla çalıştı.  
- Pod’lar `Pending → ContainerCreating → Completed` sırasını izleyerek Job’un çalışma mantığını gösterdi.  
- `backoffLimit` sayesinde, eğer pod başarısız olsaydı **belirlenen sayıda yeniden deneme yapılacaktı**.  

> Özetle: Bu Job, Kubernetes’te bir görevin **belirli sayıda pod ile çalıştırılması ve tamamlanmasını sağlayan obje**dir. Bu örnekte basit bir mesaj yazdırarak Job mantığını görselleştirdik ve doğruladık.
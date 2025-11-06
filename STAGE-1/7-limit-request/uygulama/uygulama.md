
 Kubernetes OOMKilled ve CPU Throttling Demo

Bu demo, Kubernetes pod’larının memory limitlerini aşınca **OOMKilled** ve CPU limitlerini aşınca **throttling** 
davranışlarını göstermek için hazırlandı. Ayrıca `args` ve `resources` kullanımını, 
pod davranışlarını adım adım öğrenmeni sağlar.

## Amaç
- Pod’a düşük memory limiti verip stres testi uygulamak → OOMKilled gözlemek.
- Pod’a CPU limitleri verip aşırı yük oluşturmak → throttling davranışını gözlemek.
- Deployment sayesinde pod’ların otomatik yeniden başlatılmasını görmek.








        command: ["stress"]
        args: ["--vm", "1", "--vm-bytes", "200M", "--vm-hang", "1"]
# Args Açıklaması
--vm 1 → 1 tane virtual memory worker oluştur (RAM kullanacak iş parçacığı)
--vm-bytes 200M → Her worker için 200MB bellek tahsis et
--vm-hang 1 → İşlem sürekli çalışsın (1 saniye yerine sürekli hang)
--cpu 2 → 2 CPU iş parçacığı kullan (CPU aşımı için)
--timeout 30s → İşlem 30 saniye sonra durur (CPU stres testi için)
Bu args sayesinde container hem RAM hem CPU üzerinde yük oluşturacak. Kubernetes pod’u OOMKilled veya CPU throttling ile sınırlandıracak.
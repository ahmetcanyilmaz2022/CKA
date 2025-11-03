# Kubernetes Node Yönetimi: Cordon, Uncordon ve Drain

## Cordon
- Düğümü **yeni pod planlaması için kapatır**.
- Komut: `kubectl cordon <node_name>`
- Etkisi: Yeni pod'lar artık bu düğüme atanmaz, ancak mevcut pod'lar çalışmaya devam eder.
- Kullanım: Bakım öncesi düğümü yeni pod'lara kapatmak için.

## Uncordon
- Düğümü **yeniden planlama için açar**.
- Komut: `kubectl uncordon <node_name>`
- Etkisi: Yeni pod'lar artık bu düğüme atanabilir.
- Kullanım: Bakımdan sonra düğümü yeniden iş yüklerine açmak için.

## Drain
- Düğümü **bakıma almak veya kapatmak için tüm pod'ları güvenli bir şekilde başka düğümlere taşır**.
- Komut: `kubectl drain <node_name> --ignore-daemonsets`
- Etkisi: DaemonSet pod'ları hariç diğer tüm pod'lar başka düğümlere taşınır.
- `--ignore-daemonsets`: DaemonSet pod'larını taşımaya çalışmaz, göz ardı eder.
- Kullanım: Düğümdeki pod'ları boşaltarak bakım veya kapatma işlemleri için hazır hale getirmek için.

## Özet
- **Cordon:** Bakım öncesinde yeni pod'ların düğüme atanmasını durdurmak için.  
- **Uncordon:** Bakımdan sonra düğümü yeniden iş yüklerine açmak için.  
- **Drain:** Düğümdeki pod'ları boşaltarak bakım veya kapatma işlemleri için hazır hale getirmek için.




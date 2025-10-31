  accessModes:
    - ReadWriteOnce            
      # Tek bir node'dan okuma ve yazma erişimi sağlar.
      # Bu mod, bir volume’un yalnızca tek bir node'a monte edilmesine izin verir.
    - ReadOnlyMany            
      # Birden fazla node'un aynı anda sadece okuma erişimine sahip olmasını sağlar. 
      # Volume, birden fazla node tarafından yalnızca okuma amaçlı olarak kullanılabilir.
    - ReadWriteMany           
      # Birden fazla node'un aynı anda okuma ve yazma erişimine sahip olmasını sağlar.
      # Bu, birden fazla node'un aynı volume’u hem okuma hem de yazma için kullanabilmesi anlamına gelir.

      # Kubernetes Volume Access Modes

| Access Mode | Açıklama |
|------------|----------|
| **ReadWriteOnce (RWO)** | Pod başına tek node üzerinde okuma-yazma erişimi sağlar. Tek pod aynı volume’u mount edebilir. |
| **ReadOnlyMany (ROX)** | Birden fazla pod birden fazla node’dan sadece okuma için mount edebilir. |
| **ReadWriteMany (RWX)** | Birden fazla pod birden fazla node’dan hem okuma hem yazma için mount edebilir. |
| **ReadWriteOncePod (RWOP)** *(K8s 1.22+)* | Pod başına tek pod erişimi, diğer pod’lar aynı node’da bile volume’a erişemez. |

# Kubernetes PersistentVolume Reclaim Policy

**Reclaim Policy**, bir PersistentVolume (PV) kullanımdan kalktığında (PVC silindiğinde) ne yapılacağını belirler.

| Policy | Açıklama |
|--------|----------|
| **Retain** | PV, PVC silinse bile **veriyi saklar**. Admin manuel olarak temizlemeli veya yeniden kullanmalı. |
| **Delete** | PV’ye bağlı **cloud provider storage** (örn. AWS EBS, GCP PD) otomatik silinir. |
| **Recycle** *(deprecated)* | PV içeriği **basitçe silinir ve temizlenir**, yeniden kullanılabilir hale gelir. (Artık kullanılmıyor) |

## Özet / Notlar
- **Retain** → Prod ortamda veri kaybını önlemek için tercih edilir.  
- **Delete** → Test veya geçici ortamlar için uygun.  
- **Recycle** → Modern Kubernetes sürümlerinde artık kullanılmıyor.


kubectl exec -it task-pv-pod -c task-pv-container -- bash
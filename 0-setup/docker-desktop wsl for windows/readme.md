# Windows 11'de WSL 2, Docker Desktop ve Kubernetes Kurulum Rehberi

## Ön Gereksinimler

- Windows 11 (veya Windows 10 version 2004 ve üzeri)
- Yönetici (Administrator) yetkisi
- Minimum 8GB RAM (önerilen)
- Virtualization BIOS'ta aktif olmalı

---

## 1. WSL 2 Kurulumu

### Adım 1.1: PowerShell'i Yönetici Olarak Açın

Windows tuşuna basın, "PowerShell" yazın, sağ tıklayıp **"Yönetici olarak çalıştır"** seçeneğini seçin.

### Adım 1.2: WSL'i Kurun

Aşağıdaki komutu çalıştırın:

```powershell
wsl --install
```

Bu komut otomatik olarak şunları yapar:
- WSL 2'yi kurar
- Ubuntu'yu varsayılan Linux dağıtımı olarak kurar
- Virtual Machine Platform özelliğini etkinleştirir

### Adım 1.3: Bilgisayarı Yeniden Başlatın

Kurulum tamamlandıktan sonra bilgisayarınızı yeniden başlatın.

### Adım 1.4: Ubuntu İlk Kurulumu

Yeniden başlatma sonrası Ubuntu terminali otomatik açılacaktır. Sizden istenecekler:

```
Enter new UNIX username: [kullanıcı_adınız]
New password: [şifreniz]
Retype new password: [şifreniz tekrar]
```

**Not:** Şifre yazarken ekranda hiçbir şey görünmez, bu normaldir.

### Adım 1.5: WSL 2 Versiyonunu Kontrol Edin

PowerShell'de kontrol edin:

```powershell
wsl --list --verbose
```

Çıktı şuna benzer olmalı:
```
  NAME      STATE           VERSION
* Ubuntu    Running         2
```

Eğer VERSION sütunu "1" gösteriyorsa:

```powershell
wsl --set-version Ubuntu 2
wsl --set-default-version 2
```

### Adım 1.6: Ubuntu'yu Güncelleyin

Ubuntu terminalinde:

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. Docker Desktop Kurulumu

### Adım 2.1: Docker Desktop'ı İndirin

Tarayıcınızda şu adrese gidin:
```
https://www.docker.com/products/docker-desktop/
```

**"Download for Windows"** butonuna tıklayın.

### Adım 2.2: Kurulumu Başlatın

1. İndirilen `Docker Desktop Installer.exe` dosyasını çalıştırın
2. Kurulum sırasında **"Use WSL 2 instead of Hyper-V"** seçeneğinin işaretli olduğundan emin olun
3. **"Ok"** butonuna tıklayın
4. Kurulum tamamlandığında **"Close and restart"** butonuna tıklayın

### Adım 2.3: Docker Desktop'ı Başlatın

1. Bilgisayar yeniden başladıktan sonra Docker Desktop'ı açın
2. Servis sözleşmesini kabul edin (**Accept**)
3. Önerilen ayarlarla devam edin (**Use recommended settings**)
4. Docker Desktop'ın başlamasını bekleyin (alttaki durum çubuğunda "Docker Desktop is running" yazmalı)

### Adım 2.4: Docker Kurulumunu Doğrulayın

PowerShell veya CMD'de:

```powershell
docker --version
```

Çıktı:
```
Docker version 24.x.x, build xxxxxxx
```

Test komutu:
```powershell
docker run hello-world
```

Bu komut başarılı bir şekilde çalışmalı ve "Hello from Docker!" mesajı görmelisiniz.

---

## 3. Kubernetes'i Etkinleştirin

### Adım 3.1: Docker Desktop Ayarlarına Girin

1. Docker Desktop penceresinin sağ üstündeki **ayar simgesine (⚙️)** tıklayın
2. Sol menüden **"Kubernetes"** seçeneğini seçin

### Adım 3.2: Kubernetes'i Aktif Edin

1. **"Enable Kubernetes"** kutucuğunu işaretleyin
2. **"Show system containers (advanced)"** kutucuğunu işaretleyin (opsiyonel, önerilen)
3. **"Apply & Restart"** butonuna tıklayın

**Önemli:** İlk kurulumda Kubernetes imajlarını indireceği için 5-10 dakika sürebilir. Sol alttaki Kubernetes simgesi yeşil olana kadar bekleyin.

### Adım 3.3: Kubernetes Kurulumunu Doğrulayın

PowerShell'de:

```powershell
kubectl version --client
```

Çıktı:
```
Client Version: v1.x.x
```

Cluster bilgilerini kontrol edin:

```powershell
kubectl cluster-info
```

Çıktı:
```
Kubernetes control plane is running at https://kubernetes.docker.internal:6443
CoreDNS is running at https://kubernetes.docker.internal:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

Node'ları kontrol edin:

```powershell
kubectl get nodes
```

Çıktı:
```
NAME             STATUS   ROLES           AGE   VERSION
docker-desktop   Ready    control-plane   10m   v1.x.x
```

---

## 4. WSL Entegrasyonunu Yapılandırın

### Adım 4.1: WSL Integration Ayarları

1. Docker Desktop **Settings** → **Resources** → **WSL Integration**
2. **"Enable integration with my default WSL distro"** işaretli olmalı
3. Ubuntu dağıtımının yanındaki anahtarı aktif edin
4. **"Apply & Restart"**

### Adım 4.2: Ubuntu (WSL) İçinden Docker'ı Test Edin

Ubuntu terminalini açın (Windows'ta "Ubuntu" yazıp Enter'a basın):

```bash
docker --version
docker ps
kubectl get nodes
```

Tüm komutlar çalışmalıdır.

---

## 5. Performans İyileştirmeleri (Opsiyonel)

### WSL 2 Kaynak Sınırlamalarını Ayarlayın

Windows'ta `C:\Users\<KullanıcıAdınız>` klasörüne gidin ve `.wslconfig` dosyası oluşturun:

```ini
[wsl2]
memory=4GB
processors=2
swap=2GB
localhostForwarding=true
```

**Not:** RAM ve CPU değerlerini bilgisayarınızın kapasitesine göre ayarlayın.

Değişikliklerin geçerli olması için WSL'i yeniden başlatın:

```powershell
wsl --shutdown
```

### Docker Desktop Kaynak Ayarları

1. Docker Desktop **Settings** → **Resources**
2. **CPU limit**, **Memory limit** ve **Swap** değerlerini ihtiyacınıza göre ayarlayın
3. **Apply & Restart**

---

## 6. Yararlı Komutlar

### WSL Komutları

```powershell
# WSL dağıtımlarını listele
wsl --list --verbose

# WSL'i kapat
wsl --shutdown

# Belirli bir dağıtımı başlat
wsl -d Ubuntu

# WSL'i güncelle
wsl --update

# WSL durumunu kontrol et
wsl --status
```

### Docker Komutları

```powershell
# Docker durumunu kontrol et
docker info

# Çalışan container'ları listele
docker ps

# Tüm container'ları listele (durmuş olanlar dahil)
docker ps -a

# Docker imajlarını listele
docker images

# Container loglarını görüntüle
docker logs <container_id>
```

### Kubernetes Komutları

```powershell
# Cluster bilgisi
kubectl cluster-info

# Node'ları listele
kubectl get nodes

# Tüm namespace'lerdeki pod'ları listele
kubectl get pods --all-namespaces

# Belirli bir namespace'deki kaynakları listele
kubectl get all -n <namespace>

# Servis oluştur
kubectl create deployment hello-world --image=nginx

# Servisi dışarı aç
kubectl expose deployment hello-world --type=NodePort --port=80
```

---

## 7. Sorun Giderme

### WSL Kurulum Hatası

Eğer `wsl --install` komutu çalışmazsa:

```powershell
# Windows özelliklerini manuel etkinleştir
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Bilgisayarı yeniden başlat ve tekrar dene
wsl --install -d Ubuntu
```

### Docker Desktop Başlamıyor

1. Bilgisayarınızı yeniden başlatın
2. WSL'in çalıştığından emin olun: `wsl --list --verbose`
3. Docker Desktop'ı sıfırlayın: Settings → Troubleshoot → Reset to factory defaults
4. Antivirüs yazılımınızı geçici olarak devre dışı bırakın ve tekrar deneyin

### Kubernetes Pod'ları Başlamıyor

```powershell
# Kubernetes'i sıfırla
# Docker Desktop Settings → Kubernetes → Reset Kubernetes Cluster
```

### WSL Ağ Sorunları

```bash
# DNS ayarlarını düzelt (Ubuntu terminalinde)
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "[network]" > /etc/wsl.conf'
sudo bash -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
```

PowerShell'de WSL'i yeniden başlatın:
```powershell
wsl --shutdown
```

---

## 8. Ek Kaynaklar

- **Docker Dokümantasyonu:** https://docs.docker.com/
- **Kubernetes Dokümantasyonu:** https://kubernetes.io/docs/
- **WSL Dokümantasyonu:** https://docs.microsoft.com/en-us/windows/wsl/
- **kubectl Cheat Sheet:** https://kubernetes.io/docs/reference/kubectl/cheatsheet/

---

## Kontrol Listesi

Kurulumunuzun başarılı olup olmadığını kontrol etmek için:

- [ ] `wsl --list --verbose` komutu Ubuntu'yu VERSION 2 ile gösteriyor
- [ ] `docker --version` çalışıyor
- [ ] `docker run hello-world` başarılı
- [ ] Docker Desktop açık ve çalışıyor
- [ ] `kubectl get nodes` docker-desktop node'unu gösteriyor
- [ ] `kubectl cluster-info` cluster bilgilerini gösteriyor
- [ ] Ubuntu terminalinden docker ve kubectl komutları çalışıyor

Tüm maddeler işaretliyse kurulumunuz başarılı! 🎉

---

**Son Güncelleme:** Kasım 2025  
**Hazırlayan:** Docker & Kubernetes Eğitim Materyali

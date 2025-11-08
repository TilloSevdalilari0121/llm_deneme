# Local Model Runner - Delphi 12

## ÇOK ÖNEMLİ - DLL'LERİ HAZIRLA!

**Ben (AI) DLL derleyemiyorum!** Siz Windows'ta çalıştırmanız gerekiyor.

### TEK ADIM:

```cmd
setup_dependencies.bat
```

**BU SCRIPT:**
1. SQLite3 DLL'i otomatik indirir
2. llama.cpp'yi ROCm ile derler (ya da CPU-only)
3. Her şeyi hazır hale getirir

**Sonra Delphi 12'de aç ve derle!**

---

## Detaylar

### Script Ne Yapar?

1. **SQLite3:** Otomatik indirir (internet gerekli)
2. **llama.cpp:**
   - ROCm varsa → GPU versiyonu derler
   - Yoksa → CPU-only derler

### Gereksinimler

- **CMake:** https://cmake.org/download/
- **Git:** https://git-scm.com/download/win
- **Visual Studio 2022** (C++ tools)
- **ROCm** (opsiyonel, GPU için): https://rocm.docs.amd.com

### Manuel Kurulum

Eğer script çalışmazsa:

```cmd
# SQLite3
cd build_tools
download_sqlite3.bat

# llama.cpp (ROCm)
build_llama_rocm.bat

# veya CPU-only
build_llama_cpu.bat
```

---

## Derleme (Delphi 12)

DLL'ler hazır olduktan sonra:

1. **LocalModelRunner.dpr** aç
2. **Project → Build**
3. Çalıştır!

---

## Özellikler

✅ ROCm GPU desteği (AMD)
✅ 5 farklı tema
✅ SQLite veritabanı
✅ GGUF model desteği
✅ Ollama/LM Studio/Jan uyumlu
✅ Kod workspace asistanı
✅ Streaming inference
✅ Portable (tüm dosyalar EXE yanında)

---

## Dosya Yapısı

```
LocalModelRunner.exe    ← Ana program
llama.dll              ← Çalışma zamanında extract edilir
sqlite3.dll            ← Çalışma zamanında extract edilir
localmodel.db          ← Veritabanı (otomatik oluşur)
```

Tüm dosyalar **EXE ile aynı dizinde** saklanır (portable!).

---

## Sorun mu var?

**DLL bulunamıyor:**
- `setup_dependencies.bat` tekrar çalıştır
- `llama.dll` ve `sqlite3.dll` proje dizininde olmalı

**ROCm derlemesi başarısız:**
- ROCm yüklü mü kontrol et: `where hipcc`
- CPU-only versiyonu dene
- Settings'de GPU Layers = 0 yap

**Detaylı bilgi:** BUILD_INSTRUCTIONS.md

---

## Hızlı Başlangıç

```
1. setup_dependencies.bat   ← DLL'leri hazırla
2. Delphi 12'de aç ve derle
3. LocalModelRunner.exe çalıştır
4. Model ekle ve chat et!
```

**Hepsi bu kadar!**

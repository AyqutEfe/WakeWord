# Audio Assets

Bu klasör Porcupine wake word ve model dosyalarını içerir.

## Gerekli Dosyalar

### 1. Wake Word Modeli
- **Dosya Adı**: `hey_translator_ppn.ppn`
- **Kaynak**: Picovoice Console - Wake Words bölümü
- **Açıklama**: "hey translator" wake word'ü için model dosyası

### 2. Porcupine Modeli
- **Dosya Adı**: `porcupine_params.pv`
- **Kaynak**: Picovoice Console - Models bölümü
- **Açıklama**: Porcupine engine için model dosyası

## Kurulum Adımları

1. **Picovoice Console'a gidin**: https://console.picovoice.ai/
2. **Wake Word oluşturun**: "hey translator" wake word'ü oluşturun
3. **Modeli indirin**: Wake word modelini indirin ve `hey_translator_ppn.ppn` olarak kaydedin
4. **Porcupine modelini indirin**: Porcupine modelini indirin ve `porcupine_params.pv` olarak kaydedin

## Notlar

- Bu dosyalar büyük boyutlu olabilir
- Model dosyalarını version control'e eklemeyin
- Production'da bu dosyaları CDN'den yükleyin



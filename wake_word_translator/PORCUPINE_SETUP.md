# Porcupine Wake Word Kurulum Rehberi

Bu rehber, Wake Word Translator uygulamasında Porcupine wake word algılama özelliğini aktif hale getirmek için gereken adımları açıklar.

## 🎯 Özellik

Porcupine entegrasyonu ile uygulama "hey translator" wake word'ünü algılayabilir ve otomatik olarak çeviri moduna geçebilir.

**✅ Not**: Porcupine wake word entegrasyonu aktif ve çalışır durumda.

## 📋 Gereksinimler

1. **Picovoice Console Hesabı**: https://console.picovoice.ai/
2. **Access Key**: Picovoice Console'dan alınacak
3. **Wake Word Modeli**: "hey translator" wake word'ü için model dosyası
4. **Porcupine Modeli**: Porcupine engine için model dosyası

## 🔧 Kurulum Adımları

### 1. Picovoice Console'a Kayıt Olun

1. [Picovoice Console](https://console.picovoice.ai/) adresine gidin
2. Ücretsiz hesap oluşturun
3. E-posta doğrulamasını tamamlayın

### 2. Access Key Alın

1. Console'da **Access Keys** bölümüne gidin
2. **Create New Access Key** butonuna tıklayın
3. Key'e bir isim verin (örn: "Wake Word Translator")
4. **Create** butonuna tıklayın
5. Access key'i kopyalayın ve güvenli bir yerde saklayın

### 3. Wake Word Oluşturun

1. Console'da **Wake Words** bölümüne gidin
2. **Create New Wake Word** butonuna tıklayın
3. **Wake Word Name**: "hey translator"
4. **Language**: English
5. **Platform**: Android/iOS (her ikisi için ayrı ayrı oluşturun)
6. **Create** butonuna tıklayın
7. Model dosyasını indirin

### 4. Porcupine Modelini İndirin

1. Console'da **Models** bölümüne gidin
2. **Porcupine** modelini seçin
3. Platform'unuza uygun modeli indirin (Android/iOS)

### 5. Dosyaları Yerleştirin

1. İndirdiğiniz wake word modelini `assets/audio/hey-translator_en_android_v3_0_0.ppn` olarak kaydedin
2. İndirdiğiniz Porcupine modelini `assets/audio/porcupine_params.pv` olarak kaydedin

### 6. Access Key'i Ayarlayın

1. `lib/services/translation_service.dart` dosyasını açın
2. `_accessKey` değişkenini bulun:
   ```dart
   static const String _accessKey = 'YOUR_PICOVOICE_ACCESS_KEY';
   ```
3. `YOUR_PICOVOICE_ACCESS_KEY` yerine kendi access key'inizi yazın:
   ```dart
   static const String _accessKey = 'your_actual_access_key_here';
   ```

### 7. Uygulamayı Test Edin

1. Uygulamayı çalıştırın: `flutter run`
2. Konsol çıktısını kontrol edin:
   - ✅ Porcupine başarıyla başlatıldı
   - 🎯 Wake word dinlemeye hazır: "hey translator"
   - ⚠️ Picovoice Access Key ayarlanmamış! (eğer key ayarlanmamışsa)

## 🎮 Kullanım

### Wake Word Modu (Porcupine Aktif)
1. Uygulamayı açın
2. "hey translator" diyerek wake word'ü tetikleyin
3. Uygulama otomatik olarak konuşma tanımaya başlayacak
4. Konuşun ve çeviriyi dinleyin

**✅ Not**: Bu özellik aktif ve çalışır durumda.

### Manuel Mod (Porcupine Devre Dışı)
1. Uygulamayı açın
2. Mikrofon butonuna basın
3. Konuşun ve çeviriyi dinleyin

## 🔍 Sorun Giderme

### Wake Word Algılanmıyor
- Mikrofon izinlerini kontrol edin
- Access key'in doğru olduğundan emin olun
- Wake word modelinin doğru konumda olduğunu kontrol edin
- Konsol çıktısında hata mesajlarını kontrol edin

### Porcupine Başlatılamıyor
- Access key'in geçerli olduğundan emin olun
- Model dosyalarının doğru konumda olduğunu kontrol edin
- İnternet bağlantısını kontrol edin

### Dosya Bulunamadı Hatası
- `assets/audio/` klasöründe dosyaların var olduğunu kontrol edin
- Dosya isimlerinin doğru olduğunu kontrol edin
- `pubspec.yaml` dosyasında assets tanımlarını kontrol edin

## 📱 Platform Notları

### Android
- Wake word algılama arka planda çalışabilir
- Pil optimizasyonu ayarlarını kontrol edin
- Mikrofon izinlerini yeniden verin

### iOS
- Arka plan ses işleme sınırlıdır
- Uygulama aktif olmalıdır
- Konuşma tanıma izinlerini kontrol edin

## 🆘 Destek

Sorun yaşıyorsanız:
1. Konsol çıktısını kontrol edin
2. Picovoice Console'da model durumunu kontrol edin
3. Access key'in geçerliliğini kontrol edin
4. Dosya yollarını kontrol edin

## 📄 Lisans

Porcupine, Picovoice tarafından geliştirilmiştir ve ticari kullanım için lisans gerektirir. Detaylar için: https://picovoice.ai/

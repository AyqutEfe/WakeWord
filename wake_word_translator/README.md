# Wake Word Translator

Cross-platform Flutter uygulaması ile wake word algılama, ses tanıma, çeviri ve metin-ses dönüşümü özelliklerini içeren modern bir çeviri uygulaması.

## 🚀 Özellikler

- **🗣️ Wake Word Algılama**: Porcupine ile "hey translator" wake word'ü algılama
- **🎧 Ses Tanıma**: speech_to_text paketi ile konuşma tanıma
- **🌍 Çeviri**: Google Translate API ile gerçek zamanlı çeviri
- **🔊 Metin-Ses Dönüşümü**: flutter_tts ile çevrilen metni seslendirme
- **🎨 Modern UI**: Dark theme ile şık ve kullanıcı dostu arayüz
- **📱 Cross-Platform**: Android ve iOS desteği

## 🛠️ Teknoloji Stack

- **Flutter**: Cross-platform mobil geliştirme
- **Porcupine**: Wake word algılama
- **speech_to_text**: Konuşma tanıma
- **translator**: Google Translate entegrasyonu
- **flutter_tts**: Metin-ses dönüşümü
- **provider**: State management
- **permission_handler**: İzin yönetimi

## 📋 Gereksinimler

- Flutter SDK (3.8.1 veya üzeri)
- Dart SDK
- Android Studio / Xcode
- Picovoice Console hesabı (Porcupine için)

## 🔧 Kurulum

1. **Projeyi klonlayın:**
   ```bash
   git clone <repository-url>
   cd wake_word_translator
   ```

2. **Bağımlılıkları yükleyin:**
   ```bash
   flutter pub get
   ```

3. **Porcupine Wake Word Kurulumu:**
   - Detaylı kurulum rehberi için `PORCUPINE_SETUP.md` dosyasını inceleyin
   - [Picovoice Console](https://console.picovoice.ai/) adresinden ücretsiz hesap oluşturun
   - Access key alın ve `lib/services/translation_service.dart` dosyasında ayarlayın
   - Wake word ve Porcupine model dosyalarını `assets/audio/` klasörüne yerleştirin

5. **Uygulamayı çalıştırın:**
   ```bash
   flutter run
   ```

## 📱 Kullanım

### Wake Word Modu (Porcupine Aktif)
1. **Uygulamayı açın** ve gerekli izinleri verin
2. **Dil seçimi yapın** (varsayılan: İngilizce → Türkçe)
3. **"hey translator" diyerek wake word'ü tetikleyin**
4. **Konuşun** - uygulama otomatik olarak sesinizi algılayacak
5. **Çeviriyi dinleyin** - sonuç otomatik olarak seslendirilecek

### Manuel Mod (Porcupine Devre Dışı)
1. **Uygulamayı açın** ve gerekli izinleri verin
2. **Dil seçimi yapın** (varsayılan: İngilizce → Türkçe)
3. **Mikrofon butonuna basın**
4. **Konuşun** - uygulama otomatik olarak sesinizi algılayacak
5. **Çeviriyi dinleyin** - sonuç otomatik olarak seslendirilecek

## 🔧 Yapılandırma

### Dil Ayarları
- Kaynak ve hedef dil seçimi
- Dil değiştirme özelliği
- Desteklenen diller: İngilizce, Türkçe, İspanyolca, Fransızca, Almanca, İtalyanca, Portekizce, Rusça, Japonca, Korece, Çince, Arapça

### Wake Word Özelleştirme
- Picovoice Console'da kendi wake word'ünüzü oluşturabilirsiniz
- Farklı dillerde wake word desteği

## 📁 Proje Yapısı

```
lib/
├── main.dart                 # Ana uygulama girişi
├── services/
│   └── translation_service.dart  # Ana servis sınıfı
├── screens/
│   └── home_screen.dart      # Ana ekran
└── widgets/
    ├── mic_button.dart       # Mikrofon butonu
    ├── translation_card.dart # Çeviri kartı
    └── language_selector.dart # Dil seçici
```

## 🔒 İzinler

### Android
- `RECORD_AUDIO`: Mikrofon erişimi
- `INTERNET`: Çeviri servisi için
- `ACCESS_NETWORK_STATE`: Ağ durumu kontrolü
- `WAKE_LOCK`: Arka plan işlemleri için
- `FOREGROUND_SERVICE`: Arka plan servisleri için

### iOS
- `NSMicrophoneUsageDescription`: Mikrofon kullanım açıklaması
- `NSSpeechRecognitionUsageDescription`: Konuşma tanıma açıklaması
- `UIBackgroundModes`: Arka plan modları

## 🐛 Sorun Giderme

### Wake Word Algılanmıyor
- Mikrofon izinlerini kontrol edin
- Picovoice Access Key'in doğru olduğundan emin olun
- Wake word modelinin doğru konumda olduğunu kontrol edin
- Konsol çıktısında Porcupine durumunu kontrol edin
- Detaylı kurulum için `PORCUPINE_SETUP.md` dosyasını inceleyin

### Çeviri Çalışmıyor
- İnternet bağlantısını kontrol edin
- Google Translate API limitlerini kontrol edin

### Ses Tanıma Sorunları
- Mikrofon izinlerini yeniden verin
- Cihazın mikrofonunun çalıştığından emin olun

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add amazing feature'`)
4. Push yapın (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## 🙏 Teşekkürler

- [Picovoice](https://picovoice.ai/) - Porcupine wake word engine
- [Google Translate](https://translate.google.com/) - Çeviri servisi
- [Flutter](https://flutter.dev/) - Cross-platform framework

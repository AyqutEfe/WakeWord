import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

enum AppState {
  idle,
  listeningForWakeWord,
  listeningForSpeech,
  translating,
  speaking,
  error,
}

class TranslationService extends ChangeNotifier {
  // Porcupine wake word detection
  PorcupineManager? _porcupineManager;
  bool _isWakeWordListening = false;
  
  // Speech recognition
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  
  // Translation
  final translator = GoogleTranslator();
  
  // Text to speech
  final FlutterTts _flutterTts = FlutterTts();
  
  // App state
  AppState _currentState = AppState.idle;
  String _originalText = '';
  String _translatedText = '';
  String _errorMessage = '';
  
  // Language settings
  String _sourceLanguage = 'en';
  String _targetLanguage = 'tr';
  
  // Porcupine configuration
  static String get _accessKey => dotenv.env['PICOVOICE_ACCESS_KEY'] ?? '';
  static const String _wakeWordPath = 'assets/audio/hey-translator_en_android_v3_0_0.ppn';
  static const String _modelPath = 'assets/audio/porcupine_params.pv';
  
  // Getters
  AppState get currentState => _currentState;
  String get originalText => _originalText;
  String get translatedText => _translatedText;
  String get errorMessage => _errorMessage;
  String get sourceLanguage => _sourceLanguage;
  String get targetLanguage => _targetLanguage;
  bool get isWakeWordListening => _isWakeWordListening;
  bool get speechEnabled => _speechEnabled;
  
  TranslationService() {
    _initializeServices();
  }
  
  Future<void> _initializeServices() async {
    try {
      // Request permissions
      await _requestPermissions();
      
      // Initialize speech recognition
      _speechEnabled = await _speechToText.initialize(
        onError: (error) => _handleSpeechError(error),
        onStatus: (status) => _handleSpeechStatus(status),
      );
      
      // Initialize TTS
      await _flutterTts.setLanguage(_targetLanguage);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      // Initialize Porcupine
      await _initializePorcupine();
      
      _setState(AppState.idle);
    } catch (e) {
      _setError('Servis başlatma hatası: $e');
    }
  }
  
  Future<void> _requestPermissions() async {
    // Request microphone permission
    final microphoneStatus = await Permission.microphone.request();
    if (microphoneStatus != PermissionStatus.granted) {
      throw Exception('Mikrofon izni gerekli');
    }
    
    // Request speech recognition permission on iOS
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final speechStatus = await Permission.speech.request();
      if (speechStatus != PermissionStatus.granted) {
        throw Exception('Konuşma tanıma izni gerekli');
      }
    }
  }
  
  Future<void> _initializePorcupine() async {
    try {
      // Access key kontrolü
      if (_accessKey.isEmpty || _accessKey == 'YOUR_PICOVOICE_ACCESS_KEY') {
        debugPrint('⚠️ Picovoice Access Key ayarlanmamış! Manuel mod aktif.');
        debugPrint('📝 Access Key almak için: https://console.picovoice.ai/');
        debugPrint('📝 .env dosyasına PICOVOICE_ACCESS_KEY=your_key_here ekleyin');
        return;
      }
      
      // Dosya varlığını kontrol et (assets için bu kontrol gerekli değil, ancak bırakıyorum)
      debugPrint('🔄 Porcupine başlatılıyor...');
      
      // Güncel API kullanımı
      _porcupineManager = await PorcupineManager.fromKeywordPaths(
        _accessKey,
        [_wakeWordPath], // keyword paths
        _onWakeWordDetected, // wakeWordCallback
        modelPath: _modelPath,
        errorCallback: _onPorcupineError,
      );
      
      debugPrint('✅ Porcupine başarıyla başlatıldı');
      debugPrint('🎯 Wake word dinlemeye hazır: "hey translator"');
    } catch (e) {
      debugPrint('❌ Porcupine başlatılamadı: $e');
      debugPrint('📝 Manuel mod aktif - mikrofon butonuna basarak kullanabilirsiniz');
    }
  }
  
  void _onWakeWordDetected(int keywordIndex) {
    debugPrint('🎯 Wake word algılandı! (Keyword Index: $keywordIndex)');
    _startSpeechRecognition();
  }
  
  void _onPorcupineError(PorcupineException error) {
    debugPrint('❌ Porcupine hatası: $error');
    _setError('Wake word hatası: $error');
  }
  
  Future<void> startListening() async {
    if (_currentState != AppState.idle) return;
    
    try {
      if (_porcupineManager != null) {
        await _porcupineManager!.start();
        _isWakeWordListening = true;
        _setState(AppState.listeningForWakeWord);
        debugPrint('🎧 Wake word dinleme başlatıldı');
      } else {
        // Manuel mod - direkt ses tanımaya başla
        debugPrint('🎤 Manuel mod - direkt ses tanıma başlatılıyor');
        _startSpeechRecognition();
      }
    } catch (e) {
      _setError('Dinleme başlatma hatası: $e');
    }
  }
  
  Future<void> stopListening() async {
    try {
      if (_isWakeWordListening && _porcupineManager != null) {
        await _porcupineManager!.stop();
        _isWakeWordListening = false;
        debugPrint('🛑 Wake word dinleme durduruldu');
      }
      
      if (_speechToText.isListening) {
        await _speechToText.stop();
        debugPrint('🛑 Konuşma tanıma durduruldu');
      }
      
      _setState(AppState.idle);
    } catch (e) {
      _setError('Dinleme durdurma hatası: $e');
    }
  }
  
  Future<void> _startSpeechRecognition() async {
    if (!_speechEnabled) {
      _setError('Konuşma tanıma etkin değil');
      return;
    }
    
    try {
      _setState(AppState.listeningForSpeech);
      
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        localeId: _sourceLanguage,
      );
    } catch (e) {
      _setError('Konuşma tanıma hatası: $e');
    }
  }
  
  void _onSpeechResult(dynamic result) {
    if (result.finalResult) {
      _originalText = result.recognizedWords;
      _translateText(_originalText);
    }
  }
  
  void _handleSpeechError(dynamic error) {
    _setError('Konuşma tanıma hatası: ${error.errorMsg}');
  }
  
  void _handleSpeechStatus(String status) {
    debugPrint('Konuşma durumu: $status');
    if (status == 'done' || status == 'notListening') {
      if (_currentState == AppState.listeningForSpeech && _originalText.isEmpty) {
        _setState(AppState.idle);
      }
    }
  }
  
  Future<void> _translateText(String text) async {
    if (text.isEmpty) return;
    
    try {
      _setState(AppState.translating);
      
      final translation = await translator.translate(
        text,
        from: _sourceLanguage,
        to: _targetLanguage,
      );
      
      _translatedText = translation.text;
      _speakTranslatedText(_translatedText);
    } catch (e) {
      _setError('Çeviri hatası: $e');
    }
  }
  
  Future<void> _speakTranslatedText(String text) async {
    try {
      _setState(AppState.speaking);
      
      await _flutterTts.speak(text);
      
      // Konuşma bittikten sonra idle durumuna geç
      Timer(const Duration(seconds: 2), () {
        if (_currentState == AppState.speaking) {
          _setState(AppState.idle);
        }
      });
    } catch (e) {
      _setError('TTS hatası: $e');
    }
  }
  
  void switchLanguages() {
    final temp = _sourceLanguage;
    _sourceLanguage = _targetLanguage;
    _targetLanguage = temp;
    notifyListeners();
  }
  
  void setSourceLanguage(String language) {
    _sourceLanguage = language;
    notifyListeners();
  }
  
  Future<void> setTargetLanguage(String language) async {
    _targetLanguage = language;
    await _flutterTts.setLanguage(language);
    notifyListeners();
  }
  
  void _setState(AppState state) {
    _currentState = state;
    _errorMessage = '';
    notifyListeners();
  }
  
  void _setError(String error) {
    _currentState = AppState.error;
    _errorMessage = error;
    notifyListeners();
  }
  
  void clearError() {
    if (_currentState == AppState.error) {
      _setState(AppState.idle);
    }
  }
  
  @override
  void dispose() {
    // PorcupineManager'ın delete metodu var, dispose değil
    _porcupineManager?.delete();
    super.dispose();
  }
}
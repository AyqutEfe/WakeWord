import 'dart:async';
import 'package:flutter/foundation.dart';
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
  
  // Getters
  AppState get currentState => _currentState;
  String get originalText => _originalText;
  String get translatedText => _translatedText;
  String get errorMessage => _errorMessage;
  String get sourceLanguage => _sourceLanguage;
  String get targetLanguage => _targetLanguage;
  bool get speechEnabled => _speechEnabled;
  
  TranslationService() {
    _initializeServices();
  }
  
  Future<void> _initializeServices() async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        _setError('Mikrofon izni gerekli');
        return;
      }
      
      // Initialize speech recognition
      _speechEnabled = await _speechToText.initialize(
        onError: (error) => _handleSpeechError(error),
        onStatus: (status) => _handleSpeechStatus(status),
      );
      
      if (!_speechEnabled) {
        _setError('Konuşma tanıma başlatılamadı');
        return;
      }
      
      // Initialize TTS
      await _flutterTts.setLanguage(_targetLanguage);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      // TTS completion callback
      _flutterTts.setCompletionHandler(() {
        if (_currentState == AppState.speaking) {
          _setState(AppState.idle);
        }
      });
      
      _setState(AppState.idle);
      debugPrint('✅ Translation Service başarıyla başlatıldı');
    } catch (e) {
      _setError('Servis başlatma hatası: $e');
    }
  }
  
  Future<void> startListening() async {
    if (_currentState != AppState.idle || !_speechEnabled) {
      if (!_speechEnabled) {
        _setError('Konuşma tanıma etkin değil');
      }
      return;
    }
    
    try {
      _setState(AppState.listeningForSpeech);
      _originalText = '';
      _translatedText = '';
      
      debugPrint('🎤 Konuşma tanıma başlatılıyor...');
      
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 2),
        localeId: _sourceLanguage,
        partialResults: true,
        listenMode: ListenMode.confirmation,
      );
      
    } catch (e) {
      _setError('Konuşma tanıma başlatma hatası: $e');
    }
  }
  
  Future<void> stopListening() async {
    try {
      if (_speechToText.isListening) {
        await _speechToText.stop();
        debugPrint('🛑 Konuşma tanıma durduruldu');
      }
      
      if (_currentState == AppState.listeningForSpeech) {
        _setState(AppState.idle);
      }
    } catch (e) {
      _setError('Dinleme durdurma hatası: $e');
    }
  }
  
  void _onSpeechResult(dynamic result) {
    debugPrint('🎯 Konuşma sonucu: ${result.recognizedWords}');
    
    if (result.recognizedWords.isNotEmpty) {
      _originalText = result.recognizedWords;
      notifyListeners();
      
      // Final result geldiğinde çeviri yap
      if (result.finalResult) {
        debugPrint('✅ Final sonuç: $_originalText');
        _translateText(_originalText);
      }
    }
  }
  
  void _handleSpeechError(dynamic error) {
    debugPrint('❌ Konuşma hatası: ${error.errorMsg}');
    _setError('Konuşma tanıma hatası: ${error.errorMsg}');
  }
  
  void _handleSpeechStatus(String status) {
    debugPrint('📊 Konuşma durumu: $status');
    
    if (status == 'done' || status == 'notListening') {
      if (_currentState == AppState.listeningForSpeech) {
        if (_originalText.isEmpty) {
          _setError('Hiçbir konuşma algılanmadı');
        } else {
          _setState(AppState.idle);
        }
      }
    }
  }
  
  Future<void> _translateText(String text) async {
    if (text.isEmpty) return;
    
    try {
      _setState(AppState.translating);
      debugPrint('🔄 Çeviri başlatılıyor: $text');
      
      final translation = await translator.translate(
        text,
        from: _sourceLanguage,
        to: _targetLanguage,
      );
      
      _translatedText = translation.text;
      debugPrint('✅ Çeviri tamamlandı: $_translatedText');
      notifyListeners();
      
      // Çeviriyi seslendir
      await _speakTranslatedText(_translatedText);
      
    } catch (e) {
      debugPrint('❌ Çeviri hatası: $e');
      _setError('Çeviri hatası: $e');
    }
  }
  
  Future<void> _speakTranslatedText(String text) async {
    if (text.isEmpty) return;
    
    try {
      _setState(AppState.speaking);
      debugPrint('🔊 TTS başlatılıyor: $text');
      
      // Dili ayarla
      await _flutterTts.setLanguage(_targetLanguage);
      
      // Metni seslendir
      final result = await _flutterTts.speak(text);
      
      if (result == 1) {
        debugPrint('✅ TTS başarıyla başlatıldı');
      } else {
        debugPrint('❌ TTS başlatılamadı');
        _setState(AppState.idle);
      }
      
    } catch (e) {
      debugPrint('❌ TTS hatası: $e');
      _setError('TTS hatası: $e');
    }
  }
  
  // Manual TTS for translation replay
  Future<void> speakTranslation() async {
    if (_translatedText.isNotEmpty && _currentState == AppState.idle) {
      await _speakTranslatedText(_translatedText);
    }
  }
  
  void switchLanguages() {
    final temp = _sourceLanguage;
    _sourceLanguage = _targetLanguage;
    _targetLanguage = temp;
    
    // TTS dilini güncelle
    _flutterTts.setLanguage(_targetLanguage);
    
    debugPrint('🔄 Diller değiştirildi: $_sourceLanguage → $_targetLanguage');
    notifyListeners();
  }
  
  void setSourceLanguage(String language) {
    _sourceLanguage = language;
    debugPrint('📝 Kaynak dil: $language');
    notifyListeners();
  }
  
  Future<void> setTargetLanguage(String language) async {
    _targetLanguage = language;
    await _flutterTts.setLanguage(language);
    debugPrint('📝 Hedef dil: $language');
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
}
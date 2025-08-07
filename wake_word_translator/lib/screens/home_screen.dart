import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/translation_service.dart';
import '../widgets/mic_button.dart';
import '../widgets/translation_card.dart';
import '../widgets/language_selector.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wake Word Translator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Settings screen
            },
          ),
        ],
      ),
      body: Consumer<TranslationService>(
        builder: (context, service, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E1E1E),
                  Color(0xFF121212),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Language selector
                  const LanguageSelector(),
                  
                  // Main content area
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Status indicator
                          _buildStatusIndicator(service),
                          
                          const SizedBox(height: 40),
                          
                          // Translation cards
                          if (service.originalText.isNotEmpty || service.translatedText.isNotEmpty)
                            TranslationCard(
                              originalText: service.originalText,
                              translatedText: service.translatedText,
                              sourceLanguage: service.sourceLanguage,
                              targetLanguage: service.targetLanguage,
                            ),
                          
                          const Spacer(),
                          
                          // Error message
                          if (service.currentState == AppState.error)
                            _buildErrorMessage(service),
                          
                          // Mic button
                          MicButton(
                            onPressed: () {
                              if (service.currentState == AppState.idle) {
                                service.startListening();
                              } else {
                                service.stopListening();
                              }
                            },
                            isListening: service.currentState == AppState.listeningForWakeWord ||
                                        service.currentState == AppState.listeningForSpeech,
                            isProcessing: service.currentState == AppState.translating ||
                                         service.currentState == AppState.speaking,
                          ),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildStatusIndicator(TranslationService service) {
    String statusText = '';
    IconData statusIcon = Icons.mic_off;
    Color statusColor = Colors.grey;
    
    switch (service.currentState) {
      case AppState.idle:
        statusText = 'Dinlemeye hazır';
        statusIcon = Icons.mic_off;
        statusColor = Colors.grey;
        break;
      case AppState.listeningForWakeWord:
        statusText = 'Wake word dinleniyor...';
        statusIcon = Icons.hearing;
        statusColor = Colors.blue;
        break;
      case AppState.listeningForSpeech:
        statusText = 'Konuşma dinleniyor...';
        statusIcon = Icons.mic;
        statusColor = Colors.green;
        break;
      case AppState.translating:
        statusText = 'Çeviriliyor...';
        statusIcon = Icons.translate;
        statusColor = Colors.orange;
        break;
      case AppState.speaking:
        statusText = 'Konuşuluyor...';
        statusIcon = Icons.volume_up;
        statusColor = Colors.purple;
        break;
      case AppState.error:
        statusText = 'Hata oluştu';
        statusIcon = Icons.error;
        statusColor = Colors.red;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorMessage(TranslationService service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              service.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: service.clearError,
          ),
        ],
      ),
    );
  }
} 
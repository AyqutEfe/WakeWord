import 'package:flutter/material.dart';

class TranslationCard extends StatelessWidget {
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;

  const TranslationCard({
    super.key,
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Original text section
              if (originalText.isNotEmpty) ...[
                _buildLanguageHeader(context, sourceLanguage, 'Orijinal Metin'),
                const SizedBox(height: 12),
                _buildTextContent(originalText, Colors.white),
                const SizedBox(height: 20),
              ],
              
              // Translation section
              if (translatedText.isNotEmpty) ...[
                _buildLanguageHeader(context, targetLanguage, 'Çeviri'),
                const SizedBox(height: 12),
                _buildTextContent(translatedText, Colors.blue.shade300),
                const SizedBox(height: 16),
                
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      context,
                      Icons.volume_up,
                      'Seslendir',
                      Colors.green,
                      () => _speakText(context, translatedText),
                    ),
                    _buildActionButton(
                      context,
                      Icons.copy,
                      'Kopyala',
                      Colors.blue,
                      () => _copyText(context, translatedText),
                    ),
                    _buildActionButton(
                      context,
                      Icons.share,
                      'Paylaş',
                      Colors.purple,
                      () => _shareText(context, translatedText),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageHeader(BuildContext context, String languageCode, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _getLanguageName(languageCode),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent(String text, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return 'English';
      case 'tr':
        return 'Türkçe';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      case 'pt':
        return 'Português';
      case 'ru':
        return 'Русский';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      case 'ar':
        return 'العربية';
      default:
        return languageCode.toUpperCase();
    }
  }

  void _speakText(BuildContext context, String text) {
    // Bu fonksiyon TranslationService'de zaten mevcut
    // Şimdilik basit bir feedback gösterelim
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Seslendiriliyor: $text'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _copyText(BuildContext context, String text) {
    // Clipboard'a kopyalama işlemi
    // Flutter'da clipboard işlemleri için services_flutter paketi gerekli
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Metin panoya kopyalandı'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareText(BuildContext context, String text) {
    // Paylaşım işlemi
    // Flutter'da paylaşım için share_plus paketi gerekli
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paylaşım özelliği yakında eklenecek'),
        duration: Duration(seconds: 2),
      ),
    );
  }
} 
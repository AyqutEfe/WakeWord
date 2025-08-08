import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/translation_service.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationService>(
      builder: (context, service, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Source language
              Expanded(
                child: _buildLanguageCard(
                  context,
                  service.sourceLanguage,
                  'Kaynak Dil',
                  Colors.blue,
                  () => _showLanguagePicker(context, true),
                ),
              ),
              
              // Switch button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: IconButton(
                  onPressed: service.switchLanguages,
                  icon: const Icon(Icons.swap_horiz),
                            style: IconButton.styleFrom(
            backgroundColor: Colors.blue.withValues(alpha: 0.2),
            foregroundColor: Colors.blue,
          ),
                ),
              ),
              
              // Target language
              Expanded(
                child: _buildLanguageCard(
                  context,
                  service.targetLanguage,
                  'Hedef Dil',
                  Colors.green,
                  () => _showLanguagePicker(context, false),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    String languageCode,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getLanguageName(languageCode),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, bool isSource) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _LanguagePickerSheet(isSource: isSource),
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
}

class _LanguagePickerSheet extends StatelessWidget {
  final bool isSource;

  const _LanguagePickerSheet({required this.isSource});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              isSource ? 'Kaynak Dil Seçin' : 'Hedef Dil Seçin',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          
          // Language list
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: _buildLanguageList(context),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<Widget> _buildLanguageList(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English', 'native': 'English'},
      {'code': 'tr', 'name': 'Türkçe', 'native': 'Türkçe'},
      {'code': 'es', 'name': 'Español', 'native': 'Español'},
      {'code': 'fr', 'name': 'Français', 'native': 'Français'},
      {'code': 'de', 'name': 'Deutsch', 'native': 'Deutsch'},
      {'code': 'it', 'name': 'Italiano', 'native': 'Italiano'},
      {'code': 'pt', 'name': 'Português', 'native': 'Português'},
      {'code': 'ru', 'name': 'Русский', 'native': 'Русский'},
      {'code': 'ja', 'name': '日本語', 'native': '日本語'},
      {'code': 'ko', 'name': '한국어', 'native': '한국어'},
      {'code': 'zh', 'name': '中文', 'native': '中文'},
      {'code': 'ar', 'name': 'العربية', 'native': 'العربية'},
    ];

    return languages.map((language) {
      return Consumer<TranslationService>(
        builder: (context, service, child) {
          final isSelected = isSource
              ? service.sourceLanguage == language['code']
              : service.targetLanguage == language['code'];

          return ListTile(
            leading: Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade700,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  language['code']!.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade300,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            title: Text(
              language['name']!,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.white,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              language['native']!,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
            trailing: isSelected
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              if (isSource) {
                service.setSourceLanguage(language['code']!);
              } else {
                service.setTargetLanguage(language['code']!);
              }
              Navigator.pop(context);
            },
          );
        },
      );
    }).toList();
  }
} 
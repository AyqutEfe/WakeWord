import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/translation_service.dart';

class ModernLanguageSelector extends StatelessWidget {
  const ModernLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationService>(
      builder: (context, service, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            children: [
              // Source language
              Expanded(
                child: _buildLanguageCard(
                  context,
                  service.sourceLanguage,
                  'Kaynak',
                  const Color(0xFF6366F1),
                  () => _showLanguagePicker(context, true),
                ),
              ),
              
              // Switch button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: service.switchLanguages,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF8B5CF6),
                          Color(0xFF06B6D4),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ).animate()
                      .scale(duration: 200.ms)
                      .then()
                      .rotate(duration: 300.ms, begin: 0, end: 0.5),
                ),
              ),
              
              // Target language
              Expanded(
                child: _buildLanguageCard(
                  context,
                  service.targetLanguage,
                  'Hedef',
                  const Color(0xFF10B981),
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
    Color accentColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 80,
        borderRadius: 20,
        blur: 20,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withOpacity(0.1),
            accentColor.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withOpacity(0.6),
            accentColor.withOpacity(0.3),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      languageCode.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      _getLanguageName(languageCode),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate()
          .scale(duration: 200.ms, curve: Curves.easeInOut)
          .then()
          .shimmer(duration: 1500.ms, color: accentColor.withOpacity(0.1)),
    );
  }

  void _showLanguagePicker(BuildContext context, bool isSource) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 30,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1A1A1A).withOpacity(0.9),
            const Color(0xFF0A0A0A).withOpacity(0.95),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                isSource ? 'Kaynak Dil Seçin' : 'Hedef Dil Seçin',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            
            // Language list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: _buildLanguageList(context),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    ).animate()
        .slideY(begin: 1, duration: 300.ms, curve: Curves.easeOutCubic)
        .fadeIn(duration: 300.ms);
  }

  List<Widget> _buildLanguageList(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
      {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
      {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
      {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'},
      {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
      {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
      {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
      {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
      {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
      {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    ];

    return languages.asMap().entries.map((entry) {
      final index = entry.key;
      final language = entry.value;
      
      return Consumer<TranslationService>(
        builder: (context, service, child) {
          final isSelected = isSource
              ? service.sourceLanguage == language['code']
              : service.targetLanguage == language['code'];

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: GlassmorphicContainer(
              width: double.infinity,
              height: 70,
              borderRadius: 16,
              blur: 10,
              alignment: Alignment.center,
              border: isSelected ? 2 : 1,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isSelected
                    ? [
                        const Color(0xFF6366F1).withOpacity(0.2),
                        const Color(0xFF8B5CF6).withOpacity(0.1),
                      ]
                    : [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02),
                      ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isSelected
                    ? [
                        const Color(0xFF6366F1).withOpacity(0.8),
                        const Color(0xFF8B5CF6).withOpacity(0.6),
                      ]
                    : [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: Text(
                  language['flag']!,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  language['name']!,
                  style: GoogleFonts.inter(
                    color: isSelected ? const Color(0xFF6366F1) : Colors.white,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  language['code']!.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: isSelected
                    ? Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    : null,
                onTap: () {
                  if (isSource) {
                    service.setSourceLanguage(language['code']!);
                  } else {
                    service.setTargetLanguage(language['code']!);
                  }
                  Navigator.pop(context);
                },
              ),
            ).animate(delay: (index * 50).ms)
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.3, duration: 400.ms),
          );
        },
      );
    }).toList();
  }
}

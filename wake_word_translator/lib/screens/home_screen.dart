import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/translation_service.dart';
import '../widgets/modern_mic_button.dart';
import '../widgets/modern_translation_card.dart';
import '../widgets/modern_language_selector.dart';
import '../widgets/modern_status_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackgroundDecoration(),
        child: SafeArea(
          child: Consumer<TranslationService>(
            builder: (context, service, child) {
              return CustomScrollView(
                slivers: [
                  // Header Section
                  SliverToBoxAdapter(
                    child: _buildHeader(context, service)
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: -0.3, duration: 800.ms),
                  ),
                  
                  // Language Selector
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: const ModernLanguageSelector()
                          .animate(delay: 200.ms)
                          .fadeIn(duration: 800.ms)
                          .slideY(begin: 0.3, duration: 800.ms),
                    ),
                  ),
                  
                  // Translation Card
                  if (service.originalText.isNotEmpty || service.translatedText.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: ModernTranslationCard(
                          originalText: service.originalText,
                          translatedText: service.translatedText,
                          sourceLanguage: service.sourceLanguage,
                          targetLanguage: service.targetLanguage,
                        ).animate(delay: 400.ms)
                            .fadeIn(duration: 800.ms)
                            .slideY(begin: 0.3, duration: 800.ms)
                            .shimmer(duration: 1500.ms),
                      ),
                    ),
                  
                  // Spacer
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 40),
                  ),
                  
                  // Error Message
                  if (service.currentState == AppState.error)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildErrorMessage(service)
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .shake(duration: 800.ms),
                      ),
                    ),
                  
                  // Bottom Section - Mic Button
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ModernMicButton(
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
                        ).animate(delay: 600.ms)
                            .fadeIn(duration: 1000.ms)
                            .scale(begin: const Offset(0.8, 0.8), duration: 1000.ms),
                        
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRRect(
        child: GlassmorphicContainer(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 0,
          blur: 20,
          alignment: Alignment.center,
          border: 0,
          linearGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A1A).withOpacity(0.8),
              const Color(0xFF0A0A0A).withOpacity(0.6),
            ],
          ),
          borderGradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.transparent],
          ),
          child: Container(),
        ),
      ),
      title: Text(
        'Çevirmen',
        style: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          foreground: Paint()
            ..shader = const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
              child: const Icon(
                Icons.settings_rounded,
                color: Colors.white70,
                size: 20,
              ),
            ),
            onPressed: () {
              // TODO: Settings screen
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, TranslationService service) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // App Logo/Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                  Color(0xFF06B6D4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.translate_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Welcome Text
          Text(
            'Konuş ve Çevir',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Mikrofona basın ve konuşun',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Status Indicator
          ModernStatusIndicator(state: service.currentState),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(TranslationService service) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 80,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.red.withOpacity(0.1),
          Colors.red.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.red.withOpacity(0.3),
          Colors.red.withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                service.errorMessage,
                style: GoogleFonts.inter(
                  color: Colors.red.shade300,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.red),
              onPressed: service.clearError,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: RadialGradient(
        center: Alignment.topCenter,
        radius: 1.5,
        colors: [
          Color(0xFF1A1A2E),
          Color(0xFF16213E),
          Color(0xFF0F0F23),
          Color(0xFF0A0A0A),
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
      ),
    );
  }
}
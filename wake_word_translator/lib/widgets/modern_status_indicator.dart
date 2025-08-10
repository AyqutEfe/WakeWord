import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/translation_service.dart';

class ModernStatusIndicator extends StatelessWidget {
  final AppState state;

  const ModernStatusIndicator({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(state);
    
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 30,
      blur: 20,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          statusData.color.withOpacity(0.15),
          statusData.color.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          statusData.color.withOpacity(0.7),
          statusData.color.withOpacity(0.3),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    statusData.color.withOpacity(0.8),
                    statusData.color.withOpacity(0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusData.color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                statusData.icon,
                color: Colors.white,
                size: 20,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2000.ms, color: statusData.color.withOpacity(0.3))
                .then()
                .shake(duration: 1000.ms),
            
            const SizedBox(width: 12),
            
            Expanded(
              child: Text(
                statusData.text,
                style: GoogleFonts.inter(
                  color: statusData.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Animated dots for listening states
            if (state == AppState.listeningForWakeWord || 
                state == AppState.listeningForSpeech ||
                state == AppState.translating)
              _buildAnimatedDots(statusData.color),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDots(Color color) {
    return Row(
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.only(left: index == 0 ? 0 : 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(duration: 600.ms, delay: (index * 200).ms)
            .then()
            .fadeOut(duration: 600.ms);
      }),
    );
  }

  _StatusData _getStatusData(AppState state) {
    switch (state) {
      case AppState.idle:
        return _StatusData(
          text: 'Dinlemeye Hazır',
          icon: Icons.mic_off_rounded,
          color: const Color(0xFF64748B),
        );
      case AppState.listeningForWakeWord:
        return _StatusData(
          text: '"hey translator" bekleniyor',
          icon: Icons.hearing_rounded,
          color: const Color(0xFF6366F1),
        );
      case AppState.listeningForSpeech:
        return _StatusData(
          text: 'Sesinizi dinliyorum',
          icon: Icons.mic_rounded,
          color: const Color(0xFF10B981),
        );
      case AppState.translating:
        return _StatusData(
          text: 'Çeviriyorum',
          icon: Icons.translate_rounded,
          color: const Color(0xFFF59E0B),
        );
      case AppState.speaking:
        return _StatusData(
          text: 'Çeviriyi okuyor',
          icon: Icons.volume_up_rounded,
          color: const Color(0xFF8B5CF6),
        );
      case AppState.error:
        return _StatusData(
          text: 'Bir hata oluştu',
          icon: Icons.error_outline_rounded,
          color: const Color(0xFFEF4444),
        );
    }
  }
}

class _StatusData {
  final String text;
  final IconData icon;
  final Color color;

  _StatusData({
    required this.text,
    required this.icon,
    required this.color,
  });
}

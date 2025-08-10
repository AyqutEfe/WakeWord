import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ModernMicButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isListening;
  final bool isProcessing;

  const ModernMicButton({
    super.key,
    required this.onPressed,
    this.isListening = false,
    this.isProcessing = false,
  });

  @override
  State<ModernMicButton> createState() => _ModernMicButtonState();
}

class _ModernMicButtonState extends State<ModernMicButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _pressController;
  late AnimationController _rippleController;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(ModernMicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _pulseController.repeat();
      _rippleController.repeat();
    } else if (!widget.isListening && oldWidget.isListening) {
      _pulseController.stop();
      _rippleController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pressController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.mediumImpact();
        _pressController.forward();
      },
      onTapUp: (_) {
        _pressController.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _pressController, _rippleController]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Ripple effects for listening state
              if (widget.isListening) ..._buildRippleEffects(),
              
              // Main button
              Transform.scale(
                scale: 1.0 - (_pressController.value * 0.1),
                child: Container(
                  width: 140,
                  height: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glassmorphic background
                      GlassmorphicContainer(
                        width: 140,
                        height: 140,
                        borderRadius: 70,
                        blur: 20,
                        alignment: Alignment.center,
                        border: 3,
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _getGradientColors(),
                        ),
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _getBorderColors(),
                        ),
                        child: Container(),
                      ),
                      
                      // Inner circle
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _getInnerGradientColors(),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _getPrimaryColor().withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: widget.isListening ? 5 : 0,
                            ),
                          ],
                        ),
                        child: _buildIcon(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildRippleEffects() {
    return List.generate(3, (index) {
      final delay = index * 0.3;
      return AnimatedBuilder(
        animation: _rippleController,
        builder: (context, child) {
          final progress = (_rippleController.value + delay) % 1.0;
          return Transform.scale(
            scale: 1.0 + (progress * 1.5),
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getPrimaryColor().withOpacity(0.3 * (1 - progress)),
                  width: 2,
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildIcon() {
    Widget iconWidget;
    
    if (widget.isProcessing) {
      iconWidget = SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
          strokeCap: StrokeCap.round,
        ).animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: 1500.ms),
      );
    } else {
      IconData iconData = widget.isListening 
          ? Icons.mic_rounded 
          : Icons.mic_off_rounded;
      
      iconWidget = Icon(
        iconData,
        size: 36,
        color: Colors.white,
      );
      
      if (widget.isListening) {
        iconWidget = iconWidget
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.1, 1.1),
              duration: 1000.ms,
            )
            .then()
            .scale(
              begin: const Offset(1.1, 1.1),
              end: const Offset(1.0, 1.0),
              duration: 1000.ms,
            );
      }
    }
    
    return Center(child: iconWidget);
  }

  Color _getPrimaryColor() {
    if (widget.isProcessing) return const Color(0xFFF59E0B);
    if (widget.isListening) return const Color(0xFF10B981);
    return const Color(0xFF6366F1);
  }

  List<Color> _getGradientColors() {
    final primaryColor = _getPrimaryColor();
    return [
      primaryColor.withOpacity(0.2),
      primaryColor.withOpacity(0.1),
    ];
  }

  List<Color> _getBorderColors() {
    final primaryColor = _getPrimaryColor();
    return [
      primaryColor.withOpacity(0.8),
      primaryColor.withOpacity(0.4),
    ];
  }

  List<Color> _getInnerGradientColors() {
    final primaryColor = _getPrimaryColor();
    return [
      primaryColor,
      primaryColor.withOpacity(0.8),
    ];
  }
}

import 'package:flutter/material.dart';


class MicButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isListening;
  final bool isProcessing;

  const MicButton({
    super.key,
    required this.onPressed,
    this.isListening = false,
    this.isProcessing = false,
  });

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isListening && oldWidget.isListening) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isListening ? _pulseAnimation.value : _scaleAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isListening
                      ? [Colors.green, Colors.green.shade700]
                      : widget.isProcessing
                          ? [Colors.orange, Colors.orange.shade700]
                          : [Colors.blue, Colors.blue.shade700],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (widget.isListening
                            ? Colors.green
                            : widget.isProcessing
                                ? Colors.orange
                                : Colors.blue)
                        .withValues(alpha: 0.3),
                    blurRadius: widget.isListening ? 20 : 10,
                    spreadRadius: widget.isListening ? 5 : 2,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onPressed,
                  borderRadius: BorderRadius.circular(60),
                  child: Center(
                    child: _buildIcon(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.isProcessing) {
      return const SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      );
    }

    IconData iconData;
    if (widget.isListening) {
      iconData = Icons.mic;
    } else {
      iconData = Icons.mic_off;
    }

    return Icon(
      iconData,
      size: 40,
      color: Colors.white,
    );
  }
} 
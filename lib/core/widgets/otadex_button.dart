import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_spacing.dart';
import '../theme/otadex_theme.dart';
import 'skeleton_loader.dart';

class OtadexButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final double? width;

  const OtadexButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.width,
  });

  @override
  State<OtadexButton> createState() => _OtadexButtonState();
}

class _OtadexButtonState extends State<OtadexButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final isDisabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!widget.isLoading) widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: widget.fullWidth ? double.infinity : widget.width,
            height: AppSpacing.buttonHeight,
            decoration: BoxDecoration(
              color: isDisabled
                  ? theme.accentColor.withValues(alpha: 0.4)
                  : theme.accentColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              boxShadow: isDisabled
                  ? []
                  : [
                      BoxShadow(
                        color: theme.accentGlow,
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Center(
              child: widget.isLoading
                  ? shimmerBox(width: 24, height: 24, radius: 12)
                  : Text(
                      widget.label,
                      style: GoogleFonts.rajdhani(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

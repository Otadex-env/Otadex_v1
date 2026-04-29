import 'package:flutter/material.dart';

class CharCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const CharCircleButton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.35),
        ),
        child: Center(child: child),
      ),
    );
  }
}

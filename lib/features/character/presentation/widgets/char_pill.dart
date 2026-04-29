import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CharPill extends StatelessWidget {
  final String label;
  final Color bg;
  final BoxBorder? border;
  final Color color;
  final double fontSize;

  const CharPill(
    this.label, {
    super.key,
    required this.bg,
    this.border,
    this.color = Colors.white,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: border,
      ),
      child: Text(
        label,
        style: GoogleFonts.nunitoSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

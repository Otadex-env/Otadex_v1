import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CharAICard extends StatelessWidget {
  final Color bg;
  final Color border;
  final Color subtitleColor;
  final String icon;
  final String title;
  final String subtitle;

  const CharAICard({
    super.key,
    required this.bg,
    required this.border,
    required this.subtitleColor,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 76),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          const Positioned(
            top: 0,
            right: 0,
            child: Text('🔒', style: TextStyle(fontSize: 12)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 2),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(fontSize: 10, color: subtitleColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

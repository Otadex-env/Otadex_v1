import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === COULEURS PRINCIPALES ===
  static const Color primary = Color(0xFF5C2BE2);
  static const Color primaryLight = Color(0xFF7B52E8);
  static const Color primaryDark = Color(0xFF3D1BB5);

  // === ACCENT OTADEX — Extrait du logo officiel ===
  static const Color accent = Color(0xFFFF6500);
  static const Color accentBright = Color(0xFFFF8C00);
  static const Color accentCopper = Color(0xFFC4601A);
  static const Color accentLight = Color(0xFFFF8533);
  static const Color accentGlow = Color(0x40FF6500);

  // === BACKGROUNDS ===
  static const Color backgroundDeep = Color(0xFF0D0D14);
  static const Color backgroundCard = Color(0xFF1A1A2E);
  static const Color backgroundMetal = Color(0xFF1A2A4A);
  static const Color backgroundElevated = Color(0xFF12172A);
  static const Color backgroundInput = Color(0xFF1A1A2E);

  // === BORDERS ===
  static const Color borderDefault = Color(0xFF3D2B8A);
  static const Color borderActive = Color(0xFFFF6500);
  static const Color borderSubtle = Color(0xFF252540);
  static const Color borderMetal = Color(0xFF1A2A4A);

  // === TEXTE ===
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0C0);
  static const Color textDisabled = Color(0xFF4A4A6A);
  static const Color textLink = Color(0xFFFF6500);
  static const Color textCopper = Color(0xFFC4601A);

  // === RANGS ===
  static const Color rankGenin = Color(0xFF7EABC9);
  static const Color rankGeninBg = Color(0xFF12202E);
  static const Color rankJonin = Color(0xFF9B59B6);
  static const Color rankJoninBg = Color(0xFF1E1535);
  static const Color rankKage = Color(0xFFFF6500);
  static const Color rankKageBg = Color(0xFF2D1500);

  // === STATUS ===
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // === OVERLAY & EFFETS ===
  static const Color overlay = Color(0x80000000);
  static const Color shimmerKage = Color(0x40FF6500);
  static const Color glowAccent = Color(0x33FF6500);
  static const Color glowPrimary = Color(0x335C2BE2);

  // === CARD OVERLAYS (cinema scrim) ===
  static const Color cardShadowLight = Color(0x20000000);
  static const Color cardShadowMid = Color(0x28000000);
  static const Color cardShadowBottom = Color(0xCC000000);
  static const Color cardShadowDeep = Color(0xD8000000);

  // === GLOW VARIANTS ===
  static const Color accentGlowFaint = Color(0x18FF6500);
  static const Color accentGlowStrong = Color(0x50FF6500);

  // === STAT & DATA VIZ ===
  static const Color statBlue = Color(0xFF3B82F6);
  static const Color statBluePastel = Color(0xFF93C5FD);
  static const Color statPurple = Color(0xFF8B5CF6);
  static const Color statPurplePastel = Color(0xFFC4B5FD);
  static const Color statGreen = Color(0xFF10B981);
  static const Color statGreenPastel = Color(0xFF6EE7B7);
  static const Color errorPastel = Color(0xFFFCA5A5);

  // === INTERACTION ===
  static const Color starYellow = Color(0xFFFFC107);
  static const Color heartPink = Color(0xFFFF4D6D);
  static const Color gradientOrange = Color(0xFFFF6D1B);

  // === TEXTE ADDITIONNEL ===
  static const Color textMuted = Color(0xFF5A5A6A);

  // === BACKGROUNDS ADDITIONNELS ===
  static const Color backgroundAIBlue = Color(0xFF151520);
  static const Color backgroundAIPurple = Color(0xFF120A1E);
  static const Color rankKageBgElevated = Color(0xFF3D1500);

  // === ANIME CARD & ACCENT THEMES ===
  static const Color animeJjkCard = Color(0xFF0A1520);
  static const Color animeJjkAccent = Color(0xFF1565C0);
  static const Color animeNsCard = Color(0xFF0D1A0A);
  static const Color animeNsAccent = Color(0xFFFF6F00);
  static const Color animeAotCard = Color(0xFF1A0A0A);
  static const Color animeAotAccent = Color(0xFFC62828);
  static const Color animeOpCard = Color(0xFF1A1200);
  static const Color animeOpAccent = Color(0xFFFF9800);
  static const Color animeClkCard = Color(0xFF0A1520);
  static const Color animeClkAccent = Color(0xFF00897B);
  static const Color animeDefaultCard = Color(0xFF0A1020);
  static const Color animeDefaultAccent = Color(0xFF6A1B9A);
  static const Color animeFmaCard = Color(0xFF1A0800);
  static const Color animeFmaAccent = Color(0xFFB71C1C);
  static const Color animeHxhCard = Color(0xFF061A06);
  static const Color animeHxhAccent = Color(0xFF2E7D32);

  // === ANIME CARD & ACCENT — EXTENDED ===
  static const Color animeSlCard = Color(0xFF1A0D2E);
  static const Color animeDsAccent = Color(0xFFE53935);
  static const Color animeJjkGreenCard = Color(0xFF0A1A0A);
  static const Color animeJjkGreenAccent = Color(0xFF00C853);
  static const Color animeVsCard = Color(0xFF0D1520);
  static const Color animeAotLeviCard = Color(0xFF0D1A0A);
  static const Color animeSxfCard = Color(0xFF1A1020);
  static const Color animeDarkRedCard = Color(0xFF200A0A);
  static const Color animeDitfCard = Color(0xFF200A10);
  static const Color animeOpZoroCard = Color(0xFF0A200A);
  static const Color animeOpmCard = Color(0xFF1A1000);
  static const Color animeNsItachiCard = Color(0xFF1A0A1A);
  static const Color animeJjkYujiCard = Color(0xFF1A0808);
  static const Color animeOpLuffyCard = Color(0xFF1A0800);
  static const Color animeVsThorfinnCard = Color(0xFF101520);
  static const Color animeFrierenCard = Color(0xFF0A0A1A);

  // === ACCENTS ÉTENDUS ===
  static const Color accentCyan = Color(0xFF00BCD4);
  static const Color accentDeepOrange = Color(0xFFFF5722);
  static const Color accentHotPink = Color(0xFFE91E63);
  static const Color accentForestGreen = Color(0xFF2E7D32);
  static const Color accentGreen = Color(0xFF388E3C);
  static const Color accentBlueGrey = Color(0xFF607D8B);
  static const Color accentIndigo = Color(0xFF5C6BC0);
  static const Color accentSilverBlue = Color(0xFF78909C);
  static const Color accentSteelBlue = Color(0xFF455A64);
  static const Color accentPinkLight = Color(0xFFF06292);
  static const Color accentRoyalBlue = Color(0xFF1976D2);
  static const Color accentDeepPurple = Color(0xFF7B1FA2);
  static const Color accentDarkRed = Color(0xFFB71C1C);
  static const Color accentViolet = Color(0xFF7C3AED);
  static const Color statPurpleDark = Color(0xFF6D28D9);

  // === CATÉGORIES SEARCH ===
  static const Color catShonenC1 = Color(0xFFE67E22);
  static const Color catShonenC2 = Color(0xFF5D1A00);
  static const Color catShojoC1 = Color(0xFFE91E8C);
  static const Color catShojoC2 = Color(0xFF7B0052);
  static const Color catSeinenC1 = Color(0xFF546E7A);
  static const Color catSeinenC2 = Color(0xFF1A2327);
  static const Color catManhwaC1 = Color(0xFF26C6DA);
  static const Color catManhwaC2 = Color(0xFF004D56);
  static const Color catDonghuaC1 = Color(0xFFEF5350);
  static const Color catDonghuaC2 = Color(0xFF5D0000);
  static const Color catWebtoonC1 = Color(0xFF66BB6A);
  static const Color catWebtoonC2 = Color(0xFF1B3A1C);

  // === TRENDING SEARCH BACKGROUNDS ===
  static const Color trendSLBg = Color(0xFF1A237E);
  static const Color trendJJKBg = Color(0xFF4A148C);
  static const Color trendDSBg = Color(0xFF880E4F);
  static const Color trendOPBg = Color(0xFFBF360C);
  static const Color trendAOTBg = Color(0xFF212121);
  static const Color trendFrierenBg = Color(0xFF283593);

  // === AVATAR GRADIENTS ===
  static const Color avatarMelC1 = Color(0xFFD4621A);
  static const Color avatarMelC2 = Color(0xFF8B3510);
  static const Color avatarKiroC2 = Color(0xFF9B1465);
  static const Color avatarYumiC2 = Color(0xFF006064);
  static const Color avatarDravenC1 = Color(0xFF4CAF50);
  static const Color avatarDravenC2 = Color(0xFF1B5E20);
  static const Color avatarNoxC2 = Color(0xFF8B1A00);
}

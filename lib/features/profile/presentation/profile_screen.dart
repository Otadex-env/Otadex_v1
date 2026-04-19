import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/user_rank.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/theme/rank_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;
  bool _notificationsEnabled = true;
  bool _showKageBanner = true;
  String _billingCycle = 'mensuel';

  static const _username = 'Jean-Paul_Otaku';
  static const _bio = 'Fan de Shonen depuis 2010 🏴';
  static const _collectCount = 67;
  static const _fanScore = 3847;
  static const _rankCount = 12;
  static const _progressPct = 0.78;
  static const _currentPts = 3847;
  static const _maxPts = 5000;

  static const _avatarOptions = [
    ('Mel Shard', Color(0xFFD4621A), Color(0xFF8B3510)),
    ('Kiro Blaze', Color(0xFFE91E8C), Color(0xFF9B1465)),
    ('Yumi Frost', Color(0xFF00BCD4), Color(0xFF006064)),
    ('Draven', Color(0xFF4CAF50), Color(0xFF1B5E20)),
    ('Nox Ember', Color(0xFFFF5722), Color(0xFF8B1A00)),
  ];

  static const _collectionItems = [
    ('Ronin Kage', Color(0xFF1565C0), Color(0xFF0D47A1), true),
    ('Sora Ken', Color(0xFF7B1FA2), Color(0xFF4A148C), false),
    ('Akira Void', Color(0xFF00695C), Color(0xFF004D40), false),
    ('Kira Sun', Color(0xFFE65100), Color(0xFFBF360C), false),
    ('Mika Rose', Color(0xFFAD1457), Color(0xFF880E4F), false),
    ('Zeno', Color(0xFF00838F), Color(0xFF006064), false),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final rank = OtadexTheme.rankOf(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileHero(theme, rank),
          const SizedBox(height: 20),
          _buildStatRow(theme),
          const SizedBox(height: 20),
          _buildTabBar(theme),
          _buildTabContent(theme, rank),
          const SizedBox(height: 28),
          _buildAvatarPicker(theme),
          if (_showKageBanner) ...[
            const SizedBox(height: 20),
            _buildKageBanner(theme),
          ],
          const SizedBox(height: 24),
          _buildSubscriptionCard(theme),
          const SizedBox(height: 20),
          _buildPlanToggle(theme),
          const SizedBox(height: 16),
          _buildPlanCards(theme),
          const SizedBox(height: 28),
          _buildSettingsSection(theme, rank),
          const SizedBox(height: 28),
          _buildLogoutButton(theme),
          const SizedBox(height: 16),
          _buildFooter(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ── Profile hero ──────────────────────────────────────────────────

  Widget _buildProfileHero(RankTheme theme, UserRank rank) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.settings_rounded,
              color: theme.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(height: 12),
          // Avatar oval
          Container(
            width: 80,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD4621A), Color(0xFF5A1A00)],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.accentGlow,
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Rank badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: theme.rankBadgeBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.rankBadgeColor.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _rankEmoji(rank),
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 5),
                Text(
                  theme.rankLabel.toUpperCase(),
                  style: GoogleFonts.rajdhani(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: theme.rankBadgeColor,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _username,
            style: GoogleFonts.rajdhani(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _bio,
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              color: theme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _rankEmoji(UserRank rank) => switch (rank) {
        UserRank.genin => '🎯',
        UserRank.jonin => '🦊',
        UserRank.kage => '👑',
      };

  // ── Stats ─────────────────────────────────────────────────────────

  Widget _buildStatRow(RankTheme theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Row(
        children: [
          _buildStat(theme, '$_collectCount', 'Collectés', false),
          _buildStatDivider(theme),
          _buildStat(theme, '$_fanScore', 'Fan Score', true),
          _buildStatDivider(theme),
          _buildStat(theme, '$_rankCount', 'Classements', false),
        ],
      ),
    );
  }

  Widget _buildStat(
    RankTheme theme,
    String value,
    String label,
    bool highlight,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: highlight ? theme.accentColor : theme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.nunitoSans(
              fontSize: 11,
              color: theme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider(RankTheme theme) {
    return Container(width: 1, height: 32, color: theme.borderSubtle);
  }

  // ── Tabs ──────────────────────────────────────────────────────────

  Widget _buildTabBar(RankTheme theme) {
    final tabs = ['Collection', 'Badges', 'Activité'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final i = entry.key;
          final label = entry.value;
          final active = i == _selectedTab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.only(right: 24),
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active ? theme.accentColor : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                label,
                style: GoogleFonts.rajdhani(
                  fontSize: 15,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? theme.accentColor : theme.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(RankTheme theme, UserRank rank) {
    if (_selectedTab == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressCard(theme, rank),
          _buildCollectionHeader(theme),
          _buildCollectionGrid(theme),
        ],
      );
    } else if (_selectedTab == 1) {
      return _buildEmptyTabContent(
        theme,
        'Aucun badge pour l\'instant',
      );
    } else {
      return _buildEmptyTabContent(
        theme,
        'Ton activité récente apparaîtra ici',
      );
    }
  }

  Widget _buildProgressCard(RankTheme theme, UserRank rank) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${theme.rankLabel} Otaku — Niveau 4 🔥',
                style: GoogleFonts.rajdhani(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: theme.textPrimary,
                ),
              ),
              Text(
                '${(_progressPct * 100).toInt()}%',
                style: GoogleFonts.rajdhani(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: theme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _progressPct,
              backgroundColor: theme.borderSubtle,
              valueColor: AlwaysStoppedAnimation(theme.accentColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_currentPts / $_maxPts pts pour Kage Suprême',
            style: GoogleFonts.nunitoSans(
              fontSize: 11,
              color: theme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionHeader(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ma Collection ($_collectCount)',
            style: GoogleFonts.rajdhani(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  color: theme.accentColor,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Gérer',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: theme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionGrid(RankTheme theme) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      mainAxisSpacing: 12,
      crossAxisSpacing: 10,
      childAspectRatio: 0.74,
      children:
          _collectionItems
              .map(
                (item) => _buildCollectionCard(
                  theme,
                  item.$1,
                  item.$2,
                  item.$3,
                  item.$4,
                ),
              )
              .toList(),
    );
  }

  Widget _buildCollectionCard(
    RankTheme theme,
    String name,
    Color c1,
    Color c2,
    bool selected,
  ) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [c1, c2],
              ),
              border:
                  selected
                      ? Border.all(color: theme.accentColor, width: 2)
                      : null,
            ),
            child:
                selected
                    ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: theme.accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 11,
                          ),
                        ),
                      ),
                    )
                    : null,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(
            fontSize: 10,
            color: theme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyTabContent(RankTheme theme, String message) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.nunitoSans(
            fontSize: 13,
            color: theme.textSecondary,
          ),
        ),
      ),
    );
  }

  // ── Avatar picker ─────────────────────────────────────────────────

  Widget _buildAvatarPicker(RankTheme theme) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      mainAxisSpacing: 12,
      crossAxisSpacing: 10,
      childAspectRatio: 0.78,
      children: [
        ..._avatarOptions.map(
          (a) => _buildAvatarOption(theme, a.$1, a.$2, a.$3),
        ),
        _buildAddAvatarButton(theme),
      ],
    );
  }

  Widget _buildAvatarOption(
    RankTheme theme,
    String name,
    Color c1,
    Color c2,
  ) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [c1, c2],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(
            fontSize: 10,
            color: theme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAddAvatarButton(RankTheme theme) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: theme.borderDefault, width: 1.5),
              color: theme.backgroundCard,
            ),
            child: Center(
              child: Icon(
                Icons.add_rounded,
                color: theme.textSecondary,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Ajouter',
          style: GoogleFonts.nunitoSans(
            fontSize: 10,
            color: theme.textSecondary,
          ),
        ),
      ],
    );
  }

  // ── Kage banner ───────────────────────────────────────────────────

  Widget _buildKageBanner(RankTheme theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1535),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF9B59B6).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const Text('⭐', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Passe Kage — IA images + téléchargement propre',
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Voir →',
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF9B59B6),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => setState(() => _showKageBanner = false),
            child: Icon(
              Icons.close_rounded,
              color: theme.textSecondary,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ── Subscription card ─────────────────────────────────────────────

  Widget _buildSubscriptionCard(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paramètres & Abonnement',
            style: GoogleFonts.rajdhani(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.backgroundCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.borderDefault),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'ACTIF',
                            style: GoogleFonts.rajdhani(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF22C55E),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'JONIN 🦊',
                      style: GoogleFonts.rajdhani(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '2 000 FCFA',
                        style: GoogleFonts.rajdhani(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: theme.accentColor,
                        ),
                      ),
                      TextSpan(
                        text: '/mois',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          color: theme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Renouvellement dans 18 jours · 20 mai 2026',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    color: theme.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.borderDefault),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'Gérer l\'abonnement',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 12,
                            color: theme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF4D6D)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'Annuler',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 12,
                            color: const Color(0xFFFF4D6D),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Plan toggle ───────────────────────────────────────────────────

  Widget _buildPlanToggle(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Changer de plan',
            style: GoogleFonts.rajdhani(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.backgroundCard,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPlanToggleOption(theme, 'mensuel', 'Mensuel', null),
                _buildPlanToggleOption(theme, 'annuel', 'Annuel', '-10%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanToggleOption(
    RankTheme theme,
    String value,
    String label,
    String? badge,
  ) {
    final active = _billingCycle == value;
    return GestureDetector(
      onTap: () => setState(() => _billingCycle = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: active ? Colors.black : theme.textSecondary,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF22C55E),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Plan cards ────────────────────────────────────────────────────

  Widget _buildPlanCards(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildPlanCard(
            theme: theme,
            name: 'Genin',
            tag: 'GRATUIT',
            tagColor: theme.textSecondary,
            price: '0 FCFA',
            priceColor: theme.textPrimary,
            features: const [
              (true, 'Fiches & navigation'),
              (true, 'Likes & commentaires'),
              (false, 'Publicités affichées'),
              (false, 'IA désactivée'),
            ],
            buttonLabel: 'Rétrograder',
            buttonEnabled: false,
            borderColor: theme.borderSubtle,
            isCta: false,
          ),
          const SizedBox(height: 12),
          _buildPlanCard(
            theme: theme,
            name: 'Jonin',
            tag: 'PLAN ACTUEL ✓',
            tagColor: const Color(0xFF4A9EFF),
            price: '2 000 FCFA/mois',
            priceColor: const Color(0xFF4A9EFF),
            features: const [
              (true, 'Collection illimitée'),
              (true, 'Sans publicités'),
              (true, 'IA chatbot + quiz'),
              (true, 'Badge Jonin 🦊'),
            ],
            buttonLabel: 'Plan actuel',
            buttonEnabled: false,
            borderColor: const Color(0xFF4A9EFF),
            isCta: false,
          ),
          const SizedBox(height: 12),
          _buildPlanCard(
            theme: theme,
            name: '⭐ Kage Pass',
            tag: null,
            tagColor: const Color(0xFF9B59B6),
            price: '5 000 FCFA/mois',
            priceColor: const Color(0xFF9B59B6),
            features: const [
              (true, 'Tout Jonin inclus'),
              (true, 'Génération images IA ⭐'),
              (true, 'Sans watermark'),
              (true, 'Thèmes exclusifs 👑'),
            ],
            buttonLabel: 'Passer Kage 👑',
            buttonEnabled: true,
            borderColor: const Color(0xFF9B59B6),
            isCta: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required RankTheme theme,
    required String name,
    required String? tag,
    required Color tagColor,
    required String price,
    required Color priceColor,
    required List<(bool, String)> features,
    required String buttonLabel,
    required bool buttonEnabled,
    required Color borderColor,
    required bool isCta,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.rajdhani(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: theme.textPrimary,
                ),
              ),
              if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.rajdhani(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: tagColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: priceColor,
            ),
          ),
          const SizedBox(height: 10),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Text(
                    f.$1 ? '✓' : '✗',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color:
                          f.$1
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFFF4D6D),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    f.$2,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      color: f.$1 ? theme.textPrimary : theme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child:
                isCta
                    ? ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9B59B6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        buttonLabel,
                        style: GoogleFonts.rajdhani(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    )
                    : OutlinedButton(
                      onPressed: buttonEnabled ? () {} : null,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color:
                              buttonEnabled
                                  ? theme.borderDefault
                                  : theme.borderSubtle,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        buttonLabel,
                        style: GoogleFonts.rajdhani(
                          fontSize: 14,
                          fontWeight:
                              buttonEnabled ? FontWeight.w700 : FontWeight.w500,
                          color:
                              buttonEnabled
                                  ? theme.textPrimary
                                  : theme.textSecondary,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // ── Settings ──────────────────────────────────────────────────────

  Widget _buildSettingsSection(RankTheme theme, UserRank rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel(theme, 'COMPTE'),
          const SizedBox(height: 8),
          _buildSettingsCard(theme, [
            _buildRow(theme, '👤', 'Modifier le profil', null, true),
            _buildDivider(theme),
            _buildRow(theme, '🔒', 'Changer le mot de passe', null, true),
            _buildDivider(theme),
            _buildRow(theme, '✉️', 'Email', 'jean@mail.com', true),
          ]),
          const SizedBox(height: 24),
          _buildSectionLabel(theme, 'PRÉFÉRENCES'),
          const SizedBox(height: 8),
          _buildSettingsCard(theme, [
            _buildRow(theme, '🌙', 'Thème', 'Sombre', true),
            _buildDivider(theme),
            _buildToggleRow(theme, '🔔', 'Notifications'),
            _buildDivider(theme),
            _buildRow(theme, '🌐', 'Langue', 'Français', true),
            _buildDivider(theme),
            _buildRow(theme, '🎨', 'Thème Kage', 'Verrouillé 🔒', true),
          ]),
          const SizedBox(height: 24),
          _buildSectionLabel(theme, 'CONTENU'),
          const SizedBox(height: 8),
          _buildSettingsCard(theme, [
            _buildRow(theme, '📋', 'Catégories masquées', '0 masquées', true),
            _buildDivider(theme),
            _buildRow(theme, '📊', 'Mon historique', null, true),
            _buildDivider(theme),
            _buildRow(theme, '🧹', 'Vider le cache', '24 MB', true),
          ]),
          const SizedBox(height: 24),
          _buildSectionLabel(theme, 'À PROPOS'),
          const SizedBox(height: 8),
          _buildSettingsCard(theme, [
            _buildRow(theme, 'ℹ️', 'Version OTADEX', '1.0.0', false),
            _buildDivider(theme),
            _buildRow(
              theme,
              '📄',
              'Conditions d\'utilisation',
              null,
              true,
            ),
            _buildDivider(theme),
            _buildRow(
              theme,
              '🔐',
              'Politique de confidentialité',
              null,
              true,
            ),
            _buildDivider(theme),
            _buildRow(theme, '⭐', 'Noter l\'app', null, true),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(RankTheme theme, String label) {
    return Text(
      label,
      style: GoogleFonts.nunitoSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: theme.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingsCard(RankTheme theme, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRow(
    RankTheme theme,
    String icon,
    String label,
    String? value,
    bool hasArrow,
  ) {
    return InkWell(
      onTap: hasArrow ? () {} : null,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: theme.textPrimary,
                ),
              ),
            ),
            if (value != null) ...[
              Text(
                value,
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  color: theme.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
            ],
            if (hasArrow)
              Icon(
                Icons.chevron_right_rounded,
                color: theme.textSecondary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(RankTheme theme, String icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                color: theme.textPrimary,
              ),
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
            activeThumbColor: Colors.white,
            activeTrackColor: theme.accentColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: theme.borderDefault,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(RankTheme theme) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 44,
      color: theme.borderSubtle,
    );
  }

  // ── Logout + footer ───────────────────────────────────────────────

  Widget _buildLogoutButton(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.borderSubtle),
          backgroundColor: theme.backgroundCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: Text(
          'Se déconnecter',
          style: GoogleFonts.nunitoSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFFF4D6D),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        'OTADEX · v1.0.0',
        style: GoogleFonts.nunitoSans(
          fontSize: 11,
          color: Colors.white.withValues(alpha: 0.3),
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/anilist_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/otadex_image.dart';
import '../../../core/widgets/skeleton_loader.dart';

// ─── Provider ──────────────────────────────────────────────────────────────
final _voiceActorProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>?, String>(
  (ref, staffId) async {
    final service = AniListService();
    final id = int.tryParse(staffId);
    if (id == null) return null;
    return service.getVoiceActorById(id);
  },
);

// ─── Screen ────────────────────────────────────────────────────────────────
class VoiceActorScreen extends ConsumerStatefulWidget {
  final String staffId;

  const VoiceActorScreen({super.key, required this.staffId});

  @override
  ConsumerState<VoiceActorScreen> createState() => _VoiceActorScreenState();
}

class _VoiceActorScreenState extends ConsumerState<VoiceActorScreen> {
  bool _bioExpanded = false;

  // ─── Helpers ─────────────────────────────────────────────────────────────

  String _cleanHtml(String raw) =>
      raw.replaceAll(RegExp(r'<[^>]*>'), '').trim();

  String _languageFlag(String? lang) {
    if (lang == null) return '';
    switch (lang.toLowerCase()) {
      case 'japanese':
        return '🇯🇵 Japonais';
      case 'english':
        return '🇺🇸 Anglais';
      case 'korean':
        return '🇰🇷 Coréen';
      case 'chinese':
        return '🇨🇳 Chinois';
      case 'french':
        return '🇫🇷 Français';
      case 'german':
        return '🇩🇪 Allemand';
      case 'spanish':
        return '🇪🇸 Espagnol';
      case 'italian':
        return '🇮🇹 Italien';
      case 'portuguese':
        return '🇧🇷 Portugais';
      default:
        return lang;
    }
  }

  String _yearsActive(List<dynamic> years) {
    if (years.isEmpty) return '—';
    if (years.length == 1) return '${years[0]}–';
    return '${years[0]}–${years[years.length - 1]}';
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final actorAsync = ref.watch(_voiceActorProvider(widget.staffId));

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: actorAsync.when(
        loading: () => const SkeletonScreen(),
        error: (_, __) => _buildError(),
        data: (actor) {
          if (actor == null) return _buildError();
          return _buildContent(context, actor);
        },
      ),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text(
        'Doubleur introuvable',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> actor) {
    final name = (actor['name'] as Map<String, dynamic>?);
    final fullName = name?['full'] as String? ?? '';
    final nativeName = name?['native'] as String?;
    final image = (actor['image'] as Map<String, dynamic>?);
    final imageUrl = image?['large'] as String?;
    final description = actor['description'] as String?;
    final language = actor['languageV2'] as String?;
    final occupations =
        (actor['primaryOccupations'] as List<dynamic>?)?.cast<String>() ?? [];
    final homeTown = actor['homeTown'] as String?;
    final yearsActive =
        (actor['yearsActive'] as List<dynamic>?) ?? [];
    final characters =
        ((actor['characters'] as Map<String, dynamic>?)?['nodes']
                as List<dynamic>?) ??
            [];

    final flagLabel = _languageFlag(language);

    return CustomScrollView(
      slivers: [
        // ── Header ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _buildHeader(
            context,
            fullName: fullName,
            nativeName: nativeName,
            imageUrl: imageUrl,
            flagLabel: flagLabel,
            occupations: occupations,
          ),
        ),

        // ── À propos ────────────────────────────────────────────────────
        if (description != null && description.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildAboutSection(description),
          ),

        // ── Stats ────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _buildStats(
            characterCount: characters.length,
            homeTown: homeTown,
            yearsActive: yearsActive,
          ),
        ),

        // ── Rôles connus label ───────────────────────────────────────────
        if (characters.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Rôles connus',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

        // ── Grid personnages ─────────────────────────────────────────────
        if (characters.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final char =
                      characters[index] as Map<String, dynamic>;
                  return _buildCharacterCard(context, char);
                },
                childCount: characters.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 112 / 170,
              ),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────

  Widget _buildHeader(
    BuildContext context, {
    required String fullName,
    required String? nativeName,
    required String? imageUrl,
    required String flagLabel,
    required List<String> occupations,
  }) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundCard, AppColors.backgroundDeep],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Back button row
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Avatar
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? OtadexImage(imagePath: imageUrl, fit: BoxFit.cover)
                    : Container(
                        color: AppColors.backgroundElevated,
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.textDisabled,
                          size: 48,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Full name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                fullName,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            // Native name
            if (nativeName != null && nativeName.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                nativeName,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Badges row
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                // Language badge
                if (flagLabel.isNotEmpty)
                  _buildPill(
                    label: flagLabel,
                    textColor: AppColors.accent,
                    bgColor: AppColors.accent.withValues(alpha: 0.12),
                    borderColor: AppColors.accent,
                  ),

                // Occupation badges
                for (final occ in occupations)
                  _buildPill(
                    label: occ,
                    textColor: AppColors.textSecondary,
                    bgColor: AppColors.backgroundElevated,
                    borderColor: Colors.transparent,
                  ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPill({
    required String label,
    required Color textColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunitoSans(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ─── À propos ────────────────────────────────────────────────────────────

  Widget _buildAboutSection(String rawDescription) {
    final clean = _cleanHtml(rawDescription);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'À propos',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clean,
                  maxLines: _bioExpanded ? null : 4,
                  overflow:
                      _bioExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => _bioExpanded = !_bioExpanded),
                  child: Text(
                    _bioExpanded ? 'Réduire ↑' : 'Lire la suite →',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Stats ───────────────────────────────────────────────────────────────

  Widget _buildStats({
    required int characterCount,
    required String? homeTown,
    required List<dynamic> yearsActive,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _buildStatCell(
                value: '$characterCount',
                label: 'Personnages',
                color: AppColors.statBlue,
                isFirst: true,
              ),
              _buildStatCell(
                value: homeTown ?? '—',
                label: 'Ville natale',
                color: AppColors.statPurple,
              ),
              _buildStatCell(
                value: _yearsActive(yearsActive),
                label: 'Années actif',
                color: AppColors.accent,
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCell({
    required String value,
    required String label,
    required Color color,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            right: isLast
                ? BorderSide.none
                : const BorderSide(
                    color: AppColors.backgroundCard,
                    width: 1,
                  ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Character card ───────────────────────────────────────────────────────

  Widget _buildCharacterCard(
      BuildContext context, Map<String, dynamic> char) {
    final charName =
        (char['name'] as Map<String, dynamic>?)?['full'] as String? ?? '';
    final charImage =
        (char['image'] as Map<String, dynamic>?)?['large'] as String?;

    final mediaNodes =
        ((char['media'] as Map<String, dynamic>?)?['nodes'] as List<dynamic>?) ??
            [];
    String animeName = '';
    if (mediaNodes.isNotEmpty) {
      final firstMedia = mediaNodes.first as Map<String, dynamic>?;
      final title = firstMedia?['title'] as Map<String, dynamic>?;
      animeName = title?['french'] as String? ??
          title?['romaji'] as String? ??
          '';
    }

    return GestureDetector(
      onTap: () {
        // Navigation sans extra — le CharacterDetailScreen chargera les données
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image de fond
            if (charImage != null && charImage.isNotEmpty)
              OtadexImage(imagePath: charImage, fit: BoxFit.cover)
            else
              Container(color: AppColors.backgroundCard),

            // Gradient bas
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.45, 1.0],
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundDeep.withValues(alpha: 0.92),
                    ],
                  ),
                ),
              ),
            ),

            // Texte en bas à gauche
            Positioned(
              left: 6,
              right: 6,
              bottom: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    charName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  if (animeName.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      animeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/otadex_image.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  final List<String> images;
  final int initialIndex;

  const GalleryScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  late final PageController _pageCtrl;
  late final ValueNotifier<int> _indexNotifier;
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    final safeInit = widget.images.isEmpty
        ? 0
        : widget.initialIndex.clamp(0, widget.images.length - 1);
    _pageCtrl = PageController(initialPage: safeInit);
    _indexNotifier = ValueNotifier(safeInit);
    if (widget.images.length > 1) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() => _showHint = false);
      });
    } else {
      _showHint = false;
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _indexNotifier.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    _indexNotifier.value = index;
  }

  void _onThumbTap(int index) {
    _pageCtrl.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _onDownload(BuildContext context) {
    final rank = ref.read(userProfileProvider).rank;
    if (rank == 'kage') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.backgroundCard,
          content: Text(
            '✓ Image sauvegardée',
            style: GoogleFonts.nunitoSans(
              color: AppColors.statGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('📥 Téléchargé avec filigrane'),
          action: SnackBarAction(
            label: 'Voir Kage',
            onPressed: () => context.push('/subscription'),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    final total = images.length;
    final isKage = ref.watch(userProfileProvider).rank == 'kage';

    if (total == 0) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: Center(
          child: Text(
            'Aucune image disponible',
            style: GoogleFonts.nunitoSans(color: Colors.white54),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Main PageView ──────────────────────────────────────────
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragEnd: (details) {
              if ((details.primaryVelocity ?? 0) > 300) context.pop();
            },
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: total,
              onPageChanged: _onPageChanged,
              itemBuilder: (_, i) => _ImagePage(
                imagePath: images[i],
                showWatermark: !isKage,
                hasThumbnails: total > 1,
              ),
            ),
          ),
          // ── Top overlay ───────────────────────────────────────────
          _buildTopBar(context, total),
          // ── Bottom thumbnails ─────────────────────────────────────
          if (total > 1) _buildThumbnails(images),
          // ── Swipe hint ────────────────────────────────────────────
          if (total > 1)
            IgnorePointer(
              ignoring: !_showHint,
              child: AnimatedOpacity(
                opacity: _showHint ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      '← Glisse pour naviguer →',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, int total) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 22),
            ),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: _indexNotifier,
                builder: (_, idx, __) => Text(
                  '${idx + 1} / $total',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.ios_share_rounded,
                  color: Colors.white, size: 22),
            ),
            IconButton(
              onPressed: () => _onDownload(context),
              icon: const Icon(Icons.download_rounded,
                  color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnails(List<String> images) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 72,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xCC000000)],
          ),
        ),
        child: ValueListenableBuilder<int>(
          valueListenable: _indexNotifier,
          builder: (_, selectedIdx, __) => ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            itemCount: images.length,
            itemBuilder: (_, i) {
              final isSelected = i == selectedIdx;
              return GestureDetector(
                onTap: () => _onThumbTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 6),
                  width: isSelected ? 57.0 : 52.0,
                  height: isSelected ? 48.0 : 44.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accent
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: OtadexImage(
                      imagePath: images[i],
                      width: 57,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ImagePage extends StatelessWidget {
  final String imagePath;
  final bool showWatermark;
  final bool hasThumbnails;

  const _ImagePage({
    required this.imagePath,
    required this.showWatermark,
    required this.hasThumbnails,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: InteractiveViewer(
            maxScale: 4.0,
            child: Center(
              child: OtadexImage(
                imagePath: imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        if (showWatermark)
          Positioned(
            right: 12,
            bottom: hasThumbnails ? 80 : 16,
            child: Text(
              'OTADEX',
              style: TextStyle(
                fontSize: 9,
                color: Colors.white.withValues(alpha: 0.35),
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

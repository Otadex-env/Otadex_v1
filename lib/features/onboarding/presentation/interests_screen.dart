import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/skeleton_loader.dart';

class _Category {
  final String name;
  final String emoji;
  final String example;

  const _Category(this.name, this.emoji, this.example);
}

const List<_Category> _categories = [
  _Category('Shōnen', '🔥', 'One Piece, Naruto, MHA'),
  _Category('Shōjo', '🌸', 'Fruits Basket, Sailor Moon'),
  _Category('Seinen', '⚔️', 'Berserk, Vinland Saga'),
  _Category('Josei', '💜', 'Nana, Chihayafuru'),
  _Category('Manhwa', '🇰🇷', 'Solo Leveling, Tower of God'),
  _Category('Webtoon', '📱', 'Lore Olympus, True Beauty'),
  _Category('Donghua', '🐉', "The King's Avatar, MDZS"),
  _Category('Isekai', '🌀', 'Re:Zero, Sword Art Online'),
  _Category('Mecha', '🤖', 'Gundam, Evangelion'),
  _Category('Slice of Life', '🍵', 'Your Lie in April, Clannad'),
];

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final Set<int> _selected = {};
  bool _isLoading = false;

  bool get _canValidate => _selected.length >= 3;

  void _toggle(int idx) {
    setState(() {
      if (_selected.contains(idx)) {
        _selected.remove(idx);
      } else {
        _selected.add(idx);
      }
    });
  }

  Future<void> _onConfirm() async {
    if (!_canValidate || _isLoading) return;
    setState(() => _isLoading = true);

    final interests = _selected.map((i) => _categories[i].name).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserInterests, jsonEncode(interests));
    await prefs.setBool(AppConstants.keyOnboardingCompleted, true);

    if (!mounted) return;
    setState(() => _isLoading = false);

    final username = prefs.getString('user_pseudo') ?? 'fan';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Bienvenue sur OTADEX, $username 🔥',
          style: GoogleFonts.nunitoSans(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.backgroundCard,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );

    context.go(AppRouter.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildCounter(),
            Expanded(child: _buildGrid()),
            _buildCTA(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tes univers préférés',
            style: GoogleFonts.rajdhani(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sélectionne au moins 3 catégories pour personnaliser ton expérience OTADEX',
            maxLines: 2,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter() {
    final count = _selected.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          '$count / 3 minimum',
          style: GoogleFonts.nunitoSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _canValidate ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 111 / 130,
      ),
      itemCount: _categories.length,
      itemBuilder: (_, i) => _CategoryCard(
        category: _categories[i],
        isSelected: _selected.contains(i),
        onTap: () => _toggle(i),
      ),
    );
  }

  Widget _buildCTA() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.35),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: _canValidate
            ? SizedBox(
                key: const ValueKey('active'),
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.backgroundDeep,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? shimmerBox(width: 22, height: 22, radius: 11)
                      : Text(
                          "C'est parti ! →",
                          style: GoogleFonts.nunitoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.backgroundDeep,
                          ),
                        ),
                ),
              )
            : SizedBox(
                key: const ValueKey('disabled'),
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundCard,
                    disabledBackgroundColor: AppColors.backgroundCard,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Sélectionne 3 catégories minimum',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final _Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    await _ctrl.forward();
    widget.onTap();
    await _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.accentGlow.withValues(alpha: 0.18)
                : AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.accent
                  : AppColors.borderSubtle,
              width: widget.isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.category.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.category.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: GoogleFonts.rajdhani(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.category.example,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.isSelected)
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 11,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

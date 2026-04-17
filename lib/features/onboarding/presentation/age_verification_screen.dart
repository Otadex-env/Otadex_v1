import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

class AgeVerificationScreen extends StatefulWidget {
  const AgeVerificationScreen({super.key});

  @override
  State<AgeVerificationScreen> createState() => _AgeVerificationScreenState();
}

class _AgeVerificationScreenState extends State<AgeVerificationScreen> {
  static final int _currentYear = DateTime.now().year;
  static const int _oldestYear = 1924;
  static const int _defaultYear = 2000;
  static const double _itemExtent = 52.0;
  static const int _visibleItems = 5;

  late final FixedExtentScrollController _dayCtrl;
  late final FixedExtentScrollController _monthCtrl;
  late final FixedExtentScrollController _yearCtrl;

  int _dayIdx = 0;
  int _monthIdx = 0;
  int _yearIdx = 0;

  static const List<String> _monthNames = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];

  @override
  void initState() {
    super.initState();
    final defaultYearIdx = _currentYear - _defaultYear;
    _dayCtrl = FixedExtentScrollController(initialItem: 0);
    _monthCtrl = FixedExtentScrollController(initialItem: 0);
    _yearCtrl = FixedExtentScrollController(initialItem: defaultYearIdx);
    _yearIdx = defaultYearIdx;
  }

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  int get _day => _dayIdx + 1;
  int get _month => _monthIdx + 1;
  int get _year => _currentYear - _yearIdx;

  int _calcAge() {
    final now = DateTime.now();
    final birth = DateTime(_year, _month, _day);
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  Future<void> _onNext() async {
    final age = _calcAge();
    if (age < 13) {
      _showAccessDenied();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final birth = DateTime(_year, _month, _day);
    await prefs.setString(
      AppConstants.keyBirthDate,
      '${birth.year.toString().padLeft(4, '0')}-'
      '${birth.month.toString().padLeft(2, '0')}-'
      '${birth.day.toString().padLeft(2, '0')}',
    );
    await prefs.setInt(AppConstants.keyUserAge, age);

    if (!mounted) return;
    context.push(AppRouter.interests);
  }

  void _showAccessDenied() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Accès restreint',
          style: GoogleFonts.rajdhani(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'OTADEX est destiné aux utilisateurs de 13 ans et plus.',
          style: GoogleFonts.nunitoSans(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppRouter.login);
            },
            child: Text(
              'Retour',
              style: GoogleFonts.nunitoSans(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(AppRouter.login);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDeep,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(
                child: Center(child: _buildPicker()),
              ),
              _buildCTA(),
            ],
          ),
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
            onTap: () => context.go(AppRouter.login),
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
          const SizedBox(height: 24),
          Text(
            'Quel âge as-tu ?',
            style: GoogleFonts.rajdhani(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Confirme ta date de naissance pour accéder à OTADEX',
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

  Widget _buildPicker() {
    const pickerHeight = _itemExtent * _visibleItems;
    const separatorTop = pickerHeight / 2 - _itemExtent / 2;

    return SizedBox(
      height: pickerHeight,
      child: Stack(
        children: [
          // Selected item highlight band
          Positioned(
            top: separatorTop,
            left: 8,
            right: 8,
            height: _itemExtent,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.accentGlow.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Top separator
          Positioned(
            top: separatorTop,
            left: 0,
            right: 0,
            height: 1,
            child: const ColoredBox(color: AppColors.borderSubtle),
          ),
          // Bottom separator
          const Positioned(
            top: separatorTop + _itemExtent,
            left: 0,
            right: 0,
            height: 1,
            child: ColoredBox(color: AppColors.borderSubtle),
          ),
          // Columns
          Row(
            children: [
              Expanded(
                child: _buildWheelColumn(
                  controller: _dayCtrl,
                  count: 31,
                  label: (i) => (i + 1).toString().padLeft(2, '0'),
                  selectedIdx: _dayIdx,
                  onChanged: (i) => setState(() => _dayIdx = i),
                ),
              ),
              Expanded(
                flex: 2,
                child: _buildWheelColumn(
                  controller: _monthCtrl,
                  count: 12,
                  label: (i) => _monthNames[i],
                  selectedIdx: _monthIdx,
                  onChanged: (i) => setState(() => _monthIdx = i),
                ),
              ),
              Expanded(
                child: _buildWheelColumn(
                  controller: _yearCtrl,
                  count: _currentYear - _oldestYear + 1,
                  label: (i) => (_currentYear - i).toString(),
                  selectedIdx: _yearIdx,
                  onChanged: (i) => setState(() => _yearIdx = i),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWheelColumn({
    required FixedExtentScrollController controller,
    required int count,
    required String Function(int) label,
    required int selectedIdx,
    required ValueChanged<int> onChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: _itemExtent,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.003,
      diameterRatio: 2.5,
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: count,
        builder: (_, i) {
          final dist = (i - selectedIdx).abs();
          final isSelected = dist == 0;
          final double opacity;
          if (isSelected || dist == 1) {
            opacity = 1.0;
          } else if (dist == 2) {
            opacity = 0.5;
          } else {
            opacity = 0.2;
          }
          return Center(
            child: Text(
              label(i),
              textAlign: TextAlign.center,
              style: isSelected
                  ? GoogleFonts.rajdhani(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    )
                  : GoogleFonts.nunitoSans(
                      fontSize: 16,
                      color: AppColors.textSecondary.withValues(alpha: opacity),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCTA() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.backgroundDeep,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Suivant',
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.backgroundDeep,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ta date de naissance ne sera jamais partagée.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunitoSans(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

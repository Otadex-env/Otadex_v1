import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../subscription/rank_providers.dart';
import 'ad_config.dart';
import 'ads_service.dart';

/// Bannière AdMob adaptée à la largeur disponible, réservée au rang Genin.
///
/// Prend zéro place tant qu'aucune annonce n'est chargée (rang payant, hors
/// ligne, consentement refusé, pas d'inventaire).
class OtadexBannerAd extends ConsumerWidget {
  const OtadexBannerAd({super.key, this.padding = EdgeInsets.zero});

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Retirer le widget de l'arbre libère aussitôt l'annonce déjà chargée.
    if (!ref.watch(effectiveRankProvider).showsAds) {
      return const SizedBox.shrink();
    }
    if (AdConfig.bannerUnitId.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            padding.deflateSize(Size(constraints.maxWidth, 0)).width.truncate();
        return _Banner(key: ValueKey(width), width: width, padding: padding);
      },
    );
  }
}

class _Banner extends StatefulWidget {
  const _Banner({super.key, required this.width, required this.padding});

  final int width;
  final EdgeInsetsGeometry padding;

  @override
  State<_Banner> createState() => _BannerState();
}

class _BannerState extends State<_Banner> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    AdsService.ready.addListener(_onReadyChanged);
    // Après la première frame : le formulaire de consentement a besoin d'une
    // activité affichée.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AdsService.ensureStarted();
      if (mounted) unawaited(_load());
    });
  }

  void _onReadyChanged() {
    if (AdsService.ready.value) {
      unawaited(_load());
    } else {
      _ad?.dispose();
      setState(() {
        _ad = null;
        _loaded = false;
      });
    }
  }

  bool _loading = false;

  Future<void> _load() async {
    if (_loading || _ad != null || !AdsService.ready.value) return;
    if (widget.width <= 0) return;
    _loading = true;
    // Taille « ancrée » classique (~50-60 px de haut) : la variante « large »
    // proposée par le SDK prend nettement plus de place.
    // ignore: deprecated_member_use
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        widget.width);
    _loading = false;
    if (!mounted || size == null) return;

    final ad = BannerAd(
      adUnitId: AdConfig.bannerUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Bannière: ${error.message}');
          ad.dispose();
          if (mounted) {
            setState(() {
              _ad = null;
              _loaded = false;
            });
          }
        },
      ),
    );
    _ad = ad;
    await ad.load();
  }

  @override
  void dispose() {
    AdsService.ready.removeListener(_onReadyChanged);
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (ad == null || !_loaded) return const SizedBox.shrink();
    return Padding(
      padding: widget.padding,
      child: Center(
        heightFactor: 1,
        child: SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}

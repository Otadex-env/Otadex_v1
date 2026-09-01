import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../subscription/rank_providers.dart';
import 'otadex_theme.dart';
import 'rank_theme.dart';

/// Injecte le [RankTheme] du rang effectif de l'utilisateur dans l'arbre,
/// via l'InheritedWidget [OtadexTheme].
///
/// Source de vérité unique : [effectiveRankProvider]. Aucun état local, aucune
/// API impérative — le thème suit automatiquement le rang réel comme l'override
/// du menu développeur.
class OtadexThemeWrapper extends ConsumerWidget {
  final bool isDark;
  final Widget child;

  const OtadexThemeWrapper({
    super.key,
    this.isDark = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rank = ref.watch(effectiveRankProvider);
    return OtadexTheme(
      rankTheme: RankTheme.forRank(rank, isDark: isDark),
      currentRank: rank,
      child: child,
    );
  }
}

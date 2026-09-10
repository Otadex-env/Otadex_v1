import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/character.dart';
import '../providers/anilist_providers.dart';
import '../providers/auth_provider.dart';
import '../subscription/rank_providers.dart';
import '../theme/app_colors.dart';
import '../utils/price_formatter.dart';
import 'auth_gate_modal.dart';

/// Ajoute / retire un personnage de la collection **Firestore** (source unique).
///
/// Chemin d'écriture UNIQUE partagé par le FAB de fiche et les cartes de grille :
/// applique le même contrôle de limite Genin (modale d'upsell) et les mêmes
/// retours utilisateur. Ne touche jamais à un état local.
Future<void> toggleCollection(
  BuildContext context,
  WidgetRef ref,
  Character character,
) async {
  if (!ref.read(isLoggedInProvider)) {
    showAuthGateModal(context);
    return;
  }

  final service = ref.read(collectionServiceProvider);
  final isCollected = ref.read(isCollectedProvider(character.id));
  final messenger = ScaffoldMessenger.of(context);

  if (isCollected) {
    await service.removeFromCollection(character.id);
    messenger.showSnackBar(
      const SnackBar(content: Text('Retiré de ta collection')),
    );
    return;
  }

  final currentCount = ref.read(collectionCountProvider);
  final limit = ref.read(effectiveRankProvider).collectionLimit;

  try {
    await service.addToCollection(
      character.id,
      collectionLimit: limit,
      currentCount: currentCount,
    );
    messenger.showSnackBar(
      SnackBar(
        content: Text('${character.name} ajouté à ta collection !'),
        backgroundColor: AppColors.statGreen,
      ),
    );
  } catch (e) {
    if (e == 'LIMIT_REACHED' && context.mounted) {
      showCollectionLimitModal(context);
    }
  }
}

/// Modale « Collection pleine » — atteinte de la limite Genin (10).
void showCollectionLimitModal(BuildContext context) {
  final router = GoRouter.of(context);
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.backgroundCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎴', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'Collection pleine !',
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tu as atteint la limite de 10 personnages.\n'
            'Passe Jonin pour une collection illimitée.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunitoSans(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.statBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                router.push('/subscription');
              },
              child: Text(
                'Devenir Jonin — ${PlanPrices.jonin()}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Pas maintenant',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    ),
  );
}

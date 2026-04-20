import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/l10n/app_locale.dart';
import 'core/l10n/app_strings.dart';
import 'core/l10n/locale_provider.dart';
import 'core/models/user_rank.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/otadex_theme.dart';
import 'core/theme/otadex_theme_wrapper.dart';

class OtadexApp extends ConsumerWidget {
  const OtadexApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return AppLocale(
      strings: AppStrings.forLocale(locale),
      child: OtadexThemeWrapper(
        initialRank: UserRank.genin,
        child: Builder(
          builder: (context) {
            final rankTheme = OtadexTheme.of(context);
            return MaterialApp.router(
              title: 'OTADEX',
              debugShowCheckedModeBanner: false,
              locale: Locale(locale),
              routerConfig: AppRouter.router,
              theme: AppTheme.buildDarkTheme().copyWith(
                scaffoldBackgroundColor: rankTheme.backgroundPrimary,
                colorScheme: AppTheme.buildDarkTheme().colorScheme.copyWith(
                      primary: rankTheme.accentColor,
                      secondary: rankTheme.accentLight,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}

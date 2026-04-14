import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class OtadexApp extends ConsumerWidget {
  const OtadexApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'OTADEX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildDarkTheme(),
      routerConfig: AppRouter.router,
    );
  }
}

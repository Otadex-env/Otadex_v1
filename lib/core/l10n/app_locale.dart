import 'package:flutter/material.dart';
import 'app_strings.dart';

class AppLocale extends InheritedWidget {
  final AppStrings strings;

  const AppLocale({
    super.key,
    required this.strings,
    required super.child,
  });

  static AppStrings of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppLocale>();
    assert(result != null, 'AppLocale not found. Wrap your app with AppLocale.');
    return result!.strings;
  }

  @override
  bool updateShouldNotify(AppLocale old) => old.strings != strings;
}

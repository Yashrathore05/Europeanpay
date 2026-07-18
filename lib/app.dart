import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_extensions.dart';

/// Root application widget for European Pay.
class EuropeanPayApp extends ConsumerWidget {
  const EuropeanPayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'European Pay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        extensions: [EuPayTheme.light],
      ),
      routerConfig: appRouter,
    );
  }
}

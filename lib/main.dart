import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'providers/app_state_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NashikKumbhApp()));
}

class NashikKumbhApp extends ConsumerWidget {
  const NashikKumbhApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    return MaterialApp(
      title: 'Nashik Kumbh Navigator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appState.themeMode == AppThemeMode.dark
          ? ThemeMode.dark
          : (appState.themeMode == AppThemeMode.accessibility ? ThemeMode.light : ThemeMode.light),
      builder: (context, child) {
        // Apply accessibility high-contrast adjustments if enabled
        if (appState.themeMode == AppThemeMode.accessibility) {
          return Theme(
            data: AppTheme.accessibilityTheme,
            child: child!,
          );
        }
        return child!;
      },
      locale: Locale(appState.languageCode),
      supportedLocales: const [
        Locale('en', ''),
        Locale('hi', ''),
        Locale('mr', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}

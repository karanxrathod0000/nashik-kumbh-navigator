import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../services/mock_backend_service.dart';

class AppState {
  final AppThemeMode themeMode;
  final String languageCode;
  final bool isOfflineMode;
  final int currentNavIndex;

  const AppState({
    this.themeMode = AppThemeMode.light,
    this.languageCode = 'en',
    this.isOfflineMode = false,
    this.currentNavIndex = 0,
  });

  AppState copyWith({
    AppThemeMode? themeMode,
    String? languageCode,
    bool? isOfflineMode,
    int? currentNavIndex,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
      currentNavIndex: currentNavIndex ?? this.currentNavIndex,
    );
  }
}

class AppStateNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    return const AppState();
  }

  void setThemeMode(AppThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void toggleDarkMode() {
    if (state.themeMode == AppThemeMode.dark) {
      state = state.copyWith(themeMode: AppThemeMode.light);
    } else {
      state = state.copyWith(themeMode: AppThemeMode.dark);
    }
  }

  void toggleAccessibilityMode() {
    if (state.themeMode == AppThemeMode.accessibility) {
      state = state.copyWith(themeMode: AppThemeMode.light);
    } else {
      state = state.copyWith(themeMode: AppThemeMode.accessibility);
    }
  }

  void setLanguage(String code) {
    state = state.copyWith(languageCode: code);
  }

  void setLanguageCode(String code) => setLanguage(code);

  void toggleOfflineMode() {
    final newVal = !state.isOfflineMode;
    MockBackendService.instance.setOfflineMode(newVal);
    state = state.copyWith(isOfflineMode: newVal);
  }

  void setNavIndex(int index) {
    state = state.copyWith(currentNavIndex: index);
  }
}

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(AppStateNotifier.new);

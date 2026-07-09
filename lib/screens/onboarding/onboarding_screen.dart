import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/reusable_ui_components.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = ref.watch(appStateProvider);
    final tr = AppLocalizations.of(context);

    final slides = [
      {
        'title': tr.translate('slide1_title'),
        'desc': tr.translate('slide1_desc'),
        'icon': Icons.map_rounded,
        'color': AppColors.primaryViolet,
      },
      {
        'title': tr.translate('slide2_title'),
        'desc': tr.translate('slide2_desc'),
        'icon': Icons.campaign_rounded,
        'color': AppColors.secondarySaffron,
      },
      {
        'title': tr.translate('slide3_title'),
        'desc': tr.translate('slide3_desc'),
        'icon': Icons.family_restroom_rounded,
        'color': AppColors.successGreen,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Language Selector & Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Language Switcher Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.primaryViolet.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: ['en', 'hi', 'mr'].map((code) {
                        final isSelected = appState.languageCode == code;
                        String label = 'EN';
                        if (code == 'hi') label = 'हिंदी';
                        if (code == 'mr') label = 'मराठी';
                        return GestureDetector(
                          onTap: () => ref.read(appStateProvider.notifier).setLanguage(code),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryViolet : Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              label,
                              style: AppTypography.captionBold(isDark).copyWith(
                                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Skip button
                  if (_currentPage < 2)
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: Text(
                        tr.translate('skip'),
                        style: AppTypography.bodyMedium(isDark).copyWith(color: AppColors.textSecondary),
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemCount: slides.length,
                itemBuilder: (context, idx) {
                  final item = slides[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 240,
                              height: 240,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    (item['color'] as Color).withValues(alpha: 0.2),
                                    AppColors.pastelSkyBlue.withValues(alpha: 0.3),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(color: (item['color'] as Color).withValues(alpha: 0.4), width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: (item['color'] as Color).withValues(alpha: 0.15),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  item['icon'] as IconData,
                                  size: 110,
                                  color: item['color'] as Color,
                                ),
                              ),
                            ),
                            // Floating social proof chip top right
                            Positioned(
                              top: 10,
                              right: -10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: const [
                                    BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      idx == 0 ? "Ramesh 4.8★" : (idx == 1 ? "Vanshika 4.9★" : "Aarti 5.0★"),
                                      style: AppTypography.captionBold(false).copyWith(color: AppColors.textPrimary, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Floating tag bottom left
                            Positioned(
                              bottom: 15,
                              left: -10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryViolet,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(color: AppColors.primaryViolet.withValues(alpha: 0.3), blurRadius: 10),
                                  ],
                                ),
                                child: Text(
                                  idx == 0 ? "📍 Live Heatmaps" : (idx == 1 ? "📢 SOS 108" : "👨‍👩‍👧 Family Safe"),
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Text(
                          item['title'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.onboardingHeadline(isDark),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item['desc'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyRegular(isDark).copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
                },
              ),
            ),
            // Page Indicators & Buttons
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(slides.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.secondarySaffron : Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  PillButton(
                    text: _currentPage == 2 ? tr.translate('get_started') : tr.translate('next'),
                    backgroundColor: _currentPage == 2 ? AppColors.secondarySaffron : AppColors.primaryViolet,
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _finishOnboarding();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

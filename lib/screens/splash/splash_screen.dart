import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (ctx, a1, a2) => const OnboardingScreen(),
            transitionsBuilder: (ctx, anim, secAnim, child) => FadeTransition(opacity: anim, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF3FB), Color(0xFFFFF0E3), Color(0xFFFF8C42)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Glowing Kumbh Kalash / Ghat Icon
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: AppColors.primaryViolet.withValues(alpha: 0.3), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryViolet.withValues(alpha: 0.25),
                      blurRadius: 30,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.temple_hindu_rounded,
                    size: 70,
                    color: AppColors.primaryViolet,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                AppConstants.appName,
                style: AppTypography.headingLarge(false).copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0F000000), blurRadius: 10),
                  ],
                ),
                child: Text(
                  AppConstants.tagline,
                  style: AppTypography.bodyMedium(false).copyWith(
                    color: AppColors.primaryViolet,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              // Silhouette simulation
              const Icon(Icons.waves_rounded, color: AppColors.riverBlue, size: 40),
              const SizedBox(height: 8),
              Text(
                "Simhastha Nashik 2027 • Official Navigation Companion",
                style: AppTypography.caption(false).copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

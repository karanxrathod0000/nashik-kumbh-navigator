import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/reusable_ui_components.dart';
import '../dashboard/home_dashboard.dart';
import 'phone_otp_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeDashboard()),
    );
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    final success = await ref.read(authProvider.notifier).loginWithGoogle();
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        _navigateToHome();
      } else {
        final err = ref.read(authProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err ?? 'Google Sign-In failed'), backgroundColor: AppColors.alertRed),
        );
      }
    }
  }

  Future<void> _handlePhoneSubmit() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }
    final formattedPhone = phone.startsWith('+') ? phone : '+91$phone';
    final name = _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Kumbh Pilgrim';

    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).sendPhoneOtp(
      formattedPhone,
      (verId) {
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PhoneOtpScreen(phoneNumber: formattedPhone, userName: name),
            ),
          );
        }
      },
      (err) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $err'), backgroundColor: AppColors.alertRed),
          );
        }
      },
    );
  }

  Future<void> _handleGuestLogin() async {
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).continueAsGuest();
    if (mounted) {
      setState(() => _isLoading = false);
      _navigateToHome();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = ref.watch(appStateProvider);
    final authState = ref.watch(authProvider);
    final tr = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Language Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.primaryViolet.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: ['en', 'hi', 'mr'].map((code) {
                        final isSelected = appState.languageCode == code;
                        String label = 'English';
                        if (code == 'hi') label = 'हिंदी';
                        if (code == 'mr') label = 'मराठी';
                        return GestureDetector(
                          onTap: () => ref.read(appStateProvider.notifier).setLanguage(code),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                ],
              ),
              const SizedBox(height: 32),
              // Logo & Title
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.saffronGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondarySaffron.withValues(alpha: 0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.waves_rounded, color: Colors.white, size: 42),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                tr.translate('login_title'),
                style: AppTypography.headingLarge(isDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                tr.translate('tagline'),
                style: AppTypography.bodyRegular(isDark).copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              // Google Login Card
              CustomCard(
                onTap: (_isLoading || authState.isLoading) ? null : _handleGoogleLogin,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.g_mobiledata_rounded, color: AppColors.primaryViolet, size: 36),
                    const SizedBox(width: 12),
                    Text(
                      tr.translate('google_login'),
                      style: AppTypography.bodyBold(isDark).copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: AppTypography.captionBold(isDark)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
                ],
              ),
              const SizedBox(height: 20),
              // Phone OTP Card Form
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.translate('phone_login'),
                      style: AppTypography.headingSmall(isDark),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      enabled: !_isLoading && !authState.isLoading,
                      decoration: const InputDecoration(
                        hintText: 'Your Name (e.g. Aarav)',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      enabled: !_isLoading && !authState.isLoading,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Mobile Number (10 digits)',
                        prefixIcon: Icon(Icons.phone_android_rounded),
                        prefixText: '+91 ',
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isLoading || authState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      PillButton(
                        text: 'Send OTP Verification',
                        icon: Icons.send_rounded,
                        onPressed: _handlePhoneSubmit,
                        backgroundColor: AppColors.saffron,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Guest visitor link (secondary styled, clearly de-emphasized)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: (_isLoading || authState.isLoading) ? null : _handleGuestLogin,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_outline_rounded, color: AppColors.primaryViolet, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Continue as Guest →',
                          style: AppTypography.bodyBold(isDark).copyWith(
                            color: AppColors.primaryViolet,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

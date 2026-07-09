import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/reusable_ui_components.dart';

class PhoneOtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String userName;

  const PhoneOtpScreen({
    super.key,
    required this.phoneNumber,
    this.userName = 'Kumbh Pilgrim',
  });

  @override
  ConsumerState<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends ConsumerState<PhoneOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _secondsRemaining = 30;
  Timer? _timer;
  bool _canResend = false;
  String? _inlineError;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _verifyCode() async {
    final code = _otpController.text.trim();
    if (code.length != 6) {
      setState(() => _inlineError = 'Please enter a valid 6-digit OTP code');
      return;
    }
    setState(() => _inlineError = null);

    final success = await ref.read(authProvider.notifier).verifyOtp(code, userName: widget.userName);
    if (success && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (mounted) {
      final err = ref.read(authProvider).errorMessage;
      setState(() => _inlineError = err ?? 'Verification failed. Please try again.');
    }
  }

  void _resendOtp() {
    if (!_canResend) return;
    _startCountdown();
    ref.read(authProvider.notifier).sendPhoneOtp(
          widget.phoneNumber,
          (verId) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('📱 A new OTP has been sent!')),
            );
          },
          (err) {
            setState(() => _inlineError = err);
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppColors.lightTextPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.saffron.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.sms_rounded, color: AppColors.saffron, size: 36),
              ),
              const SizedBox(height: 20),
              Text('Enter Verification Code', style: AppTypography.headingMedium(isDark)),
              const SizedBox(height: 8),
              Text(
                'We have sent a 6-digit verification code to ${widget.phoneNumber}',
                style: AppTypography.bodyRegular(isDark).copyWith(color: isDark ? Colors.white70 : AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: AppTypography.headingMedium(isDark).copyWith(letterSpacing: 8, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '000000',
                  hintStyle: AppTypography.headingMedium(isDark).copyWith(color: Colors.grey.withValues(alpha: 0.4), letterSpacing: 8),
                  filled: true,
                  fillColor: isDark ? AppColors.darkCard : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.saffron, width: 2),
                  ),
                ),
                onChanged: (val) {
                  if (val.length == 6) {
                    _verifyCode();
                  }
                },
              ),
              if (_inlineError != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: AppColors.alertRed, size: 18),
                    const SizedBox(width: 6),
                    Text(_inlineError!, style: AppTypography.caption(isDark).copyWith(color: AppColors.alertRed, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
              const SizedBox(height: 32),
              PillButton(
                text: authState.isLoading ? 'Verifying...' : 'Verify & Sign In',
                icon: Icons.check_circle_outline_rounded,
                onPressed: authState.isLoading ? () {} : _verifyCode,
                backgroundColor: AppColors.saffron,
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: _canResend ? _resendOtp : null,
                  child: Text(
                    _canResend ? 'Resend OTP Code' : 'Resend code in ${_secondsRemaining}s',
                    style: AppTypography.bodyBold(isDark).copyWith(
                      color: _canResend ? AppColors.saffron : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

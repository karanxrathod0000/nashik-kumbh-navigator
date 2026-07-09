import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/family_provider.dart';
import '../../providers/map_provider.dart';
import '../../services/firestore_service.dart';
import '../../widgets/common/custom_card.dart';

class EmergencySosScreen extends ConsumerStatefulWidget {
  const EmergencySosScreen({super.key});

  @override
  ConsumerState<EmergencySosScreen> createState() => _EmergencySosScreenState();
}

class _EmergencySosScreenState extends ConsumerState<EmergencySosScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isCountdownActive = false;
  int _countdownSecs = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
  }

  void _startSosCountdown() {
    setState(() {
      _isCountdownActive = true;
      _countdownSecs = 5;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdownSecs > 1) {
        setState(() => _countdownSecs--);
      } else {
        t.cancel();
        _triggerSosBroadcast();
      }
    });
  }

  void _cancelCountdown() {
    _timer?.cancel();
    setState(() => _isCountdownActive = false);
  }

  void _triggerSosBroadcast() {
    ref.read(familyProvider.notifier).triggerSos();
    setState(() => _isCountdownActive = false);

    final authState = ref.read(authProvider);
    final mapState = ref.read(mapProvider);

    // Send real SOS Alert to Firestore
    FirestoreService.instance.sendSosAlert(
      uid: authState.userId,
      userName: authState.userName.isEmpty ? 'Kumbh Pilgrim' : authState.userName,
      phone: authState.userPhone,
      latitude: mapState.userLocation.latitude,
      longitude: mapState.userLocation.longitude,
      address: 'Nashik Kumbh Mela Zone',
    );

    _showSosSuccessDialog();
  }

  void _showSosSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.alertHeavy,
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Text('SOS BROADCASTED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Your live GPS coordinates have been sent to Panchavati Police HQ, Ambulance 108, and your emergency family guardians.\n\nStay calm. Volunteer rescue teams are moving toward your location.',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(familyProvider.notifier).cancelSos();
                Navigator.pop(context);
              },
              child: const Text('CANCEL SOS ALERT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not dial $number on this device')),
        );
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final tr = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('emergency_sos')),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                'Instant Emergency Response & Location Share',
                style: AppTypography.headingSmall(isDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                tr.translate('sos_hint'),
                style: AppTypography.bodyRegular(isDark).copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // One-Tap Large SOS Button
              GestureDetector(
                onTap: _isCountdownActive ? _cancelCountdown : _startSosCountdown,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final scale = _isCountdownActive ? 1.05 + (_pulseController.value * 0.1) : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [Color(0xFFFF3333), Color(0xFFC0392B)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.alertHeavy.withValues(alpha: 0.5),
                              blurRadius: 30 + (_pulseController.value * 20),
                              spreadRadius: _isCountdownActive ? 15 : 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isCountdownActive ? Icons.timer : Icons.sos_rounded,
                                color: Colors.white,
                                size: 64,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isCountdownActive ? 'SENDING IN $_countdownSecs...' : 'PRESS SOS',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              if (_isCountdownActive)
                                const Text(
                                  'Tap to Cancel',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              // "I'm Safe" Check-In Button
              CustomCard(
                padding: const EdgeInsets.all(16),
                backgroundColor: AppColors.successGreen.withValues(alpha: isDark ? 0.2 : 0.1),
                border: Border.all(color: AppColors.successGreen, width: 1.5),
                onTap: () {
                  final authState = ref.read(authProvider);
                  FirestoreService.instance.submitSafeCheckin(
                    authState.userId,
                    authState.userName.isEmpty ? 'Kumbh Pilgrim' : authState.userName,
                    'Ramkund Holy Ghat Area',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Safety check-in sent! Your family group has been notified you are safe."),
                      backgroundColor: AppColors.successGreen,
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.successGreen, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      tr.translate('im_safe'),
                      style: AppTypography.headingSmall(isDark).copyWith(color: AppColors.successGreen),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Quick Dial Emergency Numbers',
                style: AppTypography.headingSmall(isDark),
              ),
              const SizedBox(height: 14),
              // Quick Dial 2x2 Grid
              Row(
                children: [
                  Expanded(child: _buildDialCard('Police', '100', Icons.local_police_rounded, const Color(0xFF2F80ED), isDark)),
                  const SizedBox(width: 14),
                  Expanded(child: _buildDialCard('Ambulance', '108', Icons.medical_services_rounded, const Color(0xFFE74C3C), isDark)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _buildDialCard('Fire Brigade', '101', Icons.local_fire_department_rounded, const Color(0xFFF39C12), isDark)),
                  const SizedBox(width: 14),
                  Expanded(child: _buildDialCard('Kumbh Helpline', '1070', Icons.support_agent_rounded, AppColors.primaryViolet, isDark)),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialCard(String title, String number, IconData icon, Color color, bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.zero,
      onTap: () => _makePhoneCall(number),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.captionBold(isDark)),
              Text(number, style: AppTypography.headingMedium(isDark).copyWith(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

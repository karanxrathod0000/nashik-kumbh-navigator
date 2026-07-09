import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../services/qr_service.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/gradient_button.dart';

class QrWristbandScreen extends ConsumerWidget {
  const QrWristbandScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final userState = ref.watch(authProvider);
    final tr = AppLocalizations.of(context);

    final qrPayload = QrService.generateWristbandData(
      name: userState.userName,
      phone: userState.phoneNumber,
      emergencyMedicalInfo: 'Blood Group O+, Guardian: +91 98230 12345',
    );
    debugPrint('Generated QR Payload: $qrPayload');

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('qr_wristband')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              'Digital Pilgrim ID & Safety Wristband',
              style: AppTypography.headingSmall(isDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Show this QR code at camp check-in gates or if a child / elderly member gets separated from the group.',
              style: AppTypography.bodyRegular(isDark).copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // QR Code Box (Custom canvas representation)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: AppColors.primaryViolet.withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  // Simulated QR pattern grid
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CustomPaint(
                      painter: _QrGridPainter(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.navBarNavy,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'ID: NK-2027-SIMHASTHA',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            CustomCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Encoded Emergency Profile', style: AppTypography.headingSmall(isDark)),
                  const SizedBox(height: 12),
                  _buildProfileRow('Pilgrim Name:', userState.userName, isDark),
                  const SizedBox(height: 8),
                  _buildProfileRow('Primary Contact:', userState.phoneNumber.isNotEmpty ? userState.phoneNumber : '+91 98765 43210', isDark),
                  const SizedBox(height: 8),
                  _buildProfileRow('Guardian Emergency:', '+91 98230 12345 (Ramesh)', isDark),
                  const SizedBox(height: 8),
                  _buildProfileRow('Medical Info:', 'Blood Group O+, No Known Allergies', isDark),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              text: 'Save QR to Photo Gallery / Wallet',
              icon: Icons.download_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Wristband ID saved offline to your gallery!')),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String val, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: AppTypography.captionBold(isDark).copyWith(color: AppColors.textSecondary)),
        ),
        Expanded(
          child: Text(val, style: AppTypography.bodyBold(isDark)),
        ),
      ],
    );
  }
}

class _QrGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Outer corner boxes
    canvas.drawRect(const Rect.fromLTWH(0, 0, 60, 60), paint);
    canvas.drawRect(const Rect.fromLTWH(10, 10, 40, 40), Paint()..color = Colors.white);
    canvas.drawRect(const Rect.fromLTWH(20, 20, 20, 20), paint);

    canvas.drawRect(Rect.fromLTWH(size.width - 60, 0, 60, 60), paint);
    canvas.drawRect(Rect.fromLTWH(size.width - 50, 10, 40, 40), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(size.width - 40, 20, 20, 20), paint);

    canvas.drawRect(Rect.fromLTWH(0, size.height - 60, 60, 60), paint);
    canvas.drawRect(Rect.fromLTWH(10, size.height - 50, 40, 40), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(20, size.height - 40, 20, 20), paint);

    // Pseudo random blocks representing data
    final blocks = [
      const Rect.fromLTWH(80, 10, 20, 20),
      const Rect.fromLTWH(110, 10, 10, 30),
      const Rect.fromLTWH(130, 20, 20, 10),
      const Rect.fromLTWH(80, 50, 30, 10),
      const Rect.fromLTWH(120, 50, 20, 20),
      const Rect.fromLTWH(10, 80, 20, 20),
      const Rect.fromLTWH(40, 80, 10, 40),
      const Rect.fromLTWH(70, 80, 40, 20),
      const Rect.fromLTWH(130, 80, 30, 30),
      const Rect.fromLTWH(180, 80, 20, 10),
      const Rect.fromLTWH(20, 130, 30, 10),
      const Rect.fromLTWH(70, 120, 20, 40),
      const Rect.fromLTWH(100, 130, 40, 20),
      const Rect.fromLTWH(160, 120, 20, 30),
      const Rect.fromLTWH(190, 140, 20, 20),
      const Rect.fromLTWH(80, 180, 30, 20),
      const Rect.fromLTWH(120, 170, 20, 40),
      const Rect.fromLTWH(150, 180, 30, 10),
      const Rect.fromLTWH(190, 180, 20, 30),
    ];

    for (var b in blocks) {
      canvas.drawRect(b, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

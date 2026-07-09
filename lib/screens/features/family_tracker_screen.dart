import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/family_member.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/family_provider.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/verified_badge.dart';
import 'qr_wristband_screen.dart';

class FamilyTrackerScreen extends ConsumerWidget {
  const FamilyTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final familyState = ref.watch(familyProvider);
    final tr = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('family_tracker')),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_rounded),
            tooltip: 'Digital QR Wristband ID',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QrWristbandScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppColors.primaryViolet.withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          familyState.groupName,
                          style: AppTypography.headingMedium(true).copyWith(color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.lock_outline, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Private Group', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Invite Code: ${familyState.inviteCode}',
                    style: AppTypography.bodyBold(true).copyWith(color: AppColors.secondarySaffron, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Auto-expires after Simhastha Kumbh Mela 2027 closing ceremony for privacy.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Group Members (${familyState.members.length})', style: AppTypography.headingSmall(isDark)),
                TextButton.icon(
                  onPressed: () {
                    _showAddMemberModal(context, isDark, ref);
                  },
                  icon: const Icon(Icons.person_add_rounded, size: 18),
                  label: const Text('Invite Member'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Members List
            ...familyState.members.map((member) {
              Color batteryColor = AppColors.successGreen;
              if (member.batteryLevel < 30) {
                batteryColor = AppColors.alertHeavy;
              } else if (member.batteryLevel < 60) {
                batteryColor = AppColors.alertModerate;
              }

              return CustomCard(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    VerifiedAvatar(
                      imageUrl: 'https://i.pravatar.cc/150?u=${member.id}',
                      size: 54,
                      isOnline: member.isOnline,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(member.name.split(' ').first, style: AppTypography.bodyBold(isDark).copyWith(fontSize: 16)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryViolet.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(member.relation, style: const TextStyle(color: AppColors.primaryViolet, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text('Near Ramkund Sector 4', style: AppTypography.caption(isDark)),
                              const SizedBox(width: 10),
                              Text('• ${member.lastUpdatedString}', style: AppTypography.caption(isDark)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.battery_charging_full_rounded, size: 16, color: batteryColor),
                              const SizedBox(width: 4),
                              Text('${member.batteryLevel}% Battery', style: AppTypography.captionBold(isDark).copyWith(color: batteryColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.navigation_rounded, color: AppColors.primaryViolet),
                      tooltip: 'Navigate to member location',
                      onPressed: () {
                        ref.read(appStateProvider.notifier).setNavIndex(1);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Guiding you to ${member.name}... (~350m away)')),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
            GradientButton(
              text: 'View Live Family Pins on Map',
              icon: Icons.map_rounded,
              onPressed: () {
                ref.read(appStateProvider.notifier).setNavIndex(1);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMemberModal(BuildContext context, bool isDark, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Invite Family Member', style: AppTypography.headingMedium(isDark)),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(hintText: 'Member Name (e.g. Priya - Sister)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: '+91 98765 00000'),
              ),
              const SizedBox(height: 24),
              GradientButton(
                text: 'Send Invite SMS / Link',
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty) {
                    ref.read(familyProvider.notifier).addMember(FamilyMember(
                      id: 'fam_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameCtrl.text.trim(),
                      relation: 'Family',
                      phoneNumber: phoneCtrl.text.trim(),
                      latitude: 20.0050,
                      longitude: 73.7890,
                      batteryLevel: 95,
                      lastUpdated: DateTime.now(),
                      qrCodeData: 'KUMBH_ID_${phoneCtrl.text}',
                    ));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Member invited & added to tracker!")));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/verified_badge.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<Map<String, String>> _emergencyContacts = [
    {'name': 'Rajesh Sharma (Brother)', 'phone': '+91 98230 11223'},
    {'name': 'Sunita Sharma (Spouse)', 'phone': '+91 98230 44556'},
  ];

  void _showLanguageModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) {
        final currentLang = ref.watch(appStateProvider).languageCode;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select App Language / भाषा चुनें', style: AppTypography.headingMedium(isDark)),
              const SizedBox(height: 16),
              _buildLangTile('English', 'en', currentLang == 'en', isDark),
              _buildLangTile('हिन्दी (Hindi)', 'hi', currentLang == 'hi', isDark),
              _buildLangTile('मराठी (Marathi)', 'mr', currentLang == 'mr', isDark),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLangTile(String title, String code, bool isSelected, bool isDark) {
    return ListTile(
      title: Text(title, style: AppTypography.bodyBold(isDark)),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryViolet) : null,
      onTap: () {
        ref.read(appStateProvider.notifier).setLanguageCode(code);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Language updated to $title')));
      },
    );
  }

  void _showContactsModal(BuildContext context, bool isDark) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Emergency SOS Guardians', style: AppTypography.headingMedium(isDark)),
                  const SizedBox(height: 4),
                  Text('These contacts receive automated SMS alerts with your GPS coordinates when you trigger SOS.', style: AppTypography.caption(isDark)),
                  const SizedBox(height: 16),
                  ..._emergencyContacts.map((c) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(backgroundColor: AppColors.alertHeavy, child: Icon(Icons.person, color: Colors.white, size: 20)),
                      title: Text(c['name']!, style: AppTypography.bodyBold(isDark)),
                      subtitle: Text(c['phone']!, style: AppTypography.caption(isDark)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.alertHeavy),
                        onPressed: () {
                          setModalState(() {
                            _emergencyContacts.remove(c);
                          });
                          setState(() {});
                        },
                      ),
                    );
                  }),
                  const Divider(height: 24),
                  Text('Add New Guardian', style: AppTypography.bodyBold(isDark)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(hintText: 'Name & Relation (e.g. Amit - Father)'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: '+91 98765 43210'),
                  ),
                  const SizedBox(height: 16),
                  GradientButton(
                    text: 'Add Guardian Contact',
                    onPressed: () {
                      if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
                        setModalState(() {
                          _emergencyContacts.add({'name': nameCtrl.text.trim(), 'phone': phoneCtrl.text.trim()});
                        });
                        setState(() {});
                        nameCtrl.clear();
                        phoneCtrl.clear();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emergency guardian added!')));
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = ref.watch(appStateProvider);
    final userState = ref.watch(authProvider);
    final tr = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('profile')),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 110),
        child: Column(
          children: [
            // Centered Avatar & Verified Status Pill
            Center(
              child: Column(
                children: [
                  VerifiedAvatar(
                    imageUrl: userState.avatarUrl,
                    size: 96,
                    isOnline: true,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    userState.userName,
                    style: AppTypography.headingLarge(isDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userState.phoneNumber.isNotEmpty ? userState.phoneNumber : 'Kumbh Mela 2027 Portal',
                    style: AppTypography.bodyRegular(isDark).copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const VerifiedStatusPill(label: 'Pilgrim Status: Verified Visitor'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Follow / Message Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Connected to Akhara Official Volunteer Guide!")),
                      );
                    },
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                    label: const Text('Follow Guide'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryViolet),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Opening Volunteer Helpdesk Chat...")),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.primaryViolet),
                    label: const Text('Message Help', style: TextStyle(color: AppColors.primaryViolet)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primaryViolet),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Saved Places
            SectionHeader(title: 'Saved / Favorite Places'),
            if (userState.savedPlaces.isEmpty)
              CustomCard(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No saved places yet. Tap the heart icon on any Ghat to save it here.',
                    style: AppTypography.caption(isDark),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...userState.savedPlaces.map((place) {
                return CustomCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  onTap: () {
                    ref.read(appStateProvider.notifier).setNavIndex(1);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.bookmark_rounded, color: AppColors.secondarySaffron, size: 22),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(place, style: AppTypography.bodyBold(isDark)),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 20),
            // App Settings Layer
            SectionHeader(title: tr.translate('settings')),
            CustomCard(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Language Selector
                  ListTile(
                    title: Text('Language / भाषा / भाषा', style: AppTypography.bodyMedium(isDark)),
                    subtitle: Text(
                      appState.languageCode == 'hi' ? 'हिन्दी (Hindi)' : (appState.languageCode == 'mr' ? 'मराठी (Marathi)' : 'English'),
                      style: AppTypography.captionBold(isDark).copyWith(color: AppColors.primaryViolet),
                    ),
                    leading: const Icon(Icons.language_rounded, color: AppColors.primaryViolet),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () => _showLanguageModal(context, isDark),
                  ),
                  Divider(color: Colors.grey.withValues(alpha: 0.2), height: 1),
                  // Dark Mode Toggle
                  SwitchListTile(
                    title: Text(tr.translate('dark_mode'), style: AppTypography.bodyMedium(isDark)),
                    secondary: const Icon(Icons.dark_mode_rounded, color: AppColors.primaryViolet),
                    value: appState.themeMode == AppThemeMode.dark,
                    activeThumbColor: AppColors.primaryViolet,
                    onChanged: (_) => ref.read(appStateProvider.notifier).toggleDarkMode(),
                  ),
                  Divider(color: Colors.grey.withValues(alpha: 0.2), height: 1),
                  // Accessibility Mode Toggle
                  SwitchListTile(
                    title: Text(tr.translate('accessibility_mode'), style: AppTypography.bodyMedium(isDark)),
                    secondary: const Icon(Icons.accessibility_new_rounded, color: AppColors.secondarySaffron),
                    value: appState.themeMode == AppThemeMode.accessibility,
                    activeThumbColor: AppColors.secondarySaffron,
                    onChanged: (_) => ref.read(appStateProvider.notifier).toggleAccessibilityMode(),
                  ),
                  Divider(color: Colors.grey.withValues(alpha: 0.2), height: 1),
                  // Offline Mode Toggle
                  SwitchListTile(
                    title: Text(tr.translate('offline_mode'), style: AppTypography.bodyMedium(isDark)),
                    subtitle: Text(
                      appState.isOfflineMode ? 'Cached maps & schedules active' : 'Download 45MB local Kumbh data',
                      style: AppTypography.caption(isDark),
                    ),
                    secondary: const Icon(Icons.offline_pin_rounded, color: AppColors.successGreen),
                    value: appState.isOfflineMode,
                    activeThumbColor: AppColors.successGreen,
                    onChanged: (_) => ref.read(appStateProvider.notifier).toggleOfflineMode(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Emergency Contacts Manager
            CustomCard(
              onTap: () => _showContactsModal(context, isDark),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.contact_phone_rounded, color: Color(0xFF2F80ED), size: 24),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr.translate('emergency_contacts'), style: AppTypography.bodyBold(isDark)),
                        Text('${_emergencyContacts.length} Guardians Linked for SOS Auto-Broadcast', style: AppTypography.caption(isDark)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Trip History
            CustomCard(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Trip History: Ramkund Ghat (Yesterday), Kushavarta (2 days ago)")),
                );
              },
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.history_rounded, color: AppColors.primaryViolet, size: 24),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr.translate('trip_history'), style: AppTypography.bodyBold(isDark)),
                        Text('12 sacred spots visited during Kumbh', style: AppTypography.caption(isDark)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Logout Button
            CustomCard(
              onTap: () {
                ref.read(authProvider.notifier).logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.alertHeavy.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.alertHeavy.withValues(alpha: 0.4)),
              child: Center(
                child: Text(
                  tr.translate('logout'),
                  style: AppTypography.bodyBold(isDark).copyWith(color: AppColors.alertHeavy),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

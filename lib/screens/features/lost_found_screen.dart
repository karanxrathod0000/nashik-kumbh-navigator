import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/lost_person.dart';
import '../../providers/lost_found_provider.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/verified_badge.dart';
import 'volunteer_chat_screen.dart';

class LostFoundScreen extends ConsumerWidget {
  const LostFoundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredItems = ref.watch(filteredLostFoundProvider);
    final tr = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('lost_found')),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent_rounded),
            tooltip: 'Connect to Volunteer Helpdesk',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VolunteerChatScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs: All | Missing | Found
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                _buildFilterTab(ref, 'All Reports', null, isDark),
                const SizedBox(width: 8),
                _buildFilterTab(ref, 'Missing Persons', true, isDark),
                const SizedBox(width: 8),
                _buildFilterTab(ref, 'Found at Camp', false, isDark),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 90),
              itemCount: filteredItems.length,
              itemBuilder: (context, idx) {
                final item = filteredItems[idx];
                final isMissing = item.type == ReportType.lostPerson;
                final title = item.getLocalizedTitle(tr.languageCode);
                return CustomCard(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerifiedAvatar(
                        imageUrl: item.photoUrl ?? 'https://i.pravatar.cc/150?u=${item.id}',
                        size: 70,
                        isOnline: false,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (isMissing ? AppColors.alertHeavy : AppColors.successGreen).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    isMissing ? 'MISSING' : 'FOUND AT HELPDESK',
                                    style: TextStyle(
                                      color: isMissing ? AppColors.alertHeavy : AppColors.successGreen,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(item.timeAgo, style: AppTypography.captionBold(isDark)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(title, style: AppTypography.headingSmall(isDark)),
                            const SizedBox(height: 4),
                            Text(
                              'Last seen: ${item.lastSeenLocation}',
                              style: AppTypography.caption(isDark).copyWith(color: AppColors.primaryViolet, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: AppTypography.caption(isDark).copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Contact: ${item.contactPhone}', style: AppTypography.captionBold(isDark)),
                                ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Calling reporter at ${item.contactPhone}...')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryViolet,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(60, 30),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  ),
                                  child: const Text('Call Now', style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showReportModal(context, isDark, ref),
        backgroundColor: AppColors.secondarySaffron,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alert_rounded),
        label: const Text('Report Missing Person / Item', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFilterTab(WidgetRef ref, String label, bool? isMissing, bool isDark) {
    final targetType = isMissing == null ? null : (isMissing ? ReportType.lostPerson : ReportType.foundItem);
    final isSelected = ref.watch(lostFoundProvider).filterType == targetType;
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(lostFoundProvider.notifier).setFilterType(targetType),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryViolet : (isDark ? AppColors.surfaceDark : Colors.grey.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(50),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.captionBold(isDark).copyWith(
              color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  void _showReportModal(BuildContext context, bool isDark, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    bool isMissingReport = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Submit Report to Kumbh Control Room', style: AppTypography.headingMedium(isDark)),
                    const SizedBox(height: 16),
                    RadioGroup<bool>(
                      groupValue: isMissingReport,
                      onChanged: (val) => setModalState(() => isMissingReport = val!),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Missing'),
                              value: true,
                              activeColor: AppColors.alertHeavy,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Found'),
                              value: false,
                              activeColor: AppColors.successGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Person Name / Item Name')),
                    const SizedBox(height: 10),
                    TextField(controller: ageCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Age (approx)')),
                    const SizedBox(height: 10),
                    TextField(controller: locCtrl, decoration: const InputDecoration(hintText: 'Last Seen / Found Location (e.g. Ramkund Gate 1)')),
                    const SizedBox(height: 10),
                    TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(hintText: 'Description (Clothing color, height, language spoken)')),
                    const SizedBox(height: 10),
                    TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: 'Your Contact Phone Number')),
                    const SizedBox(height: 24),
                    GradientButton(
                      text: 'Submit & Broadcast to Volunteers',
                      isSaffron: true,
                      onPressed: () {
                        if (nameCtrl.text.isNotEmpty && locCtrl.text.isNotEmpty) {
                          ref.read(lostFoundProvider.notifier).reportNewItem(LostPersonItem(
                            id: 'lf_${DateTime.now().millisecondsSinceEpoch}',
                            type: isMissingReport ? ReportType.lostPerson : ReportType.foundItem,
                            titleEn: nameCtrl.text.trim(),
                            titleHi: nameCtrl.text.trim(),
                            titleMr: nameCtrl.text.trim(),
                            description: descCtrl.text.trim(),
                            contactName: 'Pilgrim Reporter',
                            contactPhone: phoneCtrl.text.trim(),
                            lastSeenLocation: locCtrl.text.trim(),
                            timestamp: DateTime.now(),
                            photoUrl: 'https://i.pravatar.cc/150?u=${nameCtrl.text}',
                          ));
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report broadcasted to Police & Helpdesks!')));
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

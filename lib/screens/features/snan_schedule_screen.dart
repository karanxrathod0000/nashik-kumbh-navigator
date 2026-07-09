import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/custom_card.dart';

class SnanScheduleScreen extends ConsumerStatefulWidget {
  const SnanScheduleScreen({super.key});

  @override
  ConsumerState<SnanScheduleScreen> createState() => _SnanScheduleScreenState();
}

class _SnanScheduleScreenState extends ConsumerState<SnanScheduleScreen> {
  final Set<int> _reminders = {};

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final tr = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('snan_schedule')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.saffronGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppColors.secondarySaffron.withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 6)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 48),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Simhastha Kumbh Mela 2027',
                          style: AppTypography.headingMedium(true).copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Official Royal Bathing (Shahi Snan) astrological timetable and crowd density projections.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Auspicious Bathing Calendar', style: AppTypography.headingSmall(isDark)),
            const SizedBox(height: 12),
            ...List.generate(AppConstants.shahiSnanDates.length, (idx) {
              final item = AppConstants.shahiSnanDates[idx];
              final date = item['date'] as DateTime;
              final isReminderSet = _reminders.contains(idx);

              return CustomCard(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryViolet.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            '${date.day}/${date.month}/${date.year}',
                            style: AppTypography.captionBold(isDark).copyWith(color: AppColors.primaryViolet, fontSize: 13),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.alertHeavy.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            item['expectedCrowd'] as String,
                            style: TextStyle(color: AppColors.alertHeavy, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['title'] as String,
                      style: AppTypography.headingSmall(isDark),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['significance'] as String,
                      style: AppTypography.bodyRegular(isDark).copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              if (isReminderSet) {
                                _reminders.remove(idx);
                              } else {
                                _reminders.add(idx);
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isReminderSet
                                    ? 'Reminder removed.'
                                    : 'Reminder set for 24h before Shahi Snan!'),
                                backgroundColor: AppColors.primaryViolet,
                              ),
                            );
                          },
                          icon: Icon(
                            isReminderSet ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                            color: isReminderSet ? AppColors.secondarySaffron : AppColors.primaryViolet,
                          ),
                          label: Text(
                            isReminderSet ? 'Reminder Active' : 'Set Reminder',
                            style: TextStyle(color: isReminderSet ? AppColors.secondarySaffron : AppColors.primaryViolet),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

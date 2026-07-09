import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/ghat_location.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/badges/severity_tag.dart';

class CrowdPredictionScreen extends ConsumerStatefulWidget {
  const CrowdPredictionScreen({super.key});

  @override
  ConsumerState<CrowdPredictionScreen> createState() => _CrowdPredictionScreenState();
}

class _CrowdPredictionScreenState extends ConsumerState<CrowdPredictionScreen> {
  String _selectedTimeSlot = '06:00 - 09:00 AM (Sunrise Snan)';

  final List<String> _timeSlots = [
    '03:00 - 06:00 AM (Brahma Muhurta)',
    '06:00 - 09:00 AM (Sunrise Snan)',
    '09:00 - 12:00 PM (Midday Rush)',
    '12:00 - 04:00 PM (Afternoon Calm)',
    '04:00 - 08:00 PM (Evening Aarti Rush)',
  ];

  final List<Map<String, dynamic>> _predictions = [
    {'ghat': 'Ramkund Holy Ghat', 'density': CrowdDensity.heavy, 'score': '94%', 'advice': 'Extreme surge. Entry Gates 1 & 2 closed for safety. Diverted to Tapovan.'},
    {'ghat': 'Kushavarta Tirth (Tryambak)', 'density': CrowdDensity.moderate, 'score': '68%', 'advice': 'Moderate wait times (~25 mins). Recommended for elderly.'},
    {'ghat': 'Godavari North Bank', 'density': CrowdDensity.light, 'score': '32%', 'advice': 'Clear access. Ample space for bathing and rituals.'},
    {'ghat': 'Tapovan Sector Ghats', 'density': CrowdDensity.light, 'score': '24%', 'advice': 'Best alternate recommendation. Special facilities for families.'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final tr = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('crowd_prediction')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppColors.primaryViolet.withValues(alpha: 0.3), blurRadius: 12)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.psychology_rounded, color: Colors.white, size: 48),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Predictive Analytics',
                          style: AppTypography.headingMedium(true).copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Powered by historical Kumbh arrival models and live IoT camera feed projections.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Select Time Slot', style: AppTypography.headingSmall(isDark)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _timeSlots.map((slot) {
                  final isSelected = _selectedTimeSlot == slot;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(slot.split(' (').first),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedTimeSlot = slot),
                      selectedColor: AppColors.secondarySaffron,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87), fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Forecast for: $_selectedTimeSlot', style: AppTypography.bodyBold(isDark).copyWith(color: AppColors.secondarySaffron)),
            const SizedBox(height: 12),
            ..._predictions.map((item) {
              final density = item['density'] as CrowdDensity;
              Color borderCol = AppColors.successGreen;
              if (density == CrowdDensity.heavy) {
                borderCol = AppColors.alertHeavy;
              } else if (density == CrowdDensity.moderate) {
                borderCol = AppColors.alertModerate;
              }

              return CustomCard(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                border: Border.all(color: borderCol.withValues(alpha: 0.5), width: 1.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(item['ghat'] as String, style: AppTypography.headingSmall(isDark))),
                        SeverityTag(crowdDensity: density),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Projected Density: ', style: AppTypography.caption(isDark)),
                        Text(item['score'] as String, style: AppTypography.bodyBold(isDark).copyWith(color: borderCol)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: borderCol.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 18, color: borderCol),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item['advice'] as String,
                              style: TextStyle(color: borderCol, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
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

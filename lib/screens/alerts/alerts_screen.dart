import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/alert_item.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/alerts_provider.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/badges/severity_tag.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final alertsState = ref.watch(alertsProvider);
    final alertsList = ref.watch(filteredAlertsProvider);
    final tr = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('alerts')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(alertsProvider.notifier).refreshAlerts(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Category & Severity Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _buildSeverityChip(ref, 'All Severities', null, isDark),
                _buildSeverityChip(ref, 'High / Closed', AlertSeverity.heavy, isDark),
                _buildSeverityChip(ref, 'Moderate Warning', AlertSeverity.moderate, isDark),
                _buildSeverityChip(ref, 'Normal / Clear', AlertSeverity.light, isDark),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                _buildCategoryChip(ref, 'All Categories', null, isDark),
                _buildCategoryChip(ref, 'Crowd Density', AlertCategory.crowd, isDark),
                _buildCategoryChip(ref, 'Route Closures', AlertCategory.route, isDark),
                _buildCategoryChip(ref, 'Weather Advisory', AlertCategory.weather, isDark),
                _buildCategoryChip(ref, 'Emergency', AlertCategory.emergency, isDark),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // List of Alerts
          Expanded(
            child: alertsState.isRefreshing
                ? const Center(child: CircularProgressIndicator())
                : alertsList.isEmpty
                    ? Center(
                        child: Text(
                          'No alerts matching current filter.',
                          style: AppTypography.bodyRegular(isDark),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => ref.read(alertsProvider.notifier).refreshAlerts(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 110),
                          itemCount: alertsList.length,
                          itemBuilder: (context, idx) {
                            final alert = alertsList[idx];
                            return _buildAlertDetailCard(context, alert, isDark, ref);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityChip(WidgetRef ref, String label, AlertSeverity? severity, bool isDark) {
    final isSelected = ref.watch(alertsProvider).filterSeverity == severity;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: AppTypography.captionBold(isDark).copyWith(
          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        selectedColor: AppColors.primaryViolet,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onSelected: (_) => ref.read(alertsProvider.notifier).setSeverityFilter(severity),
      ),
    );
  }

  Widget _buildCategoryChip(WidgetRef ref, String label, AlertCategory? category, bool isDark) {
    final isSelected = ref.watch(alertsProvider).filterCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: AppTypography.captionBold(isDark).copyWith(
          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        selectedColor: AppColors.secondarySaffron,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onSelected: (_) => ref.read(alertsProvider.notifier).setCategoryFilter(category),
      ),
    );
  }

  Widget _buildAlertDetailCard(BuildContext context, AlertItem alert, bool isDark, WidgetRef ref) {
    final lang = ref.watch(appStateProvider).languageCode;
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield_rounded, color: AppColors.infoSkyBlue, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    alert.authorityName,
                    style: AppTypography.captionBold(isDark).copyWith(
                      color: AppColors.infoSkyBlue,
                    ),
                  ),
                  if (alert.isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: AppColors.infoSkyBlue, size: 14),
                  ],
                ],
              ),
              Text(alert.timeAgo, style: AppTypography.caption(isDark)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  alert.getLocalizedTitle(lang),
                  style: AppTypography.headingSmall(isDark),
                ),
              ),
              const SizedBox(width: 8),
              SeverityTag(alertSeverity: alert.severity),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            alert.getLocalizedDescription(lang),
            style: AppTypography.bodyRegular(isDark).copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.remove_red_eye_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${alert.viewCount}', style: AppTypography.caption(isDark)),
                  const SizedBox(width: 16),
                  const Icon(Icons.thumb_up_alt_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${alert.likeCount}', style: AppTypography.caption(isDark)),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Alert link copied to clipboard for sharing.')),
                  );
                },
                icon: const Icon(Icons.share_outlined, size: 16),
                label: const Text('Share Alert'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

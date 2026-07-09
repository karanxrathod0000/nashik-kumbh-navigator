import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/alert_item.dart';
import '../../models/ghat_location.dart';

class SeverityTag extends StatelessWidget {
  final AlertSeverity? alertSeverity;
  final CrowdDensity? crowdDensity;
  final String? customText;

  const SeverityTag({
    super.key,
    this.alertSeverity,
    this.crowdDensity,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = AppColors.successGreen;
    IconData icon = Icons.check_circle_outline;
    String label = 'Normal';

    if (alertSeverity != null) {
      switch (alertSeverity!) {
        case AlertSeverity.light:
          bgColor = AppColors.successGreen;
          icon = Icons.info_outline;
          label = 'Normal / Clear';
          break;
        case AlertSeverity.moderate:
          bgColor = AppColors.alertModerate;
          icon = Icons.warning_amber_rounded;
          label = 'Moderate Warning';
          break;
        case AlertSeverity.heavy:
          bgColor = AppColors.alertHeavy;
          icon = Icons.error_outline_rounded;
          label = 'High Severity / Closure';
          break;
      }
    } else if (crowdDensity != null) {
      switch (crowdDensity!) {
        case CrowdDensity.light:
          bgColor = AppColors.successGreen;
          icon = Icons.people_outline;
          label = 'Light Crowd';
          break;
        case CrowdDensity.moderate:
          bgColor = AppColors.alertModerate;
          icon = Icons.groups_outlined;
          label = 'Moderate Crowd';
          break;
        case CrowdDensity.heavy:
          bgColor = AppColors.alertHeavy;
          icon = Icons.campaign_outlined;
          label = 'Heavy Crowd (Avoid)';
          break;
      }
    }

    if (customText != null) label = customText!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: bgColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: bgColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.captionBold(false).copyWith(
              color: bgColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

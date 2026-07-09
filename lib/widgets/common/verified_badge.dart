import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class VerifiedAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isOnline;

  const VerifiedAvatar({
    super.key,
    required this.imageUrl,
    this.size = 50.0,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryViolet.withValues(alpha: 0.2), width: 2),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              onError: (err, stack) {},
            ),
          ),
          child: imageUrl.isEmpty || imageUrl.contains('pravatar')
              ? Center(
                  child: Icon(
                    Icons.person,
                    size: size * 0.6,
                    color: AppColors.primaryViolet,
                  ),
                )
              : null,
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: AppColors.successGreen,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

class VerifiedStatusPill extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const VerifiedStatusPill({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? AppColors.infoSkyBlue.withValues(alpha: 0.2) : AppColors.infoSkyBlue.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: AppColors.infoSkyBlue.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified, color: AppColors.infoSkyBlue, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.captionBold(isDark).copyWith(
              color: textColor ?? AppColors.infoSkyBlue,
            ),
          ),
        ],
      ),
    );
  }
}

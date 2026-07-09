import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'reusable_ui_components.dart';

class ShimmerCard extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerCard({
    super.key,
    this.height = 120,
    this.width = double.infinity,
    this.borderRadius = 20,
  });

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _colorAnim = ColorTween(
      begin: Colors.grey.withValues(alpha: 0.15),
      end: Colors.grey.withValues(alpha: 0.35),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnim,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: _colorAnim.value,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

class ErrorRetryCard extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const ErrorRetryCard({
    super.key,
    this.title = 'Oops! Something went wrong',
    this.message = 'Could not load live data. Please check your network connection.',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.alertHeavy.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.alertHeavy.withValues(alpha: 0.4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, color: AppColors.alertHeavy, size: 40),
          const SizedBox(height: 12),
          Text(title, style: AppTypography.headingSmall(isDark).copyWith(color: AppColors.alertHeavy)),
          const SizedBox(height: 6),
          Text(message, style: AppTypography.caption(isDark), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          PillButton(
            text: 'Retry Connection',
            icon: Icons.refresh_rounded,
            onPressed: onRetry,
            backgroundColor: AppColors.alertHeavy,
          ),
        ],
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyStateCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(28),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryViolet.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryViolet, size: 48),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTypography.headingMedium(isDark), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(subtitle, style: AppTypography.bodyRegular(isDark).copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/ghat_location.dart';

class PillButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;

  const PillButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isFullWidth = true,
    this.padding,
  });

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 0.96);
  void _onTapUp(TapUpDetails details) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? AppColors.primaryViolet;
    final fg = widget.textColor ?? Colors.white;

    Widget child = Container(
      width: widget.isFullWidth ? double.infinity : null,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: bg.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, color: fg, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            widget.text,
            style: AppTypography.buttonText().copyWith(color: fg),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: child,
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final String? emoji;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const CategoryChip({
    super.key,
    required this.label,
    this.emoji,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isSelected
        ? AppColors.primaryViolet
        : (backgroundColor ?? (isDark ? AppColors.surfaceDark : Colors.white));
    final Color fg = isSelected ? Colors.white : (isDark ? Colors.white : AppColors.textPrimary);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primaryViolet.withValues(alpha: 0.35)
                        : const Color(0x0F000000),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: isSelected ? null : Border.all(color: Colors.grey.withValues(alpha: 0.15), width: 1),
              ),
              alignment: Alignment.center,
              child: emoji != null
                  ? Text(emoji!, style: const TextStyle(fontSize: 26))
                  : Icon(icon ?? Icons.place, color: fg, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.captionBold(isDark).copyWith(
                color: isSelected ? AppColors.primaryViolet : (isDark ? Colors.white70 : AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusTagBadge extends StatelessWidget {
  final CrowdDensity density;

  const StatusTagBadge({super.key, required this.density});

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    String label;
    switch (density) {
      case CrowdDensity.light:
        dotColor = AppColors.successGreen;
        label = 'Low';
        break;
      case CrowdDensity.moderate:
        dotColor = AppColors.alertModerate;
        label = 'Moderate';
        break;
      case CrowdDensity.heavy:
        dotColor = AppColors.alertHeavy;
        label = 'High';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: dotColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: dotColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendedCard extends StatefulWidget {
  final GhatLocation ghat;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const RecommendedCard({
    super.key,
    required this.ghat,
    required this.onTap,
    this.isFavorite = false,
    required this.onFavoriteToggle,
  });

  @override
  State<RecommendedCard> createState() => _RecommendedCardState();
}

class _RecommendedCardState extends State<RecommendedCard> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Illustration Banner area
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.pastelSkyBlue.withValues(alpha: 0.8),
                        AppColors.riverBlue.withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.water_rounded, size: 48, color: Colors.white),
                ),
                // Favorite Heart icon top-right
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: widget.onFavoriteToggle,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: widget.isFavorite ? AppColors.coralHeart : Colors.grey[400],
                        size: 18,
                      ),
                    ),
                  ),
                ),
                // Crowd Status pill badge bottom-left
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: StatusTagBadge(density: widget.ghat.currentDensity),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ghat.nameEn,
                    style: AppTypography.headingSmall(isDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Nashik, Godavari Bank',
                          style: AppTypography.caption(isDark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatColumnRow extends StatelessWidget {
  final String distance;
  final String weather;
  final String aartiTime;

  const StatColumnRow({
    super.key,
    required this.distance,
    required this.weather,
    required this.aartiTime,
  });

  Widget _buildColumn(BuildContext context, IconData icon, String value, String label, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryViolet, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.headingSmall(isDark).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.caption(isDark).copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 20, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          _buildColumn(context, Icons.directions_walk_rounded, distance, 'Distance', isDark),
          Container(width: 1, height: 40, color: Colors.grey.withValues(alpha: 0.2)),
          _buildColumn(context, Icons.wb_sunny_rounded, weather, 'Weather', isDark),
          Container(width: 1, height: 40, color: Colors.grey.withValues(alpha: 0.2)),
          _buildColumn(context, Icons.access_time_rounded, aartiTime, 'Aarti Time', isDark),
        ],
      ),
    );
  }
}

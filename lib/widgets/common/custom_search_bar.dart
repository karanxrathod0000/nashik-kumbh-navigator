import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onGoPressed;
  final TextEditingController? controller;
  final String buttonText;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onGoPressed,
    this.controller,
    this.buttonText = 'Go',
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 14.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTypography.bodyRegular(isDark),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTypography.bodyRegular(isDark).copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                filled: false,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.navBarNavy,
            borderRadius: BorderRadius.circular(50.0),
            child: InkWell(
              onTap: onGoPressed,
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  buttonText,
                  style: AppTypography.buttonText().copyWith(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSaffron;
  final IconData? icon;
  final bool isFullWidth;
  final double height;
  final EdgeInsetsGeometry? padding;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSaffron = false,
    this.icon,
    this.isFullWidth = true,
    this.height = 54.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = isSaffron ? AppColors.saffronGradient : AppColors.primaryGradient;

    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
        ],
        Text(
          text,
          style: AppTypography.buttonText(),
        ),
      ],
    );

    return Container(
      width: isFullWidth ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        gradient: onPressed == null
            ? const LinearGradient(colors: [Colors.grey, Colors.blueGrey])
            : gradient,
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: onPressed == null
            ? null
            : [
                BoxShadow(
                  color: (isSaffron ? AppColors.secondarySaffron : AppColors.primaryViolet).withValues(alpha: 0.35),
                  blurRadius: 14.0,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50.0),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(child: buttonContent),
          ),
        ),
      ),
    );
  }
}

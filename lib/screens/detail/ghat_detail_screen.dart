import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/ghat_location.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/map_provider.dart';
import '../../widgets/common/reusable_ui_components.dart';
import '../map/route_planner_screen.dart';

class GhatDetailScreen extends ConsumerStatefulWidget {
  final GhatLocation ghat;

  const GhatDetailScreen({super.key, required this.ghat});

  @override
  ConsumerState<GhatDetailScreen> createState() => _GhatDetailScreenState();
}

class _GhatDetailScreenState extends ConsumerState<GhatDetailScreen> {
  void _startJourney() {
    ref.read(mapProvider.notifier).selectLocation(widget.ghat);
    ref.read(mapProvider.notifier).startRouteNavigation();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoutePlannerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = ref.watch(appStateProvider);
    final userState = ref.watch(authProvider);
    final desc = widget.ghat.getLocalizedDescription(appState.languageCode);
    final name = widget.ghat.getLocalizedName(appState.languageCode);

    final isFav = userState.savedPlaces.contains(widget.ghat.id);
    final distStr = '${(widget.ghat.distanceMeters / 1000).toStringAsFixed(1)} km';

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Illustration Banner
                Stack(
                  children: [
                    Container(
                      height: 280,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.pastelSkyBlue,
                            AppColors.riverBlue.withValues(alpha: 0.8),
                            isDark ? AppColors.surfaceDark : Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.7, 1.0],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.temple_hindu_rounded, size: 80, color: Colors.white),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Text(
                              "🌅 Sunrise Darshan • Godavari River",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Top App Bar Controls
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
                              ),
                            ),
                            // Favorite Button
                            GestureDetector(
                              onTap: () {
                                ref.read(authProvider.notifier).addSavedPlace(widget.ghat.id, placeName: widget.ghat.nameEn);
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: isFav ? AppColors.coralHeart : AppColors.textPrimary,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Main Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: AppTypography.screenTitle(isDark),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded, size: 16, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Nashik, Godavari Bank',
                                      style: AppTypography.caption(isDark).copyWith(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          StatusTagBadge(density: widget.ghat.currentDensity),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // 3-Column Stats Row
                      StatColumnRow(
                        distance: distStr,
                        weather: '28°C Sunny',
                        aartiTime: '06:30 PM',
                      ),
                      const SizedBox(height: 28),
                      // Description Section Header
                      Text(
                        'Sacred Significance',
                        style: AppTypography.sectionHeader(isDark),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        desc,
                        style: AppTypography.bodyRegular(isDark).copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Available Facilities Section
                      Text(
                        'Available Facilities',
                        style: AppTypography.sectionHeader(isDark),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.ghat.facilities.map((fac) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.successGreen),
                                const SizedBox(width: 6),
                                Text(
                                  fac,
                                  style: AppTypography.captionBold(isDark).copyWith(
                                    color: isDark ? Colors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),
                      // Photo Gallery Thumbnail Row
                      Text(
                        'Live Ghat Gallery',
                        style: AppTypography.sectionHeader(isDark),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 90,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildGalleryThumb(Icons.wb_sunny_rounded, "Sunrise Aarti", AppColors.pastelWarmSand),
                            _buildGalleryThumb(Icons.water_drop_rounded, "Holy Dip Area", AppColors.pastelSkyBlue),
                            _buildGalleryThumb(Icons.temple_hindu_rounded, "Ancient Shrine", AppColors.pastelSoftCoral),
                            _buildGalleryThumb(Icons.nightlight_round, "Evening Diya", AppColors.pastelForestGreen),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Sticky CTA Pill Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 28),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: PillButton(
                      text: 'Start Journey',
                      icon: Icons.navigation_rounded,
                      backgroundColor: AppColors.secondarySaffron,
                      onPressed: _startJourney,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(color: Color(0x0F000000), blurRadius: 14),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share_rounded, color: AppColors.primaryViolet),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sharing location link...')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryThumb(IconData icon, String label, Color bg) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bg, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: bg.withValues(alpha: 1.0), size: 30),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

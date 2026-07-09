import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/constants/app_constants.dart';
import '../../models/alert_item.dart';
import '../../models/ghat_location.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/alerts_provider.dart';
import '../../providers/map_provider.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/custom_search_bar.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/nav/bottom_nav_bar.dart';
import '../../widgets/badges/severity_tag.dart';
import '../map/interactive_map_screen.dart';
import '../map/route_planner_screen.dart';
import '../alerts/alerts_screen.dart';
import '../profile/profile_screen.dart';
import '../sos/emergency_sos_screen.dart';
import '../features/lost_found_screen.dart';
import '../features/snan_schedule_screen.dart';
import '../features/family_tracker_screen.dart';
import '../../widgets/common/reusable_ui_components.dart';
import '../detail/ghat_detail_screen.dart';

class HomeDashboard extends ConsumerStatefulWidget {
  const HomeDashboard({super.key});

  @override
  ConsumerState<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends ConsumerState<HomeDashboard> {
  Timer? _countdownTimer;
  Duration _timeLeft = const Duration(days: 410, hours: 6, minutes: 14);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    final target = AppConstants.shahiSnanDates.first['date'] as DateTime;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (target.isAfter(now)) {
        if (mounted) {
          setState(() {
            _timeLeft = target.difference(now);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _onTabSelected(int idx) {
    ref.read(appStateProvider.notifier).setNavIndex(idx);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = ref.watch(appStateProvider);
    final userState = ref.watch(authProvider);
    final alertsList = ref.watch(filteredAlertsProvider);
    final filteredLocations = ref.watch(filteredLocationsProvider);
    final mapState = ref.watch(mapProvider);
    final tr = AppLocalizations.of(context);

    // If bottom nav index is not 0, show the corresponding screen
    if (appState.currentNavIndex == 1) {
      return Scaffold(
        body: const InteractiveMapScreen(),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 1,
          onTabSelected: _onTabSelected,
          labels: [tr.translate('home'), tr.translate('map'), tr.translate('alerts'), tr.translate('profile')],
        ),
      );
    } else if (appState.currentNavIndex == 2) {
      return Scaffold(
        body: const AlertsScreen(),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 2,
          onTabSelected: _onTabSelected,
          labels: [tr.translate('home'), tr.translate('map'), tr.translate('alerts'), tr.translate('profile')],
        ),
      );
    } else if (appState.currentNavIndex == 3) {
      return Scaffold(
        body: const ProfileScreen(),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 3,
          onTabSelected: _onTabSelected,
          labels: [tr.translate('home'), tr.translate('map'), tr.translate('alerts'), tr.translate('profile')],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await ref.read(alertsProvider.notifier).refreshAlerts();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar: Menu + Location Pill + Notifications
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 10)],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.menu_rounded),
                            onPressed: () => _showAllFeaturesModal(context, isDark),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 10)],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: AppColors.primaryViolet, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                "Nashik, Ramkund Area",
                                style: AppTypography.captionBold(isDark).copyWith(color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 10)],
                          ),
                          child: IconButton(
                            icon: const Badge(
                              label: Text('3'),
                              backgroundColor: AppColors.alertHeavy,
                              child: Icon(Icons.notifications_none_rounded),
                            ),
                            onPressed: () => _onTabSelected(2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Large Title & Live Status
                    Text(
                      "Kumbh Navigator",
                      style: AppTypography.onboardingHeadline(isDark).copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: AppColors.successGreen, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Low crowd right now • ${TimeOfDay.now().format(context)}",
                          style: AppTypography.caption(isDark).copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    CustomSearchBar(
                      hintText: tr.translate('search_hint'),
                      buttonText: tr.translate('go'),
                      onChanged: (val) {
                        ref.read(mapProvider.notifier).setSearchQuery(val);
                      },
                      onGoPressed: () {
                        _onTabSelected(1); // Switch to map tab
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Browse by Activity",
                      style: AppTypography.sectionHeader(isDark),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 94,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        children: [
                          CategoryChip(
                            label: "Ghats",
                            emoji: "🛕",
                            isSelected: mapState.selectedCategory == LocationCategory.ghat,
                            onTap: () => ref.read(mapProvider.notifier).selectCategory(LocationCategory.ghat),
                          ),
                          CategoryChip(
                            label: "Parking",
                            emoji: "🅿️",
                            isSelected: mapState.selectedCategory == LocationCategory.parking,
                            onTap: () => ref.read(mapProvider.notifier).selectCategory(LocationCategory.parking),
                          ),
                          CategoryChip(
                            label: "Camps",
                            emoji: "🏕️",
                            isSelected: mapState.selectedCategory == null, // default / camps
                            onTap: () => ref.read(mapProvider.notifier).selectCategory(null),
                          ),
                          CategoryChip(
                            label: "Medical",
                            emoji: "🚑",
                            isSelected: mapState.selectedCategory == LocationCategory.medical,
                            onTap: () => ref.read(mapProvider.notifier).selectCategory(LocationCategory.medical),
                          ),
                          CategoryChip(
                            label: "Police",
                            emoji: "🚓",
                            isSelected: mapState.selectedCategory == LocationCategory.police,
                            onTap: () => ref.read(mapProvider.notifier).selectCategory(LocationCategory.police),
                          ),
                          CategoryChip(
                            label: "Toilets",
                            emoji: "🚻",
                            isSelected: mapState.selectedCategory == LocationCategory.toilet,
                            onTap: () => ref.read(mapProvider.notifier).selectCategory(LocationCategory.toilet),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Popular Ghats Today
                    SectionHeader(
                      title: "Popular Ghats Today",
                      actionText: "See all (${filteredLocations.length}) ›",
                      onActionTap: () => _onTabSelected(1), // switch to map
                    ),
                    const SizedBox(height: 14),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.82,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: filteredLocations.take(4).length,
                      itemBuilder: (context, idx) {
                        final ghat = filteredLocations[idx];
                        final isFav = userState.savedPlaces.contains(ghat.id);
                        return RecommendedCard(
                          ghat: ghat,
                          isFavorite: isFav,
                          onFavoriteToggle: () {
                            ref.read(authProvider.notifier).addSavedPlace(ghat.id, placeName: ghat.nameEn);
                          },
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => GhatDetailScreen(ghat: ghat)),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Shahi Snan Countdown Banner
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SnanScheduleScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: AppColors.saffronGradient,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondarySaffron.withValues(alpha: 0.3),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      tr.translate('shahi_snan_countdown'),
                                      style: AppTypography.captionBold(true).copyWith(color: Colors.white70),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '1st Royal Bath: Ramkund',
                                  style: AppTypography.headingSmall(true).copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _buildTimeBox('${_timeLeft.inDays}', tr.translate('days')),
                                const SizedBox(width: 6),
                                _buildTimeBox('${_timeLeft.inHours % 24}', tr.translate('hours')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Quick Access Grid Header
                    SectionHeader(
                      title: 'Quick Access Tools',
                      actionText: 'All Features →',
                      onActionTap: () {
                        _showAllFeaturesModal(context, isDark);
                      },
                    ),
                    // Quick Access 2x2 Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickTile(
                            context,
                            title: tr.translate('live_map'),
                            subtitle: 'Crowd Heatmaps',
                            icon: Icons.map_rounded,
                            gradient: AppColors.primaryGradient,
                            onTap: () => _onTabSelected(1),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildQuickTile(
                            context,
                            title: tr.translate('emergency_sos'),
                            subtitle: 'Instant Help 108',
                            icon: Icons.sos_rounded,
                            gradient: const LinearGradient(colors: [Color(0xFFE74C3C), Color(0xFFC0392B)]),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencySosScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickTile(
                            context,
                            title: tr.translate('lost_found'),
                            subtitle: 'Missing Persons',
                            icon: Icons.person_search_rounded,
                            gradient: const LinearGradient(colors: [Color(0xFF2F80ED), Color(0xFF1B62CD)]),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LostFoundScreen()));
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildQuickTile(
                            context,
                            title: tr.translate('route_planner'),
                            subtitle: 'Avoid Bottlenecks',
                            icon: Icons.alt_route_rounded,
                            gradient: const LinearGradient(colors: [Color(0xFF2ECC71), Color(0xFF27AE60)]),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RoutePlannerScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Nearby Alerts Feed Header
                    SectionHeader(
                      title: tr.translate('nearby_alerts'),
                      actionText: 'View All (${alertsList.length})',
                      onActionTap: () => _onTabSelected(2),
                    ),
                    // Alert Cards List
                    ...alertsList.take(3).map((alert) => _buildAlertCard(context, alert, isDark, tr)),
                  ],
                ),
              ),
            ),
            // Floating Bottom Nav Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(
                currentIndex: 0,
                onTabSelected: _onTabSelected,
                labels: [tr.translate('home'), tr.translate('map'), tr.translate('alerts'), tr.translate('profile')],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(String numStr, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(numStr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildQuickTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.headingSmall(true).copyWith(color: Colors.white, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: AppTypography.caption(true).copyWith(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, AlertItem alert, bool isDark, AppLocalizations tr) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Authority header row
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
          // Title + Severity Tag
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  alert.getLocalizedTitle(ref.watch(appStateProvider).languageCode),
                  style: AppTypography.headingSmall(isDark),
                ),
              ),
              const SizedBox(width: 8),
              SeverityTag(alertSeverity: alert.severity),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            alert.getLocalizedDescription(ref.watch(appStateProvider).languageCode),
            style: AppTypography.bodyRegular(isDark).copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Action row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.remove_red_eye_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${alert.viewCount}', style: AppTypography.caption(isDark)),
                  const SizedBox(width: 16),
                  Icon(Icons.thumb_up_alt_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${alert.likeCount}', style: AppTypography.caption(isDark)),
                ],
              ),
              TextButton.icon(
                onPressed: () => _onTabSelected(2),
                icon: const Icon(Icons.share_outlined, size: 16),
                label: const Text('Share Alert'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAllFeaturesModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('All Kumbh Mela Services', style: AppTypography.headingMedium(isDark)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    _buildModalChip(context, 'Family Tracker', Icons.family_restroom, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FamilyTrackerScreen()))),
                    _buildModalChip(context, 'Bathing Schedule', Icons.calendar_month, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SnanScheduleScreen()))),
                    _buildModalChip(context, 'Lost & Found', Icons.search_rounded, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LostFoundScreen()))),
                    _buildModalChip(context, 'Route Planner', Icons.directions_walk, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RoutePlannerScreen()))),
                    _buildModalChip(context, 'Emergency SOS', Icons.sos, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencySosScreen()))),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalChip(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: AppColors.primaryViolet),
      label: Text(label),
      onPressed: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

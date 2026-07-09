import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/ghat_location.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/map_provider.dart';
import '../../services/audio_guide_service.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/reusable_ui_components.dart';
import '../../widgets/badges/severity_tag.dart';

class RoutePlannerScreen extends ConsumerStatefulWidget {
  const RoutePlannerScreen({super.key});

  @override
  ConsumerState<RoutePlannerScreen> createState() => _RoutePlannerScreenState();
}

class _RoutePlannerScreenState extends ConsumerState<RoutePlannerScreen> {
  bool _isVoiceActive = false;
  bool _isUsingAlternateRoute = false;
  int _currentStepIndex = 0;
  bool _showMiniMap = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  GoogleMapController? _mapController;

  final List<Map<String, dynamic>> _mainSteps = [
    {'instr': 'Start walking north from Panchavati Circle towards Ashok Stambh.', 'dist': '150m', 'icon': Icons.straight_rounded},
    {'instr': 'Turn right at the police barricade onto Tapovan pedestrian path.', 'dist': '200m', 'icon': Icons.turn_right_rounded},
    {'instr': 'CAUTION: Heavy crowd bottleneck near Ramkund entrance gate.', 'dist': '80m', 'icon': Icons.warning_amber_rounded, 'isAlert': true},
    {'instr': 'Arrive at destination: Ramkund Holy Ghat (Main Steps).', 'dist': '0m', 'icon': Icons.flag_rounded},
  ];

  final List<Map<String, dynamic>> _alternateSteps = [
    {'instr': 'Start walking east towards Godavari River bank promenade.', 'dist': '180m', 'icon': Icons.turn_right_rounded},
    {'instr': 'Take the elevated temporary pedestrian bridge over Tapovan zone.', 'dist': '250m', 'icon': Icons.straight_rounded},
    {'instr': 'Descend stairs via Kushavarta bypass lane (Light crowd).', 'dist': '120m', 'icon': Icons.turn_left_rounded},
    {'instr': 'Arrive at destination: Ramkund Holy Ghat (West Gate).', 'dist': '0m', 'icon': Icons.flag_rounded},
  ];

  void _toggleVoiceGuide() {
    setState(() => _isVoiceActive = !_isVoiceActive);
    final appState = ref.read(appStateProvider);
    if (_isVoiceActive) {
      final steps = _isUsingAlternateRoute ? _alternateSteps : _mainSteps;
      AudioGuideService.instance.speak(
        'Navigation started. ${steps[_currentStepIndex]['instr']}',
        appState.languageCode,
      );
    } else {
      AudioGuideService.instance.stop();
    }
  }

  @override
  void dispose() {
    AudioGuideService.instance.stop();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final mapState = ref.watch(mapProvider);
    final appState = ref.watch(appStateProvider);
    final tr = AppLocalizations.of(context);

    final destName = mapState.selectedLocation?.getLocalizedName(appState.languageCode) ?? 'Ramkund Holy Ghat';
    final steps = _isUsingAlternateRoute ? _alternateSteps : _mainSteps;
    
    // Check if we have real calculated route from DirectionsService
    final calculatedRoute = mapState.currentRoute;
    final totalDist = calculatedRoute != null ? calculatedRoute.distanceText : (_isUsingAlternateRoute ? '550m' : '430m');
    final totalEta = calculatedRoute != null ? calculatedRoute.durationText : (_isUsingAlternateRoute ? '8 mins' : '14 mins (Heavy traffic)');

    // Build Polyline for Google Map
    final Set<Polyline> polylines = calculatedRoute != null && calculatedRoute.polylinePoints.isNotEmpty
        ? {
            Polyline(
              polylineId: const PolylineId('route_line'),
              points: calculatedRoute.polylinePoints,
              color: _isUsingAlternateRoute ? AppColors.successGreen : AppColors.primaryViolet,
              width: 6,
              jointType: JointType.round,
              endCap: Cap.roundCap,
              startCap: Cap.roundCap,
            ),
          }
        : <Polyline>{};

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(tr.translate('route_planner')),
        actions: [
          // Voice guide toggle
          IconButton(
            icon: Icon(
              _isVoiceActive ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: _isVoiceActive ? AppColors.secondarySaffron : (isDark ? Colors.white70 : Colors.black87),
            ),
            tooltip: 'Multi-language Voice Assistant',
            onPressed: _toggleVoiceGuide,
          ),
          // Offline download button
          IconButton(
            icon: Icon(
              appState.isOfflineMode ? Icons.offline_pin_rounded : Icons.download_for_offline_rounded,
              color: appState.isOfflineMode ? AppColors.successGreen : (isDark ? Colors.white70 : Colors.black87),
            ),
            tooltip: 'Cache Route for Offline Mode',
            onPressed: () {
              ref.read(appStateProvider.notifier).toggleOfflineMode();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    appState.isOfflineMode
                        ? 'Offline Map disabled.'
                        : 'Route & schedule cached! Navigation will work without internet.',
                  ),
                  backgroundColor: AppColors.primaryViolet,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(_showMiniMap ? Icons.list_alt_rounded : Icons.map_outlined),
            tooltip: 'Toggle Mini Map',
            onPressed: () => setState(() => _showMiniMap = !_showMiniMap),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Summary Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'To: $destName',
                        style: AppTypography.headingMedium(isDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SeverityTag(
                      crowdDensity: _isUsingAlternateRoute ? CrowdDensity.light : CrowdDensity.heavy,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.directions_walk_rounded, color: AppColors.primaryViolet, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '${tr.translate('distance')}: $totalDist',
                      style: AppTypography.bodyBold(isDark),
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.timer_outlined, color: AppColors.secondarySaffron, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      '${tr.translate('eta')}: $totalEta',
                      style: AppTypography.bodyBold(isDark).copyWith(
                        color: _isUsingAlternateRoute ? AppColors.successGreen : AppColors.alertHeavy,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Optional Mini Google Map polyline preview
          if (_showMiniMap && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS))
            Container(
              height: 160,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              clipBehavior: Clip.antiAlias,
              child: GoogleMap(
                onMapCreated: (ctrl) => _mapController = ctrl,
                initialCameraPosition: CameraPosition(
                  target: mapState.userLocation,
                  zoom: 14.0,
                ),
                polylines: polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
            ),

          // Congestion Alternate Route Suggestion Banner
          if (mapState.showAlternateRouteBanner || !_isUsingAlternateRoute)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _isUsingAlternateRoute ? AppColors.successGreen.withValues(alpha: 0.15) : AppColors.alertModerate.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isUsingAlternateRoute ? AppColors.successGreen : AppColors.alertModerate,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isUsingAlternateRoute ? Icons.check_circle : Icons.alt_route_rounded,
                    color: _isUsingAlternateRoute ? AppColors.successGreen : AppColors.alertModerate,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isUsingAlternateRoute ? 'Alternate Green Path Active' : tr.translate('route_congested'),
                          style: AppTypography.bodyBold(isDark).copyWith(
                            color: _isUsingAlternateRoute ? AppColors.successGreen : AppColors.alertModerate,
                          ),
                        ),
                        Text(
                          _isUsingAlternateRoute ? 'You are avoiding a 45-min bottleneck at Gate 2.' : 'Switch to River Promenade path to save 6 minutes & avoid crowd surge.',
                          style: AppTypography.caption(isDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      setState(() => _isUsingAlternateRoute = !_isUsingAlternateRoute);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: _isUsingAlternateRoute ? AppColors.successGreen : AppColors.alertModerate,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    child: Text(_isUsingAlternateRoute ? 'Main Route' : 'Switch Path'),
                  ),
                ],
              ),
            ),

          // Step-by-Step Directions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: steps.length,
              itemBuilder: (context, idx) {
                final step = steps[idx];
                final bool isCurrent = idx == _currentStepIndex;
                final bool isAlert = step['isAlert'] == true;

                return GestureDetector(
                  onTap: () {
                    setState(() => _currentStepIndex = idx);
                    if (_isVoiceActive) {
                      AudioGuideService.instance.speak(step['instr'] as String, appState.languageCode);
                    }
                  },
                  child: CustomCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: isCurrent
                        ? AppColors.primaryViolet.withValues(alpha: isDark ? 0.25 : 0.08)
                        : (isAlert ? AppColors.alertHeavy.withValues(alpha: 0.1) : null),
                    border: isCurrent ? Border.all(color: AppColors.primaryViolet, width: 2) : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isAlert ? AppColors.alertHeavy : (isCurrent ? AppColors.primaryViolet : (isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.15))),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            color: isAlert || isCurrent ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step['instr'] as String,
                                style: AppTypography.bodyBold(isDark).copyWith(
                                  color: isAlert ? AppColors.alertHeavy : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Distance: ${step['dist']}',
                                style: AppTypography.captionBold(isDark).copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isCurrent)
                          const Icon(Icons.volume_up_rounded, color: AppColors.primaryViolet, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom CTA Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: PillButton(
              text: _currentStepIndex < steps.length - 1 ? 'Next Turn (${_currentStepIndex + 1}/${steps.length})' : 'Arrived at Ghat',
              icon: Icons.navigation_rounded,
              onPressed: () {
                if (_currentStepIndex < steps.length - 1) {
                  setState(() => _currentStepIndex++);
                  if (_isVoiceActive) {
                    AudioGuideService.instance.speak(steps[_currentStepIndex]['instr'] as String, appState.languageCode);
                  }
                } else {
                  ref.read(mapProvider.notifier).stopRouteNavigation();
                  Navigator.pop(context);
                }
              },
              backgroundColor: _currentStepIndex == steps.length - 1 ? AppColors.successGreen : AppColors.saffron,
            ),
          ),
        ],
      ),
    );
  }
}

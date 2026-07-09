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
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/custom_search_bar.dart';
import '../../widgets/badges/severity_tag.dart';
import 'route_planner_screen.dart';

class InteractiveMapScreen extends ConsumerStatefulWidget {
  const InteractiveMapScreen({super.key});

  @override
  ConsumerState<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends ConsumerState<InteractiveMapScreen> {
  bool _showHeatmapOverlay = true;
  bool _use3GpsMap = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _panToLocation(double lat, double lng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = ref.watch(appStateProvider);
    final mapState = ref.watch(mapProvider);
    final locations = ref.watch(filteredLocationsProvider);
    final tr = AppLocalizations.of(context);

    // Build Google Map markers from locations
    final Set<Marker> googleMarkers = locations.map((loc) {
      final isSelected = mapState.selectedLocation?.id == loc.id;
      return Marker(
        markerId: MarkerId(loc.id),
        position: LatLng(loc.latitude, loc.longitude),
        infoWindow: InfoWindow(
          title: loc.getLocalizedName(appState.languageCode),
          snippet: '${loc.densityString} • ${loc.distanceMeters}m',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected
              ? BitmapDescriptor.hueCyan
              : (loc.currentDensity == CrowdDensity.heavy
                  ? BitmapDescriptor.hueRed
                  : (loc.currentDensity == CrowdDensity.moderate
                      ? BitmapDescriptor.hueOrange
                      : BitmapDescriptor.hueGreen)),
        ),
        onTap: () {
          ref.read(mapProvider.notifier).selectLocation(loc);
          _panToLocation(loc.latitude, loc.longitude);
        },
      );
    }).toSet();

    // Build circles for crowd heatmap density overlay
    final Set<Circle> googleCircles = _showHeatmapOverlay
        ? locations.map((loc) {
            Color circleColor = AppColors.successGreen;
            double radius = 180.0;
            if (loc.currentDensity == CrowdDensity.heavy) {
              circleColor = AppColors.alertHeavy;
              radius = 260.0;
            } else if (loc.currentDensity == CrowdDensity.moderate) {
              circleColor = AppColors.alertModerate;
              radius = 220.0;
            }
            return Circle(
              circleId: CircleId('circle_${loc.id}'),
              center: LatLng(loc.latitude, loc.longitude),
              radius: radius,
              fillColor: circleColor.withValues(alpha: 0.3),
              strokeColor: circleColor.withValues(alpha: 0.8),
              strokeWidth: 2,
            );
          }).toSet()
        : <Circle>{};

    return Scaffold(
      body: Stack(
        children: [
          // 1. Map Layer: 3D Google GPS Map or 2D High-Fidelity Canvas
          if (_use3GpsMap)
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: mapState.userLocation,
                zoom: 13.5,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: googleMarkers,
              circles: googleCircles,
              onTap: (_) => ref.read(mapProvider.notifier).selectLocation(null),
            )
          else
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF181C24) : const Color(0xFFEAF3FB),
              ),
              child: CustomPaint(
                painter: _MapGridPainter(
                  isDark: isDark,
                  showHeatmap: _showHeatmapOverlay,
                  locations: locations,
                ),
              ),
            ),

          // Godavari River visual representation (for 2D canvas mode)
          if (!_use3GpsMap)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Container(
                      width: double.infinity,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.riverBlue.withValues(alpha: 0.25),
                            AppColors.riverBlue.withValues(alpha: 0.45),
                            AppColors.riverBlue.withValues(alpha: 0.25),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Pavitra Godavari River Flow ~ Panchavati',
                          style: AppTypography.captionBold(isDark).copyWith(
                            color: AppColors.riverBlue.withValues(alpha: 0.8),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Simulated interactive marker pins for 2D mode
          if (!_use3GpsMap)
            ...locations.map((loc) {
              final double dx = ((loc.longitude - 73.5) / 0.4) * MediaQuery.of(context).size.width * 0.7 + 40;
              final double dy = ((20.05 - loc.latitude) / 0.15) * MediaQuery.of(context).size.height * 0.6 + 100;

              final isSelected = mapState.selectedLocation?.id == loc.id;
              Color markerColor = AppColors.successGreen;
              if (loc.currentDensity == CrowdDensity.heavy) markerColor = AppColors.alertHeavy;
              if (loc.currentDensity == CrowdDensity.moderate) markerColor = AppColors.alertModerate;

              return Positioned(
                left: dx - 20,
                top: dy - 40,
                child: GestureDetector(
                  onTap: () => ref.read(mapProvider.notifier).selectLocation(loc),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(isSelected ? 6 : 4),
                    decoration: BoxDecoration(
                      color: markerColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: markerColor.withValues(alpha: 0.5),
                          blurRadius: isSelected ? 12 : 6,
                          spreadRadius: isSelected ? 3 : 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      _getCategoryIcon(loc.category),
                      color: Colors.white,
                      size: isSelected ? 24 : 18,
                    ),
                  ),
                ),
              );
            }),

          // 2. Top Bar: Search Bar & Horizontal Filter Chips
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Column(
              children: [
                CustomSearchBar(
                  hintText: tr.translate('search_hint'),
                  onChanged: (val) => ref.read(mapProvider.notifier).setSearchQuery(val),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', null, isDark),
                      _buildFilterChip(tr.translate('ghats'), LocationCategory.ghat, isDark),
                      _buildFilterChip(tr.translate('parking'), LocationCategory.parking, isDark),
                      _buildFilterChip(tr.translate('medical'), LocationCategory.medical, isDark),
                      _buildFilterChip(tr.translate('toilets'), LocationCategory.toilet, isDark),
                      _buildFilterChip(tr.translate('police'), LocationCategory.police, isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Floating Control Buttons (Heatmap & Map Mode Toggle)
          Positioned(
            right: 16,
            top: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'heatmap_toggle',
                  onPressed: () => setState(() => _showHeatmapOverlay = !_showHeatmapOverlay),
                  backgroundColor: _showHeatmapOverlay ? AppColors.primaryViolet : (isDark ? AppColors.darkCard : Colors.white),
                  foregroundColor: _showHeatmapOverlay ? Colors.white : (isDark ? Colors.white : Colors.black87),
                  icon: const Icon(Icons.layers_rounded, size: 18),
                  label: Text('Crowd Overlay', style: AppTypography.captionBold(false).copyWith(fontSize: 12, color: _showHeatmapOverlay ? Colors.white : (isDark ? Colors.white : Colors.black87))),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  heroTag: 'map_mode_toggle',
                  onPressed: () => setState(() => _use3GpsMap = !_use3GpsMap),
                  backgroundColor: _use3GpsMap ? AppColors.saffron : (isDark ? AppColors.darkCard : Colors.white),
                  foregroundColor: _use3GpsMap ? Colors.white : (isDark ? Colors.white : Colors.black87),
                  icon: Icon(_use3GpsMap ? Icons.satellite_alt_rounded : Icons.map_rounded, size: 18),
                  label: Text(_use3GpsMap ? 'Live GPS Map' : '2D Overview', style: AppTypography.captionBold(false).copyWith(fontSize: 12, color: _use3GpsMap ? Colors.white : (isDark ? Colors.white : Colors.black87))),
                ),
              ],
            ),
          ),

          // 4. Selected Marker Detail Bottom Sheet / Card
          if (mapState.selectedLocation != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 110,
              child: CustomCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            mapState.selectedLocation!.getLocalizedName(appState.languageCode),
                            style: AppTypography.headingMedium(isDark),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => ref.read(mapProvider.notifier).selectLocation(null),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        SeverityTag(crowdDensity: mapState.selectedLocation!.currentDensity),
                        const SizedBox(width: 10),
                        Text(
                          '${mapState.selectedLocation!.distanceMeters}m away • Walking: ~${(mapState.selectedLocation!.distanceMeters / 70).round()} mins',
                          style: AppTypography.captionBold(isDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      mapState.selectedLocation!.getLocalizedDescription(appState.languageCode),
                      style: AppTypography.bodyRegular(isDark).copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    if (mapState.selectedLocation!.facilities.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: mapState.selectedLocation!.facilities.map((fac) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryViolet.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(fac, style: AppTypography.caption(isDark).copyWith(color: AppColors.primaryViolet)),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondarySaffron,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            ),
                            icon: const Icon(Icons.navigation_rounded, size: 20),
                            label: Text(tr.translate('navigate')),
                            onPressed: () {
                              ref.read(mapProvider.notifier).startRouteNavigation();
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const RoutePlannerScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, LocationCategory? category, bool isDark) {
    final isSelected = ref.watch(mapProvider).selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: AppTypography.captionBold(isDark).copyWith(
          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
        ),
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        selectedColor: AppColors.primaryViolet,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onSelected: (_) => ref.read(mapProvider.notifier).selectCategory(category),
      ),
    );
  }

  IconData _getCategoryIcon(LocationCategory cat) {
    switch (cat) {
      case LocationCategory.ghat:
        return Icons.water_drop_rounded;
      case LocationCategory.parking:
        return Icons.local_parking_rounded;
      case LocationCategory.medical:
        return Icons.medical_services_rounded;
      case LocationCategory.food:
        return Icons.restaurant_rounded;
      case LocationCategory.toilet:
        return Icons.wc_rounded;
      case LocationCategory.police:
        return Icons.shield_rounded;
    }
  }
}

class _MapGridPainter extends CustomPainter {
  final bool isDark;
  final bool showHeatmap;
  final List<GhatLocation> locations;

  _MapGridPainter({required this.isDark, required this.showHeatmap, required this.locations});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    if (showHeatmap) {
      for (var loc in locations) {
        final double dx = ((loc.longitude - 73.5) / 0.4) * size.width * 0.7 + 40;
        final double dy = ((20.05 - loc.latitude) / 0.15) * size.height * 0.6 + 100;

        Color heatColor = AppColors.successGreen;
        double radius = 60.0;
        if (loc.currentDensity == CrowdDensity.heavy) {
          heatColor = AppColors.alertHeavy;
          radius = 110.0;
        } else if (loc.currentDensity == CrowdDensity.moderate) {
          heatColor = AppColors.alertModerate;
          radius = 85.0;
        }

        final heatPaint = Paint()
          ..shader = RadialGradient(
            colors: [heatColor.withValues(alpha: 0.45), heatColor.withValues(alpha: 0.0)],
          ).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: radius));

        canvas.drawCircle(Offset(dx, dy), radius, heatPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.showHeatmap != showHeatmap || oldDelegate.locations != locations;
  }
}

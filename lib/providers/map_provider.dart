import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/ghat_location.dart';
import '../services/mock_backend_service.dart';
import '../services/location_service.dart';
import '../services/directions_service.dart';

class MapState {
  final LocationCategory? selectedCategory;
  final GhatLocation? selectedLocation;
  final bool isRouteActive;
  final bool showAlternateRouteBanner;
  final int crowdPredictionHour; // 0-23
  final String searchQuery;
  final LatLng userLocation;
  final RouteResult? currentRoute;
  final bool isCalculatingRoute;

  const MapState({
    this.selectedCategory,
    this.selectedLocation,
    this.isRouteActive = false,
    this.showAlternateRouteBanner = false,
    this.crowdPredictionHour = 8,
    this.searchQuery = '',
    this.userLocation = LocationService.defaultNashikLocation,
    this.currentRoute,
    this.isCalculatingRoute = false,
  });

  MapState copyWith({
    LocationCategory? selectedCategory,
    bool clearCategory = false,
    GhatLocation? selectedLocation,
    bool clearLocation = false,
    bool? isRouteActive,
    bool? showAlternateRouteBanner,
    int? crowdPredictionHour,
    String? searchQuery,
    LatLng? userLocation,
    RouteResult? currentRoute,
    bool clearRoute = false,
    bool? isCalculatingRoute,
  }) {
    return MapState(
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedLocation: clearLocation ? null : (selectedLocation ?? this.selectedLocation),
      isRouteActive: isRouteActive ?? this.isRouteActive,
      showAlternateRouteBanner: showAlternateRouteBanner ?? this.showAlternateRouteBanner,
      crowdPredictionHour: crowdPredictionHour ?? this.crowdPredictionHour,
      searchQuery: searchQuery ?? this.searchQuery,
      userLocation: userLocation ?? this.userLocation,
      currentRoute: clearRoute ? null : (currentRoute ?? this.currentRoute),
      isCalculatingRoute: isCalculatingRoute ?? this.isCalculatingRoute,
    );
  }
}

class MapNotifier extends Notifier<MapState> {
  StreamSubscription<LatLng>? _gpsSubscription;

  @override
  MapState build() {
    _initGpsStream();
    return const MapState();
  }

  void _initGpsStream() async {
    try {
      final initialLoc = await LocationService.instance.getCurrentLocation();
      state = state.copyWith(userLocation: initialLoc);

      _gpsSubscription?.cancel();
      _gpsSubscription = LocationService.instance.getLiveLocationStream().listen((loc) {
        state = state.copyWith(userLocation: loc);
        // If navigation is active, we could dynamically update distance
      });
    } catch (e) {
      debugPrint('⚠️ [MapNotifier] GPS stream init error: $e');
    }
  }

  void selectCategory(LocationCategory? category) {
    if (state.selectedCategory == category) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
  }

  void selectLocation(GhatLocation? location) {
    if (location == null) {
      state = state.copyWith(clearLocation: true, isRouteActive: false, clearRoute: true);
    } else {
      final showBanner = location.currentDensity == CrowdDensity.heavy;
      state = state.copyWith(
        selectedLocation: location,
        showAlternateRouteBanner: showBanner,
      );
    }
  }

  Future<void> startRouteNavigation([GhatLocation? targetLocation]) async {
    final dest = targetLocation ?? state.selectedLocation;
    if (dest == null) return;

    if (targetLocation != null && targetLocation != state.selectedLocation) {
      selectLocation(targetLocation);
    }

    state = state.copyWith(isCalculatingRoute: true);

    try {
      final origin = state.userLocation;
      final destination = LatLng(dest.latitude, dest.longitude);

      final route = await DirectionsService.instance.getRoute(
        origin: origin,
        destination: destination,
        destinationDensity: dest.currentDensity,
      );

      state = state.copyWith(
        isRouteActive: true,
        currentRoute: route,
        isCalculatingRoute: false,
      );
    } catch (e) {
      debugPrint('⚠️ [MapNotifier] Route navigation calculation error: $e');
      state = state.copyWith(isCalculatingRoute: false);
    }
  }

  void stopRouteNavigation() {
    state = state.copyWith(isRouteActive: false, clearLocation: true, clearRoute: true);
  }

  void setCrowdPredictionHour(int hour) {
    state = state.copyWith(crowdPredictionHour: hour);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final mapProvider = NotifierProvider<MapNotifier, MapState>(MapNotifier.new);

final filteredLocationsProvider = Provider<List<GhatLocation>>((ref) {
  final mapState = ref.watch(mapProvider);
  var list = MockBackendService.instance.getLocations(category: mapState.selectedCategory);

  // Dynamically update distanceMeters based on live GPS coordinate!
  final userLat = mapState.userLocation.latitude;
  final userLng = mapState.userLocation.longitude;
  list = list.map((loc) {
    final dist = LocationService.instance.calculateDistance(userLat, userLng, loc.latitude, loc.longitude);
    return loc.copyWith(distanceMeters: dist.round());
  }).toList();
  
  if (mapState.searchQuery.isNotEmpty) {
    final q = mapState.searchQuery.toLowerCase();
    list = list.where((l) =>
      l.nameEn.toLowerCase().contains(q) ||
      l.nameHi.toLowerCase().contains(q) ||
      l.nameMr.toLowerCase().contains(q) ||
      l.descriptionEn.toLowerCase().contains(q)
    ).toList();
  }
  return list;
});

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../core/config/env_config.dart';
import '../models/ghat_location.dart';

class RouteResult {
  final List<LatLng> polylinePoints;
  final String distanceText;
  final String durationText;
  final int durationSeconds;
  final bool isAlternateRoute;
  final String advisoryMessage;

  const RouteResult({
    required this.polylinePoints,
    required this.distanceText,
    required this.durationText,
    required this.durationSeconds,
    this.isAlternateRoute = false,
    this.advisoryMessage = '',
  });
}

class DirectionsService {
  DirectionsService._();

  static final DirectionsService instance = DirectionsService._();

  Future<RouteResult> getRoute({
    required LatLng origin,
    required LatLng destination,
    CrowdDensity destinationDensity = CrowdDensity.moderate,
  }) async {
    final apiKey = EnvConfig.instance.googleMapsApiKey;
    final bool requestAlternatives = destinationDensity == CrowdDensity.heavy;

    if (!EnvConfig.instance.isLiveMapsKey) {
      debugPrint('ℹ️ [DirectionsService] Using local polyline simulation (API key not live)');
      return _generateSimulatedRoute(origin, destination, destinationDensity);
    }

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}&'
        'destination=${destination.latitude},${destination.longitude}&'
        'alternatives=$requestAlternatives&'
        'mode=walking&'
        'key=$apiKey',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if ((data['routes'] as List).isNotEmpty) {
          // If destination is heavy crowd and there is an alternate route (index 1 or higher), pick the alternate route!
          int routeIndex = 0;
          bool isAlt = false;
          String adv = '';

          if (requestAlternatives && (data['routes'] as List).length > 1) {
            routeIndex = 1;
            isAlt = true;
            adv = '🔀 Alternate low-congestion path selected to avoid heavy crowd at destination.';
          } else if (destinationDensity == CrowdDensity.heavy) {
            adv = '⚠️ Heavy crowd warning at destination. Please proceed with caution.';
          }

          final route = data['routes'][routeIndex];
          final leg = route['legs'][0];
          final pointsEncoded = route['overview_polyline']['points'] as String;

          final polylinePoints = PolylinePoints()
              .decodePolyline(pointsEncoded)
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList();

          return RouteResult(
            polylinePoints: polylinePoints,
            distanceText: leg['distance']['text'] ?? '1.2 km',
            durationText: leg['duration']['text'] ?? '15 mins',
            durationSeconds: leg['duration']['value'] ?? 900,
            isAlternateRoute: isAlt,
            advisoryMessage: adv,
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ [DirectionsService] Directions API error (falling back to simulation): $e');
    }

    return _generateSimulatedRoute(origin, destination, destinationDensity);
  }

  RouteResult _generateSimulatedRoute(LatLng origin, LatLng destination, CrowdDensity density) {
    // Generate a realistic curved polyline between origin and destination
    final List<LatLng> points = [];
    final int steps = 15;
    for (int i = 0; i <= steps; i++) {
      final double fraction = i / steps;
      final double lat = origin.latitude + (destination.latitude - origin.latitude) * fraction;
      // Add a slight curve offset for middle points
      final double curveOffset = (i > 3 && i < 12) ? (density == CrowdDensity.heavy ? 0.0025 : 0.001) : 0.0;
      final double lng = origin.longitude + (destination.longitude - origin.longitude) * fraction + curveOffset;
      points.add(LatLng(lat, lng));
    }

    bool isAlt = density == CrowdDensity.heavy;
    String adv = isAlt
        ? '🔀 Congestion Alternate Route activated: Guided via Panchavati East perimeter to bypass Ramkund crowd bottleneck.'
        : '🚶 Direct walking route along Godavari River path.';

    return RouteResult(
      polylinePoints: points,
      distanceText: density == CrowdDensity.heavy ? '1.8 km (Alt)' : '1.3 km',
      durationText: density == CrowdDensity.heavy ? '22 mins' : '16 mins',
      durationSeconds: density == CrowdDensity.heavy ? 1320 : 960,
      isAlternateRoute: isAlt,
      advisoryMessage: adv,
    );
  }
}

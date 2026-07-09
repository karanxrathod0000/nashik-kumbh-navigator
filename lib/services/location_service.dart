import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  LocationService._();

  static final LocationService instance = LocationService._();

  // Simulated fallback coordinate near Ramkund Ghat, Nashik
  static const LatLng defaultNashikLocation = LatLng(20.0059, 73.7900);

  Future<bool> requestPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('⚠️ [LocationService] Location services are disabled.');
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('⚠️ [LocationService] Location permissions denied.');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('⚠️ [LocationService] Location permissions permanently denied.');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('⚠️ [LocationService] Error checking location permissions: $e');
      return false;
    }
  }

  Future<LatLng> getCurrentLocation() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        return defaultNashikLocation;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 4), onTimeout: () {
        throw TimeoutException('GPS timeout');
      });

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('⚠️ [LocationService] Could not fetch real GPS (using Nashik fallback): $e');
      return defaultNashikLocation;
    }
  }

  Stream<LatLng> getLiveLocationStream() {
    try {
      return Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
        ),
      ).map((pos) => LatLng(pos.latitude, pos.longitude)).handleError((e) {
        debugPrint('⚠️ [LocationService] Stream error: $e');
        return defaultNashikLocation;
      });
    } catch (e) {
      return Stream.value(defaultNashikLocation);
    }
  }

  // Calculate distance in meters between two coordinates
  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}

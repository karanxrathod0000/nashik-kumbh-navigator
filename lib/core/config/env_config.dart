import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static final EnvConfig instance = EnvConfig._();

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> init() async {
    try {
      await dotenv.load(fileName: '.env');
      _isLoaded = true;
      debugPrint('✅ [EnvConfig] Successfully loaded .env file');
    } catch (e) {
      debugPrint('⚠️ [EnvConfig] Could not load .env file: $e. Using fallback defaults.');
      _isLoaded = false;
    }
  }

  String get googleMapsApiKey {
    final key = dotenv.maybeGet('GOOGLE_MAPS_API_KEY') ?? 'AIzaSyDummyKeyForDevelopmentAndTesting123';
    return key;
  }

  bool get isLiveMapsKey => !googleMapsApiKey.contains('DummyKey') && googleMapsApiKey.isNotEmpty;

  String get openWeatherApiKey {
    return dotenv.maybeGet('OPENWEATHER_API_KEY') ?? 'dummy_weather_key_456';
  }

  String get firebaseProjectId {
    return dotenv.maybeGet('FIREBASE_PROJECT_ID') ?? 'nashik-kumbh-navigator-2027';
  }
}

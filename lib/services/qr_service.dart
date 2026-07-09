class QrService {
  QrService._();

  static String generateWristbandData({
    required String name,
    required String phone,
    required String emergencyMedicalInfo,
  }) {
    return 'KUMBH_ID|NAME:$name|PHONE:$phone|MED:$emergencyMedicalInfo|TIMESTAMP:${DateTime.now().millisecondsSinceEpoch}';
  }

  static Map<String, String> parseWristbandData(String rawData) {
    if (!rawData.startsWith('KUMBH_ID|')) {
      return {'error': 'Invalid Kumbh Mela QR Wristband ID'};
    }
    final parts = rawData.split('|');
    final Map<String, String> result = {};
    for (var p in parts) {
      if (p.contains(':')) {
        final kv = p.split(':');
        result[kv[0]] = kv.sublist(1).join(':');
      }
    }
    return result;
  }
}

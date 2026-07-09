class FamilyMember {
  final String id;
  final String name;
  final String relation;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final int batteryLevel;
  final bool isOnline;
  final DateTime lastUpdated;
  final String qrCodeData; // For wristband ID

  const FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.batteryLevel,
    this.isOnline = true,
    required this.lastUpdated,
    required this.qrCodeData,
  });

  String get lastUpdatedString {
    final diff = DateTime.now().difference(lastUpdated);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  FamilyMember copyWith({
    double? latitude,
    double? longitude,
    int? batteryLevel,
    bool? isOnline,
    DateTime? lastUpdated,
  }) {
    return FamilyMember(
      id: id,
      name: name,
      relation: relation,
      phoneNumber: phoneNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      isOnline: isOnline ?? this.isOnline,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      qrCodeData: qrCodeData,
    );
  }
}

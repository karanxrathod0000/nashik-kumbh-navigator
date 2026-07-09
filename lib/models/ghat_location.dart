enum CrowdDensity { light, moderate, heavy }

enum LocationCategory { ghat, parking, medical, food, toilet, police }

class GhatLocation {
  final String id;
  final String nameEn;
  final String nameHi;
  final String nameMr;
  final LocationCategory category;
  final double latitude;
  final double longitude;
  final CrowdDensity currentDensity;
  final String descriptionEn;
  final String descriptionHi;
  final String descriptionMr;
  final String openingHours;
  final bool hasWheelchairAccess;
  final int distanceMeters; // distance from simulated user coordinates
  final List<String> facilities; // e.g. "Changing rooms", "Life guards"

  const GhatLocation({
    required this.id,
    required this.nameEn,
    required this.nameHi,
    required this.nameMr,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.currentDensity,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.descriptionMr,
    this.openingHours = "24 Hours",
    this.hasWheelchairAccess = true,
    this.distanceMeters = 500,
    this.facilities = const [],
  });

  String getLocalizedName(String langCode) {
    if (langCode == 'hi') return nameHi;
    if (langCode == 'mr') return nameMr;
    return nameEn;
  }

  String getLocalizedDescription(String langCode) {
    if (langCode == 'hi') return descriptionHi;
    if (langCode == 'mr') return descriptionMr;
    return descriptionEn;
  }

  String get densityString {
    switch (currentDensity) {
      case CrowdDensity.light:
        return 'Light Crowd';
      case CrowdDensity.moderate:
        return 'Moderate Crowd';
      case CrowdDensity.heavy:
        return 'Heavy Crowd (Avoid)';
    }
  }

  GhatLocation copyWith({
    CrowdDensity? currentDensity,
    int? distanceMeters,
  }) {
    return GhatLocation(
      id: id,
      nameEn: nameEn,
      nameHi: nameHi,
      nameMr: nameMr,
      category: category,
      latitude: latitude,
      longitude: longitude,
      currentDensity: currentDensity ?? this.currentDensity,
      descriptionEn: descriptionEn,
      descriptionHi: descriptionHi,
      descriptionMr: descriptionMr,
      openingHours: openingHours,
      hasWheelchairAccess: hasWheelchairAccess,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      facilities: facilities,
    );
  }
}

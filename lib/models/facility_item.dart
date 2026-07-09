enum FacilityType { toilet, water, charging, firstAid, atm, cloakRoom }

class FacilityItem {
  final String id;
  final FacilityType type;
  final String nameEn;
  final String nameHi;
  final String nameMr;
  final String locationName;
  final int distanceMeters;
  final bool isOperational;
  final String additionalInfo;

  const FacilityItem({
    required this.id,
    required this.type,
    required this.nameEn,
    required this.nameHi,
    required this.nameMr,
    required this.locationName,
    this.distanceMeters = 200,
    this.isOperational = true,
    this.additionalInfo = '',
  });

  String getLocalizedName(String langCode) {
    if (langCode == 'hi') return nameHi;
    if (langCode == 'mr') return nameMr;
    return nameEn;
  }

  String get typeString {
    switch (type) {
      case FacilityType.toilet:
        return 'Clean Toilet / Swachh Bharat';
      case FacilityType.water:
        return 'Drinking Water Point (Jal Sewa)';
      case FacilityType.charging:
        return 'Mobile Charging Station';
      case FacilityType.firstAid:
        return 'First-Aid / Medical Kiosk';
      case FacilityType.atm:
        return 'Mobile ATM / Cash Point';
      case FacilityType.cloakRoom:
        return 'Luggage Cloak Room / Locker';
    }
  }
}

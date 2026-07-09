class SnanSchedule {
  final String id;
  final String titleEn;
  final String titleHi;
  final String titleMr;
  final DateTime date;
  final String significanceEn;
  final String significanceHi;
  final String significanceMr;
  final String expectedCrowdEn;
  final String expectedCrowdHi;
  final String expectedCrowdMr;
  final bool isReminderSet;

  const SnanSchedule({
    required this.id,
    required this.titleEn,
    required this.titleHi,
    required this.titleMr,
    required this.date,
    required this.significanceEn,
    required this.significanceHi,
    required this.significanceMr,
    required this.expectedCrowdEn,
    required this.expectedCrowdHi,
    required this.expectedCrowdMr,
    this.isReminderSet = false,
  });

  String getLocalizedTitle(String langCode) {
    if (langCode == 'hi') return titleHi;
    if (langCode == 'mr') return titleMr;
    return titleEn;
  }

  String getLocalizedSignificance(String langCode) {
    if (langCode == 'hi') return significanceHi;
    if (langCode == 'mr') return significanceMr;
    return significanceEn;
  }

  String getLocalizedCrowd(String langCode) {
    if (langCode == 'hi') return expectedCrowdHi;
    if (langCode == 'mr') return expectedCrowdMr;
    return expectedCrowdEn;
  }

  SnanSchedule copyWith({bool? isReminderSet}) {
    return SnanSchedule(
      id: id,
      titleEn: titleEn,
      titleHi: titleHi,
      titleMr: titleMr,
      date: date,
      significanceEn: significanceEn,
      significanceHi: significanceHi,
      significanceMr: significanceMr,
      expectedCrowdEn: expectedCrowdEn,
      expectedCrowdHi: expectedCrowdHi,
      expectedCrowdMr: expectedCrowdMr,
      isReminderSet: isReminderSet ?? this.isReminderSet,
    );
  }
}

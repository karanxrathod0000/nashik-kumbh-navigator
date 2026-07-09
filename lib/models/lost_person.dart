enum ReportType { lostPerson, lostItem, foundItem }

class LostPersonItem {
  final String id;
  final ReportType type;
  final String titleEn;
  final String titleHi;
  final String titleMr;
  final String description;
  final String contactName;
  final String contactPhone;
  final String lastSeenLocation;
  final DateTime timestamp;
  final bool isResolved;
  final String? photoUrl;

  const LostPersonItem({
    required this.id,
    required this.type,
    required this.titleEn,
    required this.titleHi,
    required this.titleMr,
    required this.description,
    required this.contactName,
    required this.contactPhone,
    required this.lastSeenLocation,
    required this.timestamp,
    this.isResolved = false,
    this.photoUrl,
  });

  String getLocalizedTitle(String langCode) {
    if (langCode == 'hi') return titleHi;
    if (langCode == 'mr') return titleMr;
    return titleEn;
  }

  String get typeString {
    switch (type) {
      case ReportType.lostPerson:
        return 'Missing Person';
      case ReportType.lostItem:
        return 'Lost Item';
      case ReportType.foundItem:
        return 'Found Item';
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  LostPersonItem copyWith({bool? isResolved}) {
    return LostPersonItem(
      id: id,
      type: type,
      titleEn: titleEn,
      titleHi: titleHi,
      titleMr: titleMr,
      description: description,
      contactName: contactName,
      contactPhone: contactPhone,
      lastSeenLocation: lastSeenLocation,
      timestamp: timestamp,
      isResolved: isResolved ?? this.isResolved,
      photoUrl: photoUrl,
    );
  }
}

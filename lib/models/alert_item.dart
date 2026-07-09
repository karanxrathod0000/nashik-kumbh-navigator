enum AlertSeverity { light, moderate, heavy } // Green, Yellow, Red

enum AlertCategory { crowd, route, weather, missing, emergency }

class AlertItem {
  final String id;
  final String authorityName;
  final bool isVerified;
  final AlertSeverity severity;
  final AlertCategory category;
  final String titleEn;
  final String titleHi;
  final String titleMr;
  final String descriptionEn;
  final String descriptionHi;
  final String descriptionMr;
  final DateTime timestamp;
  final int viewCount;
  final int likeCount;
  final int shareCount;

  const AlertItem({
    required this.id,
    required this.authorityName,
    this.isVerified = true,
    required this.severity,
    required this.category,
    required this.titleEn,
    required this.titleHi,
    required this.titleMr,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.descriptionMr,
    required this.timestamp,
    this.viewCount = 1240,
    this.likeCount = 85,
    this.shareCount = 32,
  });

  String getLocalizedTitle(String langCode) {
    if (langCode == 'hi') return titleHi;
    if (langCode == 'mr') return titleMr;
    return titleEn;
  }

  String getLocalizedDescription(String langCode) {
    if (langCode == 'hi') return descriptionHi;
    if (langCode == 'mr') return descriptionMr;
    return descriptionEn;
  }

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  AlertItem copyWith({
    int? viewCount,
    int? likeCount,
    int? shareCount,
  }) {
    return AlertItem(
      id: id,
      authorityName: authorityName,
      isVerified: isVerified,
      severity: severity,
      category: category,
      titleEn: titleEn,
      titleHi: titleHi,
      titleMr: titleMr,
      descriptionEn: descriptionEn,
      descriptionHi: descriptionHi,
      descriptionMr: descriptionMr,
      timestamp: timestamp,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      shareCount: shareCount ?? this.shareCount,
    );
  }
}

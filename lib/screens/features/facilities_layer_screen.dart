import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/facility_item.dart';
import '../../widgets/common/custom_card.dart';

final mockFacilitiesProvider = Provider<List<FacilityItem>>((ref) {
  return const [
    FacilityItem(
      id: 'f1',
      type: FacilityType.toilet,
      nameEn: 'Sanitised Mobile Toilet Complex A',
      nameHi: 'स्वच्छ शौचालय परिसर A',
      nameMr: 'स्वच्छ शौचालय संकुल A',
      locationName: 'Sector 2 (Ramkund East)',
      distanceMeters: 120,
      isOperational: true,
    ),
    FacilityItem(
      id: 'f2',
      type: FacilityType.water,
      nameEn: 'RO Drinking Water Station #14',
      nameHi: 'RO पेयजल केंद्र #14',
      nameMr: 'RO पिण्याचे पाणी केंद्र #14',
      locationName: 'Sector 2 (Ramkund East)',
      distanceMeters: 80,
      isOperational: true,
    ),
    FacilityItem(
      id: 'f3',
      type: FacilityType.firstAid,
      nameEn: 'Ambulance & Emergency Medical Camp 3',
      nameHi: 'एंबुलेंस और आपातकालीन चिकित्सा शिविर 3',
      nameMr: 'रुग्णवाहिका आणि वैद्यकीय छावणी 3',
      locationName: 'Panchavati Circle',
      distanceMeters: 300,
      isOperational: true,
    ),
    FacilityItem(
      id: 'f4',
      type: FacilityType.charging,
      nameEn: 'Mobile Solar Phone Charging Booth',
      nameHi: 'मोबाइल सोलर फोन चार्जिंग बूथ',
      nameMr: 'मोबाईल सोलर फोन चार्जिंग बूथ',
      locationName: 'Tapovan Gate',
      distanceMeters: 220,
      isOperational: true,
    ),
    FacilityItem(
      id: 'f5',
      type: FacilityType.atm,
      nameEn: 'State Bank Mobile ATM Van',
      nameHi: 'स्टेट बैंक मोबाइल एटीएम वैन',
      nameMr: 'स्टेट बँक मोबाईल एटीएम व्हॅन',
      locationName: 'Ashok Stambh',
      distanceMeters: 450,
      isOperational: false,
    ),
  ];
});

class FacilitiesLayerScreen extends ConsumerStatefulWidget {
  const FacilitiesLayerScreen({super.key});

  @override
  ConsumerState<FacilitiesLayerScreen> createState() => _FacilitiesLayerScreenState();
}

class _FacilitiesLayerScreenState extends ConsumerState<FacilitiesLayerScreen> {
  String _selectedCat = 'All';

  String _getCatName(FacilityType type) {
    switch (type) {
      case FacilityType.toilet:
        return 'Toilets';
      case FacilityType.water:
        return 'Water';
      case FacilityType.firstAid:
        return 'Medical';
      case FacilityType.charging:
        return 'Charging';
      case FacilityType.atm:
        return 'ATM';
      default:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final facilities = ref.watch(mockFacilitiesProvider);
    final tr = AppLocalizations.of(context);

    final filtered = _selectedCat == 'All'
        ? facilities
        : facilities.where((f) => _getCatName(f.type) == _selectedCat).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('facilities')),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: ['All', 'Toilets', 'Water', 'Medical', 'Charging', 'ATM'].map((cat) {
                final isSel = _selectedCat == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSel,
                    onSelected: (_) => setState(() => _selectedCat = cat),
                    selectedColor: AppColors.primaryViolet,
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 90),
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final item = filtered[idx];
                final catName = _getCatName(item.type);
                final color = _getCatColor(item.type);
                final icon = _getCatIcon(item.type);

                return CustomCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(catName, style: AppTypography.captionBold(isDark).copyWith(color: color)),
                                Text('${item.distanceMeters}m', style: AppTypography.bodyBold(isDark)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(item.nameEn, style: AppTypography.headingSmall(isDark)),
                            const SizedBox(height: 2),
                            Text(item.locationName, style: AppTypography.caption(isDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getCatColor(FacilityType type) {
    switch (type) {
      case FacilityType.toilet:
        return const Color(0xFF27AE60);
      case FacilityType.water:
        return const Color(0xFF2F80ED);
      case FacilityType.firstAid:
        return const Color(0xFFE74C3C);
      case FacilityType.charging:
        return const Color(0xFFF39C12);
      default:
        return AppColors.primaryViolet;
    }
  }

  IconData _getCatIcon(FacilityType type) {
    switch (type) {
      case FacilityType.toilet:
        return Icons.wc_rounded;
      case FacilityType.water:
        return Icons.water_drop_rounded;
      case FacilityType.firstAid:
        return Icons.medical_services_rounded;
      case FacilityType.charging:
        return Icons.battery_charging_full_rounded;
      default:
        return Icons.atm_rounded;
    }
  }
}

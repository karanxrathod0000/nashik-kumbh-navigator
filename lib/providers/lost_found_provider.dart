import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lost_person.dart';
import '../services/mock_backend_service.dart';

class LostFoundState {
  final List<LostPersonItem> items;
  final ReportType? filterType;

  const LostFoundState({
    this.items = const [],
    this.filterType,
  });

  LostFoundState copyWith({
    List<LostPersonItem>? items,
    ReportType? filterType,
    bool clearFilter = false,
  }) {
    return LostFoundState(
      items: items ?? this.items,
      filterType: clearFilter ? null : (filterType ?? this.filterType),
    );
  }
}

class LostFoundNotifier extends Notifier<LostFoundState> {
  @override
  LostFoundState build() {
    return LostFoundState(items: MockBackendService.instance.getLostFound());
  }

  void setFilterType(ReportType? type) {
    if (state.filterType == type) {
      state = state.copyWith(clearFilter: true);
    } else {
      state = state.copyWith(filterType: type);
    }
  }

  void reportNewItem(LostPersonItem item) {
    MockBackendService.instance.addLostFoundItem(item);
    state = state.copyWith(items: MockBackendService.instance.getLostFound());
  }

  void resolveItem(String id) {
    final updated = state.items.map((i) {
      if (i.id == id) return i.copyWith(isResolved: true);
      return i;
    }).toList();
    state = state.copyWith(items: updated);
  }
}

final lostFoundProvider = NotifierProvider<LostFoundNotifier, LostFoundState>(LostFoundNotifier.new);

final filteredLostFoundProvider = Provider<List<LostPersonItem>>((ref) {
  final lfState = ref.watch(lostFoundProvider);
  if (lfState.filterType == null) return lfState.items;
  return lfState.items.where((i) => i.type == lfState.filterType).toList();
});

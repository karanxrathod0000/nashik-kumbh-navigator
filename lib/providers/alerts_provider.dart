import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/alert_item.dart';
import '../services/mock_backend_service.dart';

class AlertsState {
  final AlertSeverity? filterSeverity;
  final AlertCategory? filterCategory;
  final bool isRefreshing;

  const AlertsState({
    this.filterSeverity,
    this.filterCategory,
    this.isRefreshing = false,
  });

  AlertsState copyWith({
    AlertSeverity? filterSeverity,
    bool clearSeverity = false,
    AlertCategory? filterCategory,
    bool clearCategory = false,
    bool? isRefreshing,
  }) {
    return AlertsState(
      filterSeverity: clearSeverity ? null : (filterSeverity ?? this.filterSeverity),
      filterCategory: clearCategory ? null : (filterCategory ?? this.filterCategory),
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class AlertsNotifier extends Notifier<AlertsState> {
  @override
  AlertsState build() {
    return const AlertsState();
  }

  void setSeverityFilter(AlertSeverity? severity) {
    if (state.filterSeverity == severity) {
      state = state.copyWith(clearSeverity: true);
    } else {
      state = state.copyWith(filterSeverity: severity);
    }
  }

  void setCategoryFilter(AlertCategory? category) {
    if (state.filterCategory == category) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(filterCategory: category);
    }
  }

  Future<void> refreshAlerts() async {
    state = state.copyWith(isRefreshing: true);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(isRefreshing: false);
  }
}

final alertsProvider = NotifierProvider<AlertsNotifier, AlertsState>(AlertsNotifier.new);

final filteredAlertsProvider = Provider<List<AlertItem>>((ref) {
  final alertsState = ref.watch(alertsProvider);
  var list = MockBackendService.instance.getAlerts(severity: alertsState.filterSeverity);
  
  if (alertsState.filterCategory != null) {
    list = list.where((a) => a.category == alertsState.filterCategory).toList();
  }
  return list;
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_member.dart';
import '../services/mock_backend_service.dart';

class FamilyState {
  final List<FamilyMember> members;
  final bool isSosActive;
  final String groupName;
  final String inviteCode;

  const FamilyState({
    this.members = const [],
    this.isSosActive = false,
    this.groupName = 'Kulkarni Family Kumbh Group',
    this.inviteCode = 'NK-2027-SHIV',
  });

  FamilyState copyWith({
    List<FamilyMember>? members,
    bool? isSosActive,
    String? groupName,
    String? inviteCode,
  }) {
    return FamilyState(
      members: members ?? this.members,
      isSosActive: isSosActive ?? this.isSosActive,
      groupName: groupName ?? this.groupName,
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }
}

class FamilyNotifier extends Notifier<FamilyState> {
  @override
  FamilyState build() {
    return FamilyState(members: MockBackendService.instance.getFamilyMembers());
  }

  void triggerSos() {
    state = state.copyWith(isSosActive: true);
    MockBackendService.instance.triggerEmergencySOS(lat: 20.0059, lng: 73.7900);
  }

  void cancelSos() {
    state = state.copyWith(isSosActive: false);
  }

  void addMember(FamilyMember member) {
    state = state.copyWith(members: [...state.members, member]);
  }
}

final familyProvider = NotifierProvider<FamilyNotifier, FamilyState>(FamilyNotifier.new);

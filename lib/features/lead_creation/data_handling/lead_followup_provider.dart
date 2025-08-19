import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/services/follow_up/followup_service.dart';

/// ✅ State model for Followup
class FollowupState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? followupResult;

  FollowupState({this.isLoading = false, this.error, this.followupResult});

  FollowupState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? followupResult,
  }) {
    return FollowupState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      followupResult: followupResult ?? this.followupResult,
    );
  }
}

/// ✅ Notifier that manages followup state
class FollowupNotifier extends StateNotifier<FollowupState> {
  final FollowupService _followupService;

  FollowupNotifier(this._followupService) : super(FollowupState());

  /// Generate followup for a lead
  Future<void> generateFollowup({
    required String leadId,
    required String goal,
    required int durationDays,
    required String channel,
    String? emailTemplate,
    String? linkedinTemplate,
    String? callTalkingPoint,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _followupService.generateFollowup(
        leadId: leadId,
        goal: goal,
        durationDays: durationDays,
        channel: channel,
        emailTemplate: emailTemplate,
        linkedinTemplate: linkedinTemplate,
        callTalkingPoint: callTalkingPoint,
      );

      state = state.copyWith(followupResult: response.data);
    } on DioException catch (e) {
      state = state.copyWith(error: e.response?.data.toString() ?? e.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

/// ✅ Riverpod provider
final followupProvider = StateNotifierProvider<FollowupNotifier, FollowupState>(
  (ref) {
    return FollowupNotifier(FollowupService());
  },
);

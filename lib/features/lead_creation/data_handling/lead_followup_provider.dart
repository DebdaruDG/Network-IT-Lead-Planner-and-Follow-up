import 'dart:developer' as console;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/services/follow_up/followup_service.dart';

/// ✅ State model for Followup
class FollowupState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? followupResult;
  final String? selectedGoal;
  final int? durationDays;
  final List<String>? selectedChannels;
  final String? emailTemplate;
  final String? linkedinTemplate;
  final String? callTalkingPoint;
  final String? frequency; // <-- new
  final DateTime? scheduleStart; // <-- new

  FollowupState({
    this.isLoading = false,
    this.error,
    this.followupResult,
    this.selectedGoal,
    this.durationDays,
    this.selectedChannels,
    this.emailTemplate,
    this.linkedinTemplate,
    this.callTalkingPoint,
    this.frequency,
    this.scheduleStart,
  });

  FollowupState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? followupResult,
    String? selectedGoal,
    int? durationDays,
    List<String>? selectedChannels,
    String? emailTemplate,
    String? linkedinTemplate,
    String? callTalkingPoint,
    String? frequency,
    DateTime? scheduleStart,
  }) {
    return FollowupState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      followupResult: followupResult ?? this.followupResult,
      selectedGoal: selectedGoal ?? this.selectedGoal,
      durationDays: durationDays ?? this.durationDays,
      selectedChannels: selectedChannels ?? this.selectedChannels,
      emailTemplate: emailTemplate ?? this.emailTemplate,
      linkedinTemplate: linkedinTemplate ?? this.linkedinTemplate,
      callTalkingPoint: callTalkingPoint ?? this.callTalkingPoint,
      frequency: frequency ?? this.frequency,
      scheduleStart: scheduleStart ?? this.scheduleStart,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isLoading": isLoading,
      "error": error,
      "followupResult": followupResult,
      "selectedGoal": selectedGoal,
      "durationDays": durationDays,
      "selectedChannels": selectedChannels,
      "emailTemplate": emailTemplate,
      "linkedinTemplate": linkedinTemplate,
      "callTalkingPoint": callTalkingPoint,
    };
  }
}

/// ✅ Notifier that manages followup state
class FollowupNotifier extends StateNotifier<FollowupState> {
  final FollowupService _followupService;

  FollowupNotifier(this._followupService) : super(FollowupState());

  /// Update selected goal
  void updateGoal(String goal) {
    state = state.copyWith(selectedGoal: goal);
  }

  /// Update duration days
  void updateDuration(int days) {
    state = state.copyWith(durationDays: days);
  }

  /// Update selected channels (list of backend values like ['email', 'linkedin'])
  void updateChannels(List<String> channels) {
    state = state.copyWith(selectedChannels: channels);
  }

  /// Update email template
  void updateEmailTemplate(String? template) {
    state = state.copyWith(emailTemplate: template);
  }

  /// Update LinkedIn template
  void updateLinkedinTemplate(String? template) {
    state = state.copyWith(linkedinTemplate: template);
  }

  /// Update call talking point
  void updateCallTalkingPoint(String? talkingPoint) {
    state = state.copyWith(callTalkingPoint: talkingPoint);
  }

  void updateFrequency(String frequency) =>
      state = state.copyWith(frequency: frequency);

  void updateScheduleStart(DateTime date) =>
      state = state.copyWith(scheduleStart: date);

  /// Generate followup for a lead using stored state
  Future<void> generateFollowup({required String leadId}) async {
    console.log('state.selectedGoal - ${state.selectedGoal}');
    console.log('state.durationDays - ${state.durationDays}');
    console.log('state.selectedChannels - ${state.selectedChannels}');
    if (state.selectedGoal == null ||
        state.durationDays == null ||
        state.selectedChannels == null) {
      state = state.copyWith(
        error: 'Missing required selections (goal, duration, channels)',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _followupService.generateFollowup(
        leadId: leadId,
        goal: state.selectedGoal!,
        durationDays: state.durationDays!,
        channel: state.selectedChannels ?? [],
        emailTemplate: state.emailTemplate,
        linkedinTemplate: state.linkedinTemplate,
        callTalkingPoint: state.callTalkingPoint,
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

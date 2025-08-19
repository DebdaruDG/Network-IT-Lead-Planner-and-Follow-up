import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/services/lead/leads_service.dart';

/// ✅ Lead State model
class LeadState {
  final bool isLoading;
  final String? error;
  final List<dynamic> leads;
  final Map<String, dynamic>? selectedLeadTasks;

  LeadState({
    this.isLoading = false,
    this.error,
    this.leads = const [],
    this.selectedLeadTasks,
  });

  LeadState copyWith({
    bool? isLoading,
    String? error,
    List<dynamic>? leads,
    Map<String, dynamic>? selectedLeadTasks,
  }) {
    return LeadState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      leads: leads ?? this.leads,
      selectedLeadTasks: selectedLeadTasks ?? this.selectedLeadTasks,
    );
  }
}

/// ✅ LeadNotifier (manages state & calls LeadService)
class LeadNotifier extends StateNotifier<LeadState> {
  final LeadService _leadService;

  LeadNotifier(this._leadService) : super(LeadState());

  /// Add a new lead
  Future<void> addLead({
    required String email,
    String? leadName,
    String? company,
    String? linkedIn,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _leadService.addLead(
        email: email,
        leadName: leadName,
        company: company,
        linkedIn: linkedIn,
        phone: phone,
      );
      await fetchLeads(); // refresh after add
    } on DioException catch (e) {
      state = state.copyWith(error: e.response?.data.toString() ?? e.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Fetch all leads
  Future<void> fetchLeads() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _leadService.getLeads();
      state = state.copyWith(leads: response.data is List ? response.data : []);
    } on DioException catch (e) {
      state = state.copyWith(error: e.response?.data.toString() ?? e.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Fetch tasks for a given lead
  Future<void> fetchLeadTasks(String leadId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _leadService.getLeadTasks(leadId);
      state = state.copyWith(selectedLeadTasks: response.data);
    } on DioException catch (e) {
      state = state.copyWith(error: e.response?.data.toString() ?? e.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

/// ✅ Riverpod provider
final leadProvider = StateNotifierProvider<LeadNotifier, LeadState>((ref) {
  return LeadNotifier(LeadService());
});

import 'dart:developer' as console;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/models/lead_model.dart';
import '../../../core/models/lead_plan_response.dart';
import '../../../core/services/lead/leads_service.dart';

/// ✅ Lead State model
class LeadState {
  final bool isLoading;
  final String? error;
  final String? leadId;
  final List<LeadModel> leads;
  final List<Plan> selectedLeadPlans;

  LeadState({
    this.isLoading = false,
    this.error,
    this.leadId,
    this.leads = const [],
    this.selectedLeadPlans = const [],
  });

  LeadState copyWith({
    bool? isLoading,
    String? error,
    String? leadId,
    List<LeadModel>? leads,
    List<Plan>? selectedLeadPlans,
  }) {
    return LeadState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      leadId: leadId ?? this.leadId,
      leads: leads ?? this.leads,
      selectedLeadPlans: selectedLeadPlans ?? this.selectedLeadPlans,
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

      final results = response.data['Results'] as List? ?? [];

      final List<dynamic> leadInfoList =
          results.isNotEmpty ? (results[0]['LeadInfo'] as List? ?? []) : [];

      final List<LeadModel> leads =
          leadInfoList
              .map((item) => LeadModel.fromJson(item as Map<String, dynamic>))
              .toList();

      state = state.copyWith(leads: leads);
    } on DioException catch (e) {
      console.log('error - $e');
      state = state.copyWith(error: e.response?.data.toString() ?? e.message);
    } catch (e) {
      console.log('error - $e');
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Fetch plans for a given lead
  Future<void> fetchLeadPlans({required String leadId, String? planId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _leadService.getLeadPlans(
        leadId: leadId,
        planId: planId,
      );

      final results = response.results;
      if (results.isEmpty) {
        state = state.copyWith(selectedLeadPlans: []);
        return;
      }

      console.log('results length: ${results.length}');

      final firstResult = results.first; // this is already LeadResult
      console.log('firstResult runtimeType: ${firstResult.runtimeType}');

      // If your LeadResult already has leadInfo/plans inside
      final plans = firstResult.leadInfo.plans;
      state = state.copyWith(selectedLeadPlans: plans);
    } on DioException catch (e) {
      state = state.copyWith(error: e.response?.data.toString() ?? e.message);
    } catch (e, st) {
      console.log('Unexpected error: $e\n$st');
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Update the leadId in the state
  void updateLeadId(String? newLeadId) {
    state = state.copyWith(leadId: newLeadId);
  }
}

/// ✅ Riverpod provider
final leadProvider = StateNotifierProvider<LeadNotifier, LeadState>((ref) {
  return LeadNotifier(LeadService());
});

final currentLeadIdProvider = StateProvider<String?>((ref) => null);

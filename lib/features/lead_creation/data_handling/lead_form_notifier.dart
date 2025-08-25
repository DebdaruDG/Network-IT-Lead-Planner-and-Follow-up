import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/lead_plan_response.dart'; // Import for LeadInfo

class LeadFormState {
  final String leadName;
  final String company;
  final String email;
  final String? linkedin;
  final String? phone;

  LeadFormState({
    this.leadName = '',
    this.company = '',
    this.email = '',
    this.linkedin,
    this.phone,
  });

  LeadFormState copyWith({
    String? leadName,
    String? company,
    String? email,
    String? linkedin,
    String? phone,
  }) {
    return LeadFormState(
      leadName: leadName ?? this.leadName,
      company: company ?? this.company,
      email: email ?? this.email,
      linkedin: linkedin ?? this.linkedin,
      phone: phone ?? this.phone,
    );
  }
}

class LeadFormNotifier extends StateNotifier<LeadFormState> {
  LeadFormNotifier() : super(LeadFormState());

  void updateLeadName(String leadName) {
    state = state.copyWith(leadName: leadName);
  }

  void updateCompany(String company) {
    state = state.copyWith(company: company);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateLinkedin(String? linkedin) {
    state = state.copyWith(linkedin: linkedin);
  }

  void updatePhone(String? phone) {
    state = state.copyWith(phone: phone);
  }

  void reset() {
    state = LeadFormState();
  }

  void initializeFromLeadInfo(LeadInfo? leadInfo) {
    if (leadInfo == null) return;
    state = LeadFormState(
      leadName: leadInfo.leadName,
      company: leadInfo.company,
      email: leadInfo.email,
      linkedin: leadInfo.linkedIn,
      phone: leadInfo.phone,
    );
  }
}

final leadFormProvider = StateNotifierProvider<LeadFormNotifier, LeadFormState>(
  (ref) {
    return LeadFormNotifier();
  },
);

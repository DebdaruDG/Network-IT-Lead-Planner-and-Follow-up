import 'package:dio/dio.dart';
import '../../models/lead_plan_response.dart';
import '../../preferences/user_preferences.dart';
import '../api_service.dart';

class LeadService {
  final ApiService _apiService = ApiService();

  // ✅ API Config
  static const String _baseURL =
      "https://o3osprfadl.execute-api.eu-west-2.amazonaws.com/Dev";
  static const String _leadEndpoint = "/lead";
  static const String _apiKey = "oJuPUA89sUd7X7ubswoD8KQKjceoIF72LAZDMPxg";

  /// Add a Lead
  Future<Response> upsertLead({
    required String email,
    String? leadName,
    String? company,
    String? linkedIn,
    String? phone,
    bool forAdd = true,
  }) async {
    final currentUser = await UserPreferences.getUser();
    final data = {
      "Email": email,
      if (leadName != null) "LeadName": leadName,
      if (company != null) "Company": company,
      if (linkedIn != null) "LinkedIn": linkedIn,
      if (phone != null) "Phone": phone,
      if (forAdd) "CreatedBy": currentUser?.userId.toString(),
      if (!forAdd) "UpdatedBy": currentUser?.userId.toString(),
    };

    return await _apiService.put(
      '$_baseURL$_leadEndpoint',
      data: data,
      options: Options(
        headers: {"Content-Type": "application/json", "x-api-key": _apiKey},
      ),
    );
  }

  /// ✅ Fetch all Leads
  Future<Response> getLeads() async {
    final currentUser = await UserPreferences.getUser();
    return await _apiService.get(
      '$_baseURL$_leadEndpoint?CreatedBy=${currentUser?.userId}',
      options: Options(
        headers: {"Content-Type": "application/json", "x-api-key": _apiKey},
      ),
    );
  }

  /// ✅ Fetch Plans for a given LeadId (and optionally PlanId)
  Future<LeadPlanResponse> getLeadPlans({
    required String leadId,
    String? planId,
  }) async {
    final query = {"LeadId": leadId, if (planId != null) "PlanId": planId};

    final response = await _apiService.get(
      '$_baseURL$_leadEndpoint',
      query: query,
      options: Options(
        headers: {"Content-Type": "application/json", "x-api-key": _apiKey},
      ),
    );

    return LeadPlanResponse.fromJson(response.data);
  }
}

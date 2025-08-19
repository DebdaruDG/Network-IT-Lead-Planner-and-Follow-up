import 'package:dio/dio.dart';

import '../api_service.dart';

class LeadService {
  final ApiService _apiService = ApiService();

  // ✅ API Config
  static const String _baseURL =
      "https://o3osprfadl.execute-api.eu-west-2.amazonaws.com/Dev";
  static const String _leadEndpoint = "/lead";
  static const String _apiKey = "oJuPUA89sUd7X7ubswoD8KQKjceoIF72LAZDMPxg";

  /// Only [email] is required, other fields are optional
  Future<Response> addLead({
    required String email,
    String? leadName,
    String? company,
    String? linkedIn,
    String? phone,
  }) async {
    final data = {
      "Email": email,
      if (leadName != null) "LeadName": leadName,
      if (company != null) "Company": company,
      if (linkedIn != null) "LinkedIn": linkedIn,
      if (phone != null) "Phone": phone,
    };

    return await _apiService.post(
      '$_baseURL$_leadEndpoint',
      data: data,
      options: Options(
        headers: {"Content-Type": "application/json", "x-api-key": _apiKey},
      ),
    );
  }

  /// ✅ Fetch all Leads
  Future<Response> getLeads() async {
    return await _apiService.get('$_baseURL$_leadEndpoint', query: {});
  }

  /// ✅ Fetch tasks for a specific leadId
  Future<Response> getLeadTasks(String leadId) async {
    return await _apiService.get("$_leadEndpoint/$leadId/tasks");
  }
}

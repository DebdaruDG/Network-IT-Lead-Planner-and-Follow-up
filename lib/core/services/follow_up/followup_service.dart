import 'dart:developer' as console;

import 'package:dio/dio.dart';
import '../api_service.dart';

class FollowupService {
  final ApiService _apiService = ApiService();

  // ✅ API Config
  static const String _followupEndpoint = "/generate-followup";
  static const String _apiKey = "oJuPUA89sUd7X7ubswoD8KQKjceoIF72LAZDMPxg";

  /// ✅ Generate a follow-up
  /// [leadId] is required. Other fields can be optional depending on use-case.
  Future<Response> generateFollowup({
    required String leadId,
    required String goal,
    required int durationDays,
    required List<String> channel,
    String? emailTemplate,
    String? linkedinTemplate,
    String? callTalkingPoint,
  }) async {
    try {
      final data = {
        "goal": goal,
        "duration_days": durationDays,
        "channel": channel,
        "email_template": emailTemplate,
        "linkedin_template": linkedinTemplate,
        "call_talking_point": callTalkingPoint,
      };
      console.log('service payload - $data');
      console.log('service leadId - $leadId');
      Response response = await _apiService.post(
        "$_followupEndpoint?LeadId=$leadId",
        data: data,
        options: Options(
          headers: {"Content-Type": "application/json", "x-api-key": _apiKey},
        ),
      );
      console.log('service response.statusCode - ${response.statusCode}');
      return response;
    } catch (err) {
      console.log('err :- $err');
      rethrow;
    }
  }
}

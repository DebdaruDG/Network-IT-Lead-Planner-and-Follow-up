class LeadPlanResponse {
  final String requestId;
  final bool success;
  final String statusCode;
  final String message;
  final List<LeadResult> results;

  LeadPlanResponse({
    required this.requestId,
    required this.success,
    required this.statusCode,
    required this.message,
    required this.results,
  });

  factory LeadPlanResponse.fromJson(Map<String, dynamic> json) {
    return LeadPlanResponse(
      requestId: json["RequestId"] ?? "",
      success: json["Success"] ?? false,
      statusCode: json["StatusCode"] ?? "",
      message: json["Message"] ?? "",
      results:
          (json["Results"] as List<dynamic>?)
              ?.map((e) => LeadResult.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class LeadResult {
  final LeadInfo leadInfo;

  LeadResult({required this.leadInfo});

  factory LeadResult.fromJson(Map<String, dynamic> json) {
    return LeadResult(leadInfo: LeadInfo.fromJson(json["LeadInfo"] ?? {}));
  }
}

class LeadInfo {
  final int leadId;
  final String leadName;
  final String email;
  final String? phone;
  final String company;
  final String? linkedIn;
  final List<Plan> plans;

  LeadInfo({
    required this.leadId,
    required this.leadName,
    required this.email,
    this.phone,
    required this.company,
    this.linkedIn,
    required this.plans,
  });

  factory LeadInfo.fromJson(Map<String, dynamic> json) {
    return LeadInfo(
      leadId: json["LeadId"] ?? 0,
      leadName: json["LeadName"] ?? "",
      email: json["Email"] ?? "",
      phone: json["Phone"],
      company: json["Company"] ?? "",
      linkedIn: json["LinkedIn"],
      plans:
          (json["Plans"] as List<dynamic>?)
              ?.map((e) => Plan.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Plan {
  final int planId;
  final int leadId;
  final String goal;
  final int durationDays;
  final String preferredChannels;
  final String? emailTemplate;
  final String? linkedInTemplate;
  final String? callTalkingPoint;

  Plan({
    required this.planId,
    required this.leadId,
    required this.goal,
    required this.durationDays,
    required this.preferredChannels,
    this.emailTemplate,
    this.linkedInTemplate,
    this.callTalkingPoint,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planId: json["PlanId"] ?? 0,
      leadId: json["LeadId"] ?? 0,
      goal: json["Goal"] ?? "",
      durationDays: json["DurationDays"] ?? 0,
      preferredChannels: json["PreferredChannels"] ?? "",
      emailTemplate: json["EmailTemplate"],
      linkedInTemplate: json["LinkedInTemplate"],
      callTalkingPoint: json["CallTalkingPoint"],
    );
  }
}

import 'dart:convert';

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
  final List<String> preferredChannels; // flattened + unique
  final String? emailTemplate;
  final String? linkedInTemplate;
  final String? callTalkingPoint;
  final List<Task> tasks;

  Plan({
    required this.planId,
    required this.leadId,
    required this.goal,
    required this.durationDays,
    required this.preferredChannels,
    this.emailTemplate,
    this.linkedInTemplate,
    this.callTalkingPoint,
    required this.tasks,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    List<String> parsedChannels = [];

    dynamic raw = json["PreferredChannels"];
    if (raw != null) {
      // If it's a string, try decoding it
      if (raw is String) {
        try {
          raw = jsonDecode(raw);
        } catch (_) {
          raw = [];
        }
      }

      // Now raw can be List<dynamic>
      if (raw is List) {
        // Case 1: List<String>
        if (raw.isNotEmpty && raw.first is String) {
          parsedChannels = raw.cast<String>();
        }
        // Case 2: List<List<String>>
        else if (raw.isNotEmpty && raw.first is List) {
          parsedChannels =
              raw.expand((e) => (e as List).map((x) => x.toString())).toList();
        }
      }
    }

    // Ensure unique values
    parsedChannels = parsedChannels.toSet().toList();

    return Plan(
      planId: json["PlanId"] ?? 0,
      leadId: json["LeadId"] ?? 0,
      goal: json["Goal"] ?? "",
      durationDays: json["DurationDays"] ?? 0,
      preferredChannels: parsedChannels,
      emailTemplate: json["EmailTemplate"],
      linkedInTemplate: json["LinkedInTemplate"],
      callTalkingPoint: json["CallTalkingPoint"],
      tasks:
          (json["Tasks"] as List<dynamic>?)
              ?.map((e) => Task.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "PlanId": planId,
      "LeadId": leadId,
      "Goal": goal,
      "DurationDays": durationDays,
      "PreferredChannels": preferredChannels, // returns flat List<String>
      "EmailTemplate": emailTemplate,
      "LinkedInTemplate": linkedInTemplate,
      "CallTalkingPoint": callTalkingPoint,
      "Tasks": tasks.map((task) => task.toJson()).toList(),
    };
  }
}

class Task {
  final String taskId;
  final String startDate;
  final List<String> channel;
  final String templateType;
  final String templateContent;

  Task({
    required this.taskId,
    required this.startDate,
    required this.channel,
    required this.templateType,
    required this.templateContent,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json["TaskId"] ?? "",
      startDate: json["StartDate"] ?? "",
      channel:
          (json["Channel"] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      templateType: json["template_type"] ?? "",
      templateContent: json["template_content"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "TaskId": taskId,
      "StartDate": startDate,
      "Channel": channel,
      "template_type": templateType,
      "template_content": templateContent,
    };
  }
}

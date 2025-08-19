import 'package:flutter/material.dart';

class LeadModel {
  final int leadId;
  final String leadName;
  final String email;
  final String? phone;
  final String? company;
  final String? linkedIn;
  final String? location;
  final String? budget;
  final String? status;
  final String? notes;
  final String? source;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  // ✅ Extra fields for UI
  final String? goal;
  final int? progress; // stored as percentage 0–100
  final String? responsivenessText;
  final Color? responsivenessColor;
  final String? nextStep;

  LeadModel({
    required this.leadId,
    required this.leadName,
    required this.email,
    this.phone,
    this.company,
    this.linkedIn,
    this.location,
    this.budget,
    this.status,
    this.notes,
    this.source,
    this.createdDate,
    this.updatedDate,
    this.goal,
    this.progress,
    this.responsivenessText,
    this.responsivenessColor,
    this.nextStep,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      leadId: json['LeadId'] as int,
      leadName: json['LeadName'] ?? '',
      email: json['Email'] ?? '',
      phone: json['Phone'],
      company: json['Company'],
      linkedIn: json['LinkedIn'],
      location: json['Location'],
      budget: json['Budget'],
      status: json['Status'],
      notes: json['Notes'],
      source: json['Source'],
      createdDate:
          json['CreatedDate'] != null
              ? DateTime.tryParse(json['CreatedDate'])
              : null,
      updatedDate:
          json['UpdatedDate'] != null
              ? DateTime.tryParse(json['UpdatedDate'])
              : null,

      // 👇 API may or may not send these (use fallback in UI if null)
      goal: json['Goal'],
      progress:
          json['Progress'] != null ? (json['Progress'] as num).toInt() : null,
      responsivenessText: json['ResponsivenessText'],
      responsivenessColor: null, // Color can't be serialized, map later
      nextStep: json['NextStep'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "LeadId": leadId,
      "LeadName": leadName,
      "Email": email,
      "Phone": phone,
      "Company": company,
      "LinkedIn": linkedIn,
      "Location": location,
      "Budget": budget,
      "Status": status,
      "Notes": notes,
      "Source": source,
      "CreatedDate": createdDate?.toIso8601String(),
      "UpdatedDate": updatedDate?.toIso8601String(),
      "Goal": goal,
      "Progress": progress,
      "ResponsivenessText": responsivenessText,
      "NextStep": nextStep,
      // responsivenessColor deliberately excluded
    };
  }
}

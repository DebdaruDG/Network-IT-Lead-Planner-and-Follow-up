import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_routes.dart';
import '../../../core/models/lead_model.dart';
import '../../lead_creation/data_handling/lead_provider.dart';

class LeadsTable extends ConsumerStatefulWidget {
  const LeadsTable({super.key});

  @override
  ConsumerState<LeadsTable> createState() => _LeadsTableState();
}

class _LeadsTableState extends ConsumerState<LeadsTable> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await ref.read(leadProvider.notifier).fetchLeads();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(leadProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleRow(context),
            const SizedBox(height: 20),
            _tableHeader(),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 12),

            /// ✅ State Handling
            if (state.isLoading)
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF001BCE),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text("Fetching Leads ..."),
                  ],
                ),
              )
            else if (state.error != null)
              Center(
                child: Text(
                  "Error: ${state.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (state.leads.isEmpty)
              const Center(
                child: Text(
                  "No leads found",
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              )
            else
              _leadsList(state.leads, context),

            const SizedBox(height: 24),
            _footerLegend(),
          ],
        ),
      ),
    );
  }

  /// -------------------------------
  /// 🔹 Widgets
  /// -------------------------------

  Widget _titleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Leads",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => context.go(AppRoutes.leadCreation),
          child: const Text(
            "+ Add Lead",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _tableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _headerText("Lead"),
        _headerText("Goal"),
        _headerText("Progress"),
        _headerText("Responsiveness"),
        _headerText("Next Step"),
        _headerText("         "),
      ],
    );
  }

  Widget _leadsList(List<LeadModel> leads, BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < leads.length; i++) ...[
          _leadRowFromModel(leads[i], context),
          if (i != leads.length - 1) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }

  Widget _footerLegend() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        children: [
          TextSpan(text: "Responsiveness scale: "),
          TextSpan(text: "Fast ", style: TextStyle(color: Color(0xFF059669))),
          TextSpan(text: "< 24h  "),
          TextSpan(text: "Slow ", style: TextStyle(color: Color(0xFFB45309))),
          TextSpan(text: "≥ 72h  Unknown"),
        ],
      ),
    );
  }

  /// -------------------------------
  /// 🔹 Helpers
  /// -------------------------------

  Widget _headerText(String text) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 14,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _leadRowFromModel(LeadModel lead, BuildContext context) {
    final leadName = lead.leadName;
    final company = lead.company ?? "InoChem";
    final role = lead.goal ?? "Ops Director"; // if extended in model
    final goal = lead.goal ?? "Book a meeting";
    final progress = (lead.progress ?? 40) / 100;
    final responsivenessText = lead.responsivenessText ?? "Replied in 1d";
    final responsivenessColor =
        lead.responsivenessColor ?? const Color(0xFF059669);
    final nextStep = lead.nextStep ?? "LinkedIn message · Tomorrow";

    return _leadRow(
      leadId: lead.leadId,
      leadName: leadName,
      subText: "$company · $role",
      goal: goal,
      progress: progress,
      responsivenessText: responsivenessText,
      responsivenessColor: responsivenessColor,
      nextStep: nextStep,
      context: context,
    );
  }

  Widget _leadRow({
    required int leadId,
    required String leadName,
    required String subText,
    required String goal,
    required double progress,
    required String responsivenessText,
    required Color responsivenessColor,
    required String nextStep,
    required BuildContext context,
  }) {
    return Row(
      children: [
        // Lead column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leadName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                subText,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),

        // Goal
        Expanded(
          child: Text(
            goal,
            style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
          ),
        ),

        // Progress
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: LinearProgressIndicator(
              value: progress,
              color: const Color(0xFF4F46E5),
              backgroundColor: const Color(0xFFE2E8F0),
              minHeight: 6,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Responsiveness
        Expanded(
          child: Text(
            responsivenessText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: responsivenessColor,
            ),
          ),
        ),

        // Next Step
        Expanded(
          child: Text(
            nextStep,
            style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
          ),
        ),

        // Action
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                minimumSize: const Size(0, 36),
              ),
              onPressed:
                  () => context.go('${AppRoutes.leadCreation}?leadId=$leadId'),
              child: const Text(
                "Open",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

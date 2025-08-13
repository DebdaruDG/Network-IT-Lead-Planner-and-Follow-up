import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_routes.dart';

class LeadsTable extends StatelessWidget {
  const LeadsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _headerText("Lead"),
              _headerText("Goal"),
              _headerText("Progress"),
              _headerText("Responsiveness"),
              _headerText("Next Step"),
              _headerText("         "),
            ],
          ),
          const SizedBox(height: 12),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),

          // Row 1
          _leadRow(
            leadName: "R. Patel",
            subText: "InoChem · Ops Director",
            goal: "Book a meeting",
            progress: 0.4,
            responsivenessText: "Replied in 1d",
            responsivenessColor: const Color(0xFF059669),
            nextStep: "LinkedIn message · Tomorrow",
            context: context,
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),

          // Row 2
          _leadRow(
            leadName: "A. Khan",
            subText: "FPI · AI Lead",
            goal: "Share proposal",
            progress: 0.7,
            responsivenessText: "Slow · 4d",
            responsivenessColor: const Color(0xFFB45309),
            nextStep: "Email · Today",
            context: context,
          ),

          const SizedBox(height: 24),

          // Footer Legend
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              children: [
                TextSpan(text: "Responsiveness scale: "),
                TextSpan(
                  text: "Fast ",
                  style: TextStyle(color: Color(0xFF059669)),
                ),
                TextSpan(text: "< 24h  "),
                TextSpan(
                  text: "Slow ",
                  style: TextStyle(color: Color(0xFFB45309)),
                ),
                TextSpan(text: "≥ 72h  Unknown"),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _leadRow({
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

        // Goal column
        Expanded(
          child: Text(
            goal,
            style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
          ),
        ),

        // Progress column
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

        // Responsiveness column
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

        // Next step column
        Expanded(
          child: Text(
            nextStep,
            style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
          ),
        ),

        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
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
              onPressed: () => context.go(AppRoutes.leadCreation),
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

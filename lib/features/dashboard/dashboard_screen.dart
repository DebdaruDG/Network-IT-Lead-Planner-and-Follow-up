import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF233B7A),
        actionsPadding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width * 0.1,
        ),
        title: Container(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "N",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Manrope",
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "NetworkIt",
                style: TextStyle(
                  fontFamily: "Manrope",
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.15),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => context.go(AppRoutes.leadCreation),
            child: const Text("+ Add Lead"),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.09,
        ),
        child: Column(
          children: [
            // Summary cards
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                SummaryCard(
                  title: "Active Leads",
                  value: "12",
                  progress: 0.62,
                  subtitle: '62% have a plan',
                ),
                SummaryCard(
                  title: "Avg. Responsiveness",
                  value: "Fast",
                  subtitle: 'Median reply in 18h',
                ),
                SummaryCard(
                  title: "Tasks Due Today",
                  value: "7",
                  subtitle: '3 Email - 2 LI - 2 Calls',
                ),
                SummaryCard(
                  title: "This Week",
                  value: "68%",
                  subtitle: 'Plan completion rate',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Leads table placeholder
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: const Center(child: Text("Leads Table Placeholder")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final double? progress;
  final String? subtitle;
  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.progress,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              color: Color(0xFF4F46E5),
              backgroundColor: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(8),
            ),
          ],
          if ((subtitle ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle ?? '',
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ],
      ),
    );
  }
}

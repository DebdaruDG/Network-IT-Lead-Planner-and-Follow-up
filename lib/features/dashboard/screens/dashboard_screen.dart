import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/animation_constants.dart';
import '../../../core/utils/nav_bar.dart';
import 'leads_table.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width <= 920;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const NetworkItAppBar(title: "NetworkIt", showAddLead: true),
      body: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        margin: EdgeInsets.symmetric(
          horizontal:
              isMobile
                  ? MediaQuery.of(context).size.width * 0.05
                  : MediaQuery.of(context).size.width * 0.09,
        ),
        child: Column(
          children: [
            // Summary cards
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: isMobile ? 2 : 4,
              childAspectRatio: isMobile ? 2.2 : 2.5,
              crossAxisSpacing: isMobile ? 8 : 12,
              mainAxisSpacing: isMobile ? 8 : 12,
              children: [
                SummaryCard(
                  title: "Active Leads",
                  value: "12",
                  progress: 0.62,
                  subtitle: '62% have a plan',
                ).animate(
                  effects:
                      AnimationEffectConstants
                          .usualAnimationEffects['summaryCardAnimation']
                          ?.effectsBuilder,
                ),
                SummaryCard(
                  title: "Avg. Responsiveness",
                  value: "Fast",
                  subtitle: 'Median reply in 18h',
                ).animate(
                  effects:
                      AnimationEffectConstants
                          .usualAnimationEffects['summaryCardAnimation']
                          ?.effectsBuilder,
                ),
                SummaryCard(
                  title: "Tasks Due Today",
                  value: "7",
                  subtitle: '3 Email - 2 LI - 2 Calls',
                ).animate(
                  effects:
                      AnimationEffectConstants
                          .usualAnimationEffects['summaryCardAnimation']
                          ?.effectsBuilder,
                ),
                SummaryCard(
                  title: "This Week",
                  value: "68%",
                  subtitle: 'Plan completion rate',
                ).animate(
                  effects:
                      AnimationEffectConstants
                          .usualAnimationEffects['summaryCardAnimation']
                          ?.effectsBuilder,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Leads table placeholder
            Expanded(child: LeadsTable()),
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
    final isMobile = MediaQuery.of(context).size.width <= 920;

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        // color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isMobile ? 10 : 12,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(height: isMobile ? 2 : 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 16 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (progress != null) ...[
              SizedBox(height: isMobile ? 4 : 8),
              LinearProgressIndicator(
                value: progress,
                color: const Color(0xFF4F46E5),
                backgroundColor: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(8),
              ),
            ],
            if ((subtitle ?? '').isNotEmpty) ...[
              SizedBox(height: isMobile ? 2 : 4),
              Text(
                subtitle ?? '',
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

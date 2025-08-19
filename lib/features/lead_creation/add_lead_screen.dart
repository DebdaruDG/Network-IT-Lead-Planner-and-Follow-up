import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_routes.dart';
import '../../core/utils/nav_bar.dart';
import 'lead_creation_provider.dart';
import 'steps/step1_add_lead.dart';
import 'steps/step2_select_goal.dart';
import 'steps/step3_plan_setup.dart';
import 'steps/step4_select_instructions.dart';
import 'steps/step5_plan_steps.dart';
import 'steps/step6_plan_overview.dart';

class AddLeadScreen extends ConsumerStatefulWidget {
  final String? leadId;
  const AddLeadScreen({super.key, this.leadId});

  @override
  ConsumerState<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends ConsumerState<AddLeadScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(leadStepProvider);

    final steps = [
      "Add Lead",
      "Select Goal",
      "Generate Plan",
      "Select Instructions",
      "Execute Tasks",
      "Track Progress",
    ];

    final stepWidgets = [
      Step1LeadDetailsForm(),
      const Step2GoalSelection(),
      const Step3PlanSetup(),
      const Step4Instructions(),
      Step5ExecuteTasks(leadId: widget.leadId),
      const Step6TrackProgress(),
    ];

    final titles = [
      "Add a new lead",
      "Select a goal",
      "Plan generation",
      "Plan generation",
      "Execute tasks",
      "Track progress",
    ];

    final subtitles = [
      "Start the journey by saving a lead.",
      "What do we want to achieve?",
      "Evenly spaced steps over the chosen duration.",
      "Pick a template for each step.",
      "Email and LinkedIn show 'sent' (simulated). Calls show 'Call Now'",
      "Simple progress and responsive view (mock).",
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFD),
      appBar: NetworkItAppBar(
        title: "NetworkIt",
        showAddLead: false,
        extraActions: [
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.15),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => context.go(AppRoutes.dashboard),
            child: const Text("Go Back"),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: MediaQuery.of(context).size.height * 0.05,
        ),
        child: Row(
          children: [
            /// LEFT SIDE - Custom stepper
            Container(
              width: MediaQuery.of(context).size.width * 0.18,
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Journey',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Manrope",
                        color: Color(0xFF1D2939),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                      itemCount: steps.length,
                      itemBuilder: (context, index) {
                        final isActive = index == currentStep;
                        final isCompleted = index < currentStep;

                        return InkWell(
                          onTap: () {
                            ref.read(leadStepProvider.notifier).goToStep(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isActive
                                      ? const Color(
                                        0xFF4338CA,
                                      ).withOpacity(0.05)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Stack(
                              children: [
                                if (isActive)
                                  Positioned(
                                    top: 2,
                                    bottom: 2,
                                    child: Container(
                                      width: 2.75,
                                      decoration: BoxDecoration(
                                        color: Color(
                                          0xFF4338CA,
                                        ).withOpacity(0.8),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          color:
                                              isActive
                                                  ? const Color(0xFF4338CA)
                                                  : isCompleted
                                                  ? const Color(
                                                    0xFF4338CA,
                                                  ).withOpacity(0.1)
                                                  : Colors.grey.shade200,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                            color:
                                                isActive
                                                    ? Colors.white
                                                    : const Color(0xFF4338CA),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        steps[index],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              isActive
                                                  ? Colors.black
                                                  : Colors.grey.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lead Context (mock)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Manrope",
                            color: Color(0xFF1D2939),
                            letterSpacing: 0.35,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Company, Role, Notes can live here.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Manrope",
                            color: Colors.grey.shade700,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // RIGHT SIDE
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAFC),
                margin: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titles[currentStep],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1D2939),
                        letterSpacing: 0.1,
                        fontFamily: "Manrope",
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitles[currentStep],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF667085),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(child: stepWidgets[currentStep]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

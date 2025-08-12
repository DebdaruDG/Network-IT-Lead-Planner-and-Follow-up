import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_routes.dart';
import 'lead_creation_provider.dart';
import 'steps/step1_lead_details.dart';
import 'steps/step2_select_goal.dart';
import 'steps/step3_plan_setup.dart';
import 'steps/step4_contact_info.dart';
import 'steps/step5_plan_steps.dart';
import 'steps/step6_plan_overview.dart';

class AddLeadScreen extends ConsumerWidget {
  const AddLeadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      const Step1LeadDetailsForm(),
      const Step2GoalSelection(),
      const Step3PlanSetup(),
      const Step4Instructions(),
      const Step5ExecuteTasks(),
      const Step6TrackProgress(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFD),
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
            onPressed: () => context.go(AppRoutes.dashboard),
            child: const Text("Go Back"),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Text(
                      'Journey',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Manrope",
                        color: const Color(0xFF1D2939),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                      itemCount: steps.length,
                      itemBuilder: (context, index) {
                        final isActive = index == currentStep;
                        final isCompleted = index < currentStep;

                        return InkWell(
                          onTap: () {
                            ref.read(leadStepProvider.notifier).state = index;
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                // Step number circle
                                Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color:
                                        isActive
                                            ? const Color(0xFF233B7A)
                                            : isCompleted
                                            ? const Color(
                                              0xFF233B7A,
                                            ).withOpacity(0.1)
                                            : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color:
                                          isActive
                                              ? const Color(0xFF233B7A)
                                              : Colors.grey.shade200,
                                      width: 1.5,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      color:
                                          isActive
                                              ? Colors.white
                                              : const Color(0xFF233B7A),
                                      fontWeight:
                                          isActive
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Step title
                                Text(
                                  steps[index],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF98A2B3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // RIGHT SIDE - Step content
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAFC),
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      steps[currentStep],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D2939),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Start the journey by saving a lead.",
                      style: TextStyle(fontSize: 14, color: Color(0xFF667085)),
                    ),
                    const SizedBox(height: 24),
                    Expanded(child: stepWidgets[currentStep]),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF233B7A),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (currentStep < steps.length - 1) {
                            ref.read(leadStepProvider.notifier).state++;
                          }
                        },
                        child: const Text(
                          "Save & Continue",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
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

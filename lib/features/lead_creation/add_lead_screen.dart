import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text("Lead Journey")),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep < 5) {
            ref.read(leadStepProvider.notifier).state++;
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            ref.read(leadStepProvider.notifier).state--;
          }
        },
        steps: const [
          Step(title: Text("Add Lead"), content: Step1LeadDetailsForm()),
          Step(title: Text("Select Goal"), content: Step2GoalSelection()),
          Step(title: Text("Generate Plan"), content: Step3PlanSetup()),
          Step(
            title: Text("Select Instructions"),
            content: Step4Instructions(),
          ),
          Step(title: Text("Execute Tasks"), content: Step5ExecuteTasks()),
          Step(title: Text("Track Progress"), content: Step6TrackProgress()),
        ],
      ),
    );
  }
}

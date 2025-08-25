import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_toast.dart';
import '../data_handling/lead_provider.dart';
import '../lead_creation_provider.dart';
import 'components/navigation_button.dart';
import 'components/plan_card.dart';

class Step5ExecuteTasks extends ConsumerStatefulWidget {
  final String? leadId;
  const Step5ExecuteTasks({super.key, this.leadId});

  @override
  ConsumerState<Step5ExecuteTasks> createState() => _Step5ExecuteTasksState();
}

class _Step5ExecuteTasksState extends ConsumerState<Step5ExecuteTasks> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final leadState = ref.watch(leadProvider);
    final isLoading = leadState.isLoading;
    final tasks = leadState.selectedLead?.plans ?? [];

    if (isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (leadState.error != null) {
      return Center(
        child: Text(
          "Error loading tasks: ${leadState.error}",
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          "No tasks found for this lead.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ...tasks.map(
            (task) => PlanCard(
              task: task,
              onExecute: () {
                AppToast.success(
                  context,
                  "Task Executed",
                  subtitle:
                      "Executed ${task.goal} (Plan ${task.planId}) on Day ${task.durationDays}.",
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          NavigationButtons(
            onBack: () => ref.read(leadStepProvider.notifier).previousStep(),
            onContinue: () {
              AppToast.success(
                context,
                "Tasks Ready",
                subtitle: "Proceeding to track progress.",
              );
              ref.read(leadStepProvider.notifier).nextStep();
            },
          ),
        ],
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF001BCE)),
          ),
        ),
        SizedBox(width: 12),
        Text(
          "Fetching Tasks...",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

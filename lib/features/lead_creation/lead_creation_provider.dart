import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sidebar steps → children mapping
final stepWidgets = [
  "Add Lead",
  "Select Goal",
  "Generate Plan",
  "Select Instructions",
  "Execute Tasks",
  "Track Progress",
];

/// Immutable state object
class LeadStepState {
  final int currentStep;
  final bool planExpanded;

  const LeadStepState({required this.currentStep, required this.planExpanded});

  LeadStepState copyWith({int? currentStep, bool? planExpanded}) {
    return LeadStepState(
      currentStep: currentStep ?? this.currentStep,
      planExpanded: planExpanded ?? this.planExpanded,
    );
  }
}

class LeadStepNotifier extends StateNotifier<LeadStepState> {
  LeadStepNotifier()
    : super(const LeadStepState(currentStep: 0, planExpanded: true));

  int get totalSteps => stepWidgets.length;

  // --- Step navigation ---
  void nextStep() {
    if (state.currentStep < totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int index) {
    if (index >= 0 && index < totalSteps) {
      state = state.copyWith(currentStep: index);
    }
  }

  void reset() {
    state = state.copyWith(currentStep: 0);
  }

  // --- Plan related getters ---
  bool get isInsidePlan => state.currentStep >= 1 && state.currentStep <= 3;
  int? get activePlanChildIndex => isInsidePlan ? state.currentStep - 1 : null;

  // --- Expansion state for "Plan" ---
  bool get isPlanExpanded => state.planExpanded;

  void togglePlanExpanded() {
    state = state.copyWith(planExpanded: !state.planExpanded);
  }

  void expandPlan() {
    state = state.copyWith(planExpanded: true);
  }

  void collapsePlan() {
    state = state.copyWith(planExpanded: false);
  }
}

final leadStepProvider = StateNotifierProvider<LeadStepNotifier, LeadStepState>(
  (ref) => LeadStepNotifier(),
);

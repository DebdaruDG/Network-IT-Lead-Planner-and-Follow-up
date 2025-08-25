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

class LeadStepNotifier extends StateNotifier<int> {
  LeadStepNotifier() : super(0);

  // Expansion state for the "Plan" group
  bool _planExpanded = true;

  int get totalSteps => stepWidgets.length;

  // --- Step navigation ---
  void nextStep() {
    if (state < totalSteps - 1) {
      state++;
    }
  }

  void previousStep() {
    if (state > 0) {
      state--;
    }
  }

  void goToStep(int index) {
    if (index >= 0 && index < totalSteps) {
      state = index;
    }
  }

  void reset() {
    state = 0;
  }

  // --- Plan related getters ---
  bool get isInsidePlan => state >= 1 && state <= 3;

  int? get activePlanChildIndex => isInsidePlan ? state - 1 : null;

  // --- Expansion state for "Plan" ---
  bool get isPlanExpanded => _planExpanded;

  void togglePlanExpanded() {
    _planExpanded = !_planExpanded;
    // notify listeners → state has to change
    state = state;
  }

  void expandPlan() {
    _planExpanded = true;
    state = state;
  }

  void collapsePlan() {
    _planExpanded = false;
    state = state;
  }
}

final leadStepProvider = StateNotifierProvider<LeadStepNotifier, int>(
  (ref) => LeadStepNotifier(),
);

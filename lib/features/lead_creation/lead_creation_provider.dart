import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sidebar steps → children mapping
/// Matches the same structure you defined in the UI
final stepWidgets = [
  "Add Lead", // 0
  "Select Goal", // 1
  "Generate Plan", // 2
  "Select Instructions", // 3
  "Execute Tasks", // 4
  "Track Progress", // 5
];

class LeadStepNotifier extends StateNotifier<int> {
  LeadStepNotifier() : super(0);

  int get totalSteps => stepWidgets.length;

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

  /// Returns `true` if the current step is inside "Plan"
  bool get isInsidePlan => state >= 1 && state <= 3;

  /// Returns the index of the active child inside Plan
  /// (0 = Select Goal, 1 = Generate Plan, 2 = Select Instructions)
  int? get activePlanChildIndex => isInsidePlan ? state - 1 : null;
}

final leadStepProvider = StateNotifierProvider<LeadStepNotifier, int>(
  (ref) => LeadStepNotifier(),
);

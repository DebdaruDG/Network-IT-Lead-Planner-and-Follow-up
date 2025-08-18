import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeadStepNotifier extends StateNotifier<int> {
  LeadStepNotifier() : super(0);

  final int totalSteps = 6; // keep in sync with steps.length

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
}

final leadStepProvider = StateNotifierProvider<LeadStepNotifier, int>(
  (ref) => LeadStepNotifier(),
);

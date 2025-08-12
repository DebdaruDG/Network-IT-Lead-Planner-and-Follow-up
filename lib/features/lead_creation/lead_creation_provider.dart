import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the current step index for lead creation
final leadStepProvider = StateProvider<int>((ref) => 0);

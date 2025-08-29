import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/widgets/searchable_dropdowns.dart';
import '../../data_handling/lead_followup_provider.dart';

class FrequencyDropdown extends ConsumerWidget {
  const FrequencyDropdown({super.key});

  static final List<String> _options = [
    "Daily",
    "Alternate Day",
    "Weekly",
    "Bi-Weekly",
    "Monthly",
    "Once",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(followupProvider).frequency ?? "Weekly";

    return SearchableDropdown(
      items: _options,
      label: "Frequency",
      initialValue: selected,
      onChanged: (val) {
        ref.read(followupProvider.notifier).updateFrequency(val);
      },
    );
  }
}

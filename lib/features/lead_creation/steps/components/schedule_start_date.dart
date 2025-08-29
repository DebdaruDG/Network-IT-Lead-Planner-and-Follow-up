import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/widgets/date_picker.dart';
import '../../data_handling/lead_followup_provider.dart';

class ScheduleStartDatePicker extends ConsumerWidget {
  const ScheduleStartDatePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(followupProvider).scheduleStart;

    return CalendarDatePickerField(
      label: "Schedule Start Date",
      initialDate: selectedDate,
      onChanged: (val) {
        ref.read(followupProvider.notifier).updateScheduleStart(val);
      },
    );
  }
}

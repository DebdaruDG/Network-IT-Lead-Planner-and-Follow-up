import 'package:flutter/material.dart';

class Step1LeadDetailsForm extends StatelessWidget {
  const Step1LeadDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextField(decoration: InputDecoration(labelText: "Lead name")),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(labelText: "Company")),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(labelText: "Email")),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(labelText: "LinkedIn URL")),
      ],
    );
  }
}

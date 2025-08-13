import 'package:flutter/material.dart';

import '../../../core/widgets/app_textfield.dart';

class Step1LeadDetailsForm extends StatelessWidget {
  const Step1LeadDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Wrap each AppTextField in Expanded to constrain its width
              Expanded(
                child: const AppTextField(
                  label: "Lead name",
                  hint: "e.g., Jane Cooper",
                ),
              ),
              const SizedBox(width: 16), // Add spacing between fields
              Expanded(
                child: const AppTextField(label: "Company", hint: "e.g., AOC"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Wrap each AppTextField in Expanded to constrain its width
              Expanded(
                child: const AppTextField(
                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  hint: "name@company.com",
                ),
              ),
              const SizedBox(width: 16), // Add spacing between fields
              Expanded(
                child: const AppTextField(
                  label: "LinkedIn URL",
                  keyboardType: TextInputType.url,
                  hint: "https://www.linkedin.com/in/username",
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111827), // dark navy
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            onPressed: () {},
            child: const Text(
              "Save & Continue",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

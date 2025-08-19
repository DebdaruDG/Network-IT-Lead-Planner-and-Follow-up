import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_handling/lead_provider.dart';
import '../../../core/widgets/app_textfield.dart';
import '../lead_creation_provider.dart'; // for nextStep()

class Step1LeadDetailsForm extends ConsumerWidget {
  Step1LeadDetailsForm({super.key});

  // Controllers to capture field values
  final TextEditingController _leadNameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadState = ref.watch(leadProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lead Name + Company
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppTextField(
                  controller: _leadNameController,
                  label: "Lead name",
                  hint: "e.g., Jane Cooper",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _companyController,
                  label: "Company",
                  hint: "e.g., AOC",
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Email + LinkedIn
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppTextField(
                  controller: _emailController,
                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  hint: "name@company.com",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _linkedinController,
                  label: "LinkedIn URL",
                  keyboardType: TextInputType.url,
                  hint: "https://www.linkedin.com/in/username",
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Phone
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: AppTextField(
            controller: _phoneController,
            label: "Phone Number",
            keyboardType: TextInputType.phone,
            hint: "e.g. +91 9436567890",
          ),
        ),

        const SizedBox(height: 24),

        // Save & Continue button
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111827),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            onPressed: () async {
              final email = _emailController.text.trim();

              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Email is required")),
                );
                return;
              }

              // Call leadProvider to add lead
              await ref
                  .read(leadProvider.notifier)
                  .addLead(
                    email: email,
                    leadName: _leadNameController.text.trim(),
                    company: _companyController.text.trim(),
                    linkedIn: _linkedinController.text.trim(),
                    phone: _phoneController.text.trim(),
                  );

              // Proceed to next step only if no error
              final error = ref.read(leadProvider).error;
              if (error == null) {
                ref.read(leadStepProvider.notifier).nextStep();
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Failed: $error")));
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Save & Continue",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (leadState.isLoading) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/animation_constants.dart';
import '../data_handling/lead_provider.dart';
import '../../../core/widgets/app_textfield.dart';
import '../lead_creation_provider.dart'; // for nextStep()
import '../../../core/widgets/app_toast.dart'; // Assuming AppToast is defined here

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
              ).animate(
                effects:
                    AnimationEffectConstants
                        .usualAnimationEffects['summaryCardAnimation']
                        ?.effectsBuilder,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _companyController,
                  label: "Company",
                  hint: "e.g., AOC",
                ),
              ).animate(
                effects:
                    AnimationEffectConstants
                        .usualAnimationEffects['summaryCardAnimation']
                        ?.effectsBuilder,
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
              ).animate(
                effects:
                    AnimationEffectConstants
                        .usualAnimationEffects['summaryCardAnimation']
                        ?.effectsBuilder,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _linkedinController,
                  label: "LinkedIn URL",
                  keyboardType: TextInputType.url,
                  hint: "https://www.linkedin.com/in/username",
                ),
              ).animate(
                effects:
                    AnimationEffectConstants
                        .usualAnimationEffects['summaryCardAnimation']
                        ?.effectsBuilder,
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
        ).animate(
          effects:
              AnimationEffectConstants
                  .usualAnimationEffects['summaryCardAnimation']
                  ?.effectsBuilder,
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
                AppToast.warning(
                  context,
                  "Lead Creation Failed",
                  subtitle: "Email is required",
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

              // Check for errors and proceed
              final error = ref.read(leadProvider).error;
              if (error == null) {
                AppToast.success(
                  context,
                  "Lead Created Successfully",
                  subtitle: "Proceeding to next step",
                );
                ref.read(leadStepProvider.notifier).nextStep();
              } else {
                AppToast.failure(
                  context,
                  "Lead Creation Failed",
                  subtitle: error,
                );
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
                ).animate(
                  effects:
                      AnimationEffectConstants
                          .usualAnimationEffects['summaryCardAnimation']
                          ?.effectsBuilder,
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

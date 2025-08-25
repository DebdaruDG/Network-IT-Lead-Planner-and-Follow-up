import 'dart:developer' as console;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/animation_constants.dart';
import '../data_handling/lead_form_notifier.dart';
import '../data_handling/lead_provider.dart';
import '../../../core/widgets/app_textfield.dart';
import '../lead_creation_provider.dart'; // for nextStep()
import '../../../core/widgets/app_toast.dart'; // Assuming AppToast is defined here

class Step1LeadDetailsForm extends ConsumerStatefulWidget {
  final String? leadId;

  const Step1LeadDetailsForm({super.key, required this.leadId});

  @override
  ConsumerState<Step1LeadDetailsForm> createState() =>
      _Step1LeadDetailsFormState();
}

class _Step1LeadDetailsFormState extends ConsumerState<Step1LeadDetailsForm> {
  // Controllers to capture field values
  late final TextEditingController _leadNameController;
  late final TextEditingController _companyController;
  late final TextEditingController _emailController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _leadNameController = TextEditingController();
    _companyController = TextEditingController();
    _emailController = TextEditingController();
    _linkedinController = TextEditingController();
    _phoneController = TextEditingController();

    // Initialize form state with leadInfo if available
    final leadState = ref.read(leadProvider);
    final leadInfo = leadState.selectedLead;
    if (leadInfo != null) {
      Future.delayed(Duration.zero, () async {
        ref.read(leadFormProvider.notifier).initializeFromLeadInfo(leadInfo);
        _leadNameController.text = leadInfo.leadName;
        _companyController.text = leadInfo.company;
        _emailController.text = leadInfo.email;
        _linkedinController.text = leadInfo.linkedIn ?? '';
        _phoneController.text = leadInfo.phone ?? '';
      });
    }
  }

  @override
  void dispose() {
    _leadNameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _linkedinController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leadState = ref.watch(leadProvider);
    final formState = ref.watch(leadFormProvider);
    final isLoading = leadState.isLoading;
    bool forAddLead = (widget.leadId ?? '').isEmpty;
    final leadInfo = leadState.selectedLead?.toJson();
    console.log('leadInfo - $leadInfo');

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
                  onChanged:
                      (value) => ref
                          .read(leadFormProvider.notifier)
                          .updateLeadName(value),
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
                  onChanged:
                      (value) => ref
                          .read(leadFormProvider.notifier)
                          .updateCompany(value),
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
                  onChanged:
                      (value) => ref
                          .read(leadFormProvider.notifier)
                          .updateEmail(value),
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
                  onChanged:
                      (value) => ref
                          .read(leadFormProvider.notifier)
                          .updateLinkedin(value),
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
            onChanged:
                (value) =>
                    ref.read(leadFormProvider.notifier).updatePhone(value),
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
              final email = formState.email.trim();

              if (email.isEmpty) {
                AppToast.warning(
                  context,
                  "Lead Creation Failed",
                  subtitle: "Email is required",
                );
                return;
              }

              // Call leadProvider to add lead using form state
              await ref
                  .read(leadProvider.notifier)
                  .addLead(
                    email: email,
                    leadName: formState.leadName.trim(),
                    company: formState.company.trim(),
                    linkedIn: formState.linkedin?.trim(),
                    phone: formState.phone?.trim(),
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
                // Reset form state after successful submission
                ref.read(leadFormProvider.notifier).reset();
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
                Text(
                  (widget.leadId ?? '').isEmpty
                      ? "Save & Continue"
                      : "Update & Continue",
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

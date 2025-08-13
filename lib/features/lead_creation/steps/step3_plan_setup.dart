import 'package:flutter/material.dart';

class Step3PlanSetup extends StatefulWidget {
  const Step3PlanSetup({super.key});

  @override
  State<Step3PlanSetup> createState() => _Step3PlanSetupState();
}

class _Step3PlanSetupState extends State<Step3PlanSetup> {
  final Set<String> _selectedTypes = {
    'Phone Call',
    'LinkedIn Message',
    'Email',
  };

  final List<Map<String, String>> _stepConfigs = [
    {'type': 'Email', 'day': '1'},
    {'type': 'LinkedIn Message', 'day': '3'},
    {'type': 'Phone Call', 'day': '5'},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> activeSteps =
        _stepConfigs
            .where((config) => _selectedTypes.contains(config['type']))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose step types",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _choiceChip("Phone Call"),
                  _choiceChip("LinkedIn Message"),
                  _choiceChip("Email"),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Preview (mock)",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              ...activeSteps.map(
                (step) => Text(
                  "• Day ${step['day']} - ${step['type']}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_backButton(() {}), _continueButton(() {})],
        ),
      ],
    );
  }

  Widget _choiceChip(String label) {
    final bool isSelected = _selectedTypes.contains(label);
    return FilterChip(
      color: WidgetStateProperty.all(
        isSelected ? const Color(0xFF4338CA) : Colors.white,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF4338CA),
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedTypes.add(label);
          } else {
            _selectedTypes.remove(label);
          }
        });
      },
      backgroundColor: isSelected ? const Color(0xFF3B82F6) : Colors.white,
      selectedColor: const Color(0xFF3B82F6),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _continueButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text(
        "Continue",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _backButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      child: const Text(
        "Back",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}

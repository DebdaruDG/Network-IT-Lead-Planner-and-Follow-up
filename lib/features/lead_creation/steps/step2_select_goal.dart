import 'package:flutter/material.dart';

class Step2GoalSelection extends StatefulWidget {
  const Step2GoalSelection({super.key});

  @override
  State<Step2GoalSelection> createState() => _Step2GoalSelectionState();
}

class _Step2GoalSelectionState extends State<Step2GoalSelection> {
  bool _bookMeeting = true;
  bool _getReply = false;
  bool _shareProposal = false;
  bool _closeDeal = false;
  bool _other = false;
  int _duration = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _goalCard(
                    "Book a meeting",
                    "Calendar event",
                    _bookMeeting,
                    (value) {
                      setState(() => _bookMeeting = value);
                    },
                  ),
                ),
                Expanded(
                  child: _goalCard(
                    "Get a reply",
                    "Positive response",
                    _getReply,
                    (value) {
                      setState(() => _getReply = value);
                    },
                  ),
                ),
                Expanded(
                  child: _goalCard(
                    "Share proposal",
                    "Formal document",
                    _shareProposal,
                    (value) {
                      setState(() => _shareProposal = value);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _goalCard(
                    "Close deal",
                    "Convert to customer",
                    _closeDeal,
                    (value) {
                      setState(() => _closeDeal = value);
                    },
                  ),
                ),
                Expanded(
                  child: _goalCard("Other", "Custom target", _other, (value) {
                    setState(() => _other = value);
                  }),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              const Text(
                "Duration (days)",
                style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  controller: TextEditingController(text: _duration.toString()),
                  onChanged: (value) {
                    setState(() {
                      _duration = int.tryParse(value) ?? 10;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_backButton(() {}), _generatePlanButton(() {})],
        ),
      ],
    );
  }

  Widget _goalCard(
    String title,
    String subtitle,
    bool isSelected,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (value) {
                  onChanged(value ?? false);
                },
                activeColor: const Color(0xFF3B82F6),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _backButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
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

  Widget _generatePlanButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Text(
        "Generate plan",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}

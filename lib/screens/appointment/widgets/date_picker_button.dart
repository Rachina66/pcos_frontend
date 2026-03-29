import 'package:flutter/material.dart';

class DatePickerButton extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DatePickerButton({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month,
              color: Color(0xFFB565A7),
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              selectedDate == null
                  ? 'Pick a date'
                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              style: TextStyle(
                fontSize: 14,
                color: selectedDate == null ? Colors.black38 : Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}

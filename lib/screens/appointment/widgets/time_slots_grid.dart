import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/doctor/doctor_provider.dart';

class TimeSlotsGrid extends StatelessWidget {
  final DateTime? selectedDate;
  final String? selectedSlot;
  final Function(String) onSlotSelected;

  const TimeSlotsGrid({
    super.key,
    required this.selectedDate,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedDate == null) {
      return const Text(
        'Please select a date first',
        style: TextStyle(color: Colors.black38, fontSize: 13),
      );
    }

    return Consumer<DoctorProvider>(
      builder: (context, doctorProvider, child) {
        if (doctorProvider.isSlotsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: Color(0xFFB565A7)),
            ),
          );
        }

        if (doctorProvider.error != null) {
          return Text(
            doctorProvider.error!,
            style: const TextStyle(color: Colors.red, fontSize: 13),
          );
        }

        if (doctorProvider.availableSlots == null ||
            doctorProvider.availableSlots!.availableSlots.isEmpty) {
          return const Text(
            'No slots available for this date',
            style: TextStyle(color: Colors.black38, fontSize: 13),
          );
        }

        final slots = doctorProvider.availableSlots!.availableSlots;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots.map((slot) {
            final isSelected = selectedSlot == slot;
            return GestureDetector(
              onTap: () => onSlotSelected(slot),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFB565A7) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFB565A7),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  slot,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFFB565A7),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

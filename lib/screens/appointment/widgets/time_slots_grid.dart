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
            doctorProvider.availableSlots!.allSlots.isEmpty) {
          return const Text(
            'No slots available for this date',
            style: TextStyle(color: Colors.black38, fontSize: 13),
          );
        }

        // Use allSlots to show everything
        // Use availableSlots to know which are free
        final allSlots = doctorProvider.availableSlots!.allSlots;
        final availableSlots = doctorProvider.availableSlots!.availableSlots;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: allSlots.map((slot) {
            final isAvailable = availableSlots.contains(slot);
            final isSelected = selectedSlot == slot;

            return GestureDetector(
              // Only allow tap if slot is available
              onTap: isAvailable ? () => onSlotSelected(slot) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  // Selected → purple
                  // Available → white with purple border
                  // Booked → gray
                  color: isSelected
                      ? const Color(0xFFB565A7)
                      : isAvailable
                      ? Colors.white
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFB565A7)
                        : isAvailable
                        ? const Color(0xFFB565A7)
                        : const Color(0xFFBDBDBD),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      slot,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : isAvailable
                            ? const Color(0xFFB565A7)
                            : Colors.black38,
                      ),
                    ),
                    // Show booked label on taken slots
                    if (!isAvailable) ...[
                      const SizedBox(width: 4),
                      const Text(
                        '· Booked',
                        style: TextStyle(fontSize: 11, color: Colors.black38),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/appointment/appointment_provider.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmButton({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: appointmentProvider.isBooking ? null : onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB565A7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: appointmentProvider.isBooking
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Confirm Appointment',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
          ),
        );
      },
    );
  }
}

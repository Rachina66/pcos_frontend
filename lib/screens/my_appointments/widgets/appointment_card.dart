import 'package:flutter/material.dart';
import '../../../models/appointments/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentCard({super.key, required this.appointment});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'CONFIRMED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      case 'COMPLETED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor name + status chip
          Row(
            children: [
              // Doctor avatar
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFB565A7).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: appointment.doctor?.imageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          appointment.doctor!.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: Color(0xFFB565A7),
                              size: 24,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        color: Color(0xFFB565A7),
                        size: 24,
                      ),
              ),

              const SizedBox(width: 12),

              // Doctor info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctor?.name ?? 'Doctor',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      appointment.doctor?.specialization ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              // Status chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(appointment.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appointment.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(appointment.status),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),

          // Date + time slot
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 16,
                color: Color(0xFFB565A7),
              ),
              const SizedBox(width: 6),
              Text(
                '${appointment.date.day}/${appointment.date.month}/${appointment.date.year}',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Color(0xFFB565A7)),
              const SizedBox(width: 6),
              Text(
                appointment.timeSlot,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),

          // Reason if exists
          if (appointment.reason != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.notes, size: 16, color: Color(0xFFB565A7)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    appointment.reason!,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

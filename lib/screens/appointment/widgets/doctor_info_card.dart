import 'package:flutter/material.dart';
import '../../../models/doctor/doctor_model.dart';

class DoctorInfoCard extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorInfoCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFB565A7).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: doctor.imageUrl != null
                ? ClipOval(
                    child: Image.network(
                      doctor.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          color: Color(0xFFB565A7),
                          size: 30,
                        );
                      },
                    ),
                  )
                : const Icon(Icons.person, color: Color(0xFFB565A7), size: 30),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.specialization,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.hospital,
                  style: const TextStyle(fontSize: 13, color: Colors.black45),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs. ${doctor.consultFee.toStringAsFixed(0)} consult fee',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB565A7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

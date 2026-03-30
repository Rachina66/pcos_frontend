import 'package:flutter/material.dart';
import '../../../models/appointments/appointment_model.dart';

class AppointmentResultsScreen extends StatelessWidget {
  const AppointmentResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointment =
        ModalRoute.of(context)!.settings.arguments as AppointmentModel;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ═══ HEADER ═══
          _buildHeader(context),

          // ═══ BODY ═══
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor info
                  _buildInfoCard(
                    title: 'Doctor',
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB565A7).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFFB565A7),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
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
                            Text(
                              appointment.doctor?.specialization ?? '',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Date + time
                  _buildInfoCard(
                    title: 'Appointment Details',
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.calendar_month_outlined,
                          'Date',
                          '${appointment.date.day}/${appointment.date.month}/${appointment.date.year}',
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          Icons.access_time,
                          'Time',
                          appointment.timeSlot,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Diagnosis
                  if (appointment.diagnosis != null)
                    _buildInfoCard(
                      title: 'Diagnosis',
                      child: Text(
                        appointment.diagnosis!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),

                  if (appointment.diagnosis != null) const SizedBox(height: 16),

                  // Consultation notes
                  if (appointment.consultationNotes != null)
                    _buildInfoCard(
                      title: 'Consultation Notes',
                      child: Text(
                        appointment.consultationNotes!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),

                  if (appointment.consultationNotes != null)
                    const SizedBox(height: 16),

                  // Prescription
                  if (appointment.prescription != null)
                    _buildInfoCard(
                      title: 'Prescription',
                      child: Text(
                        appointment.prescription!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),

                  if (appointment.prescription != null)
                    const SizedBox(height: 16),

                  // No results yet
                  if (appointment.diagnosis == null &&
                      appointment.consultationNotes == null &&
                      appointment.prescription == null)
                    _buildInfoCard(
                      title: 'Results',
                      child: const Text(
                        'No results added yet by the doctor.',
                        style: TextStyle(fontSize: 14, color: Colors.black38),
                      ),
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══ HEADER ═══
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 20,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB565A7), Color(0xFFE8A0D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Appointment Results',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  // ═══ INFO CARD ═══
  Widget _buildInfoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB565A7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  // ═══ DETAIL ROW ═══
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFB565A7)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}

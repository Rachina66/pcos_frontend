import 'package:flutter/material.dart';
import '../../models/appointments/appointment_model.dart';

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointment =
        ModalRoute.of(context)!.settings.arguments as AppointmentModel;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  _buildDoctorCard(appointment),
                  const SizedBox(height: 16),

                
                  _buildSectionTitle('Appointment Info'),
                  const SizedBox(height: 10),
                  _buildAppointmentInfo(appointment),
                  const SizedBox(height: 16),

                  
                  _buildSectionTitle('Consultation Details'),
                  const SizedBox(height: 10),
                  _buildConsultationDetails(appointment),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── HEADER ──
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
              'Appointment Details',
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

  // ── DOCTOR CARD ──
  Widget _buildDoctorCard(AppointmentModel appointment) {
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
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFB565A7).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Color(0xFFB565A7), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.doctor?.name ?? 'Doctor',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appointment.doctor?.specialization ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.black45),
                ),
                const SizedBox(height: 4),
                Text(
                  appointment.doctor?.hospital ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFB565A7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Completed badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'COMPLETED',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── APPOINTMENT INFO ──
  Widget _buildAppointmentInfo(AppointmentModel appointment) {
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
      child: Column(
        children: [
          _buildInfoRow(
            Icons.calendar_month_outlined,
            'Date',
            '${appointment.date.day}/${appointment.date.month}/${appointment.date.year}',
          ),
          const Divider(height: 20, color: Color(0xFFF0F0F0)),
          _buildInfoRow(Icons.access_time, 'Time', appointment.timeSlot),
          if (appointment.reason != null) ...[
            const Divider(height: 20, color: Color(0xFFF0F0F0)),
            _buildInfoRow(Icons.notes_outlined, 'Reason', appointment.reason!),
          ],
          if (appointment.reportFile != null) ...[
            const Divider(height: 20, color: Color(0xFFF0F0F0)),
            _buildInfoRow(Icons.attach_file, 'Report', 'Report was attached'),
          ],
        ],
      ),
    );
  }

  // ── CONSULTATION DETAILS ──
  Widget _buildConsultationDetails(AppointmentModel appointment) {
    final hasDiagnosis = appointment.diagnosis != null;
    final hasNotes = appointment.consultationNotes != null;
    final hasPrescription = appointment.prescription != null;

    if (!hasDiagnosis && !hasNotes && !hasPrescription) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No consultation details available',
            style: TextStyle(color: Colors.black38, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      children: [
        if (hasDiagnosis) ...[
          _buildDetailCard(
            icon: Icons.medical_information_outlined,
            title: 'Diagnosis',
            content: appointment.diagnosis!,
            color: const Color(0xFFB565A7),
          ),
          const SizedBox(height: 12),
        ],
        if (hasNotes) ...[
          _buildDetailCard(
            icon: Icons.notes_outlined,
            title: 'Consultation Notes',
            content: appointment.consultationNotes!,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
        ],
        if (hasPrescription) ...[
          _buildDetailCard(
            icon: Icons.medication_outlined,
            title: 'Prescription',
            content: appointment.prescription!,
            color: Colors.green,
          ),
        ],
      ],
    );
  }

  // ── HELPER WIDGETS ──
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFFB565A7)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black38),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
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
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

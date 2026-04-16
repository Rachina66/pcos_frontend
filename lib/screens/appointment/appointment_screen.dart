import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../models/doctor/doctor_model.dart';
import '../../providers/doctor/doctor_provider.dart';
import '../../providers/appointment/appointment_provider.dart';
import 'widgets/doctor_info_card.dart';
import 'widgets/date_picker_button.dart';
import 'widgets/time_slots_grid.dart';
import 'widgets/reason_input.dart';
import 'widgets/file_picker_button.dart';
import 'widgets/confirm_button.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final TextEditingController _reasonController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedSlot;
  String? _selectedFilePath;
  String? _selectedFileName;
  bool _shareAssessment = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(DoctorModel doctor) async {
    // Find next available day
    DateTime initialDate = DateTime.now().add(const Duration(days: 1));
    while (!doctor.availableDays.contains(_getDayName(initialDate.weekday))) {
      initialDate = initialDate.add(const Duration(days: 1));
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      selectableDayPredicate: (day) {
        final dayName = _getDayName(day.weekday);
        return doctor.availableDays.contains(dayName);
      },
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFFB565A7)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedSlot = null;
      });

      final dateString =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';

      if (mounted) {
        await context.read<DoctorProvider>().fetchAvailableSlots(
          doctor.id,
          dateString,
        );
      }
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
        _selectedFileName = result.files.single.name;
      });
    }
  }

  Future<void> _confirmBooking(DoctorModel doctor) async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final dateString =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

    final success = await context.read<AppointmentProvider>().bookAppointment(
      doctorId: doctor.id,
      date: dateString,
      timeSlot: _selectedSlot!,
      reason: _reasonController.text.trim().isEmpty
          ? null
          : _reasonController.text.trim(),
      reportFilePath: _selectedFilePath,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment booked successfully!'),
          backgroundColor: Color(0xFFB565A7),
        ),
      );
      Navigator.pushReplacementNamed(context, '/my-appointments');
    } else {
      final error = context.read<AppointmentProvider>().error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Booking failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctor = ModalRoute.of(context)!.settings.arguments as DoctorModel;
    print('Doctor: ${doctor.name}');
    print('Available days: ${doctor.availableDays}');

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
                  DoctorInfoCard(doctor: doctor),
                  const SizedBox(height: 24),

                  const Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DatePickerButton(
                    selectedDate: _selectedDate,
                    onTap: () => _pickDate(doctor),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Available Time Slots',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TimeSlotsGrid(
                    selectedDate: _selectedDate,
                    selectedSlot: _selectedSlot,
                    onSlotSelected: (slot) {
                      setState(() => _selectedSlot = slot);
                    },
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Reason (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ReasonInput(controller: _reasonController),
                  const SizedBox(height: 24),

                  // ═══ SHARE ASSESSMENT PLACEHOLDER ═══
                  const Text(
                    'Share Assessment (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildAssessmentToggle(),
                  const SizedBox(height: 24),

                  const Text(
                    'Attach Report (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilePickerButton(
                    selectedFileName: _selectedFileName,
                    onTap: _pickFile,
                    onClear: () {
                      setState(() {
                        _selectedFilePath = null;
                        _selectedFileName = null;
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  ConfirmButton(onConfirm: () => _confirmBooking(doctor)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            Icons.assignment_outlined,
            color: Color(0xFFB565A7),
            size: 22,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share PCOS Assessment',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Share your latest assessment with the doctor',
                  style: TextStyle(fontSize: 12, color: Colors.black38),
                ),
              ],
            ),
          ),
          Switch(
            value: _shareAssessment,
            onChanged: (value) {
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You will share your assessment here'),
                    backgroundColor: Color(0xFFB565A7),
                  ),
                );
              }
            },
            activeColor: const Color(0xFFB565A7),
          ),
        ],
      ),
    );
  }

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
              'Book Appointment',
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
}

import 'package:flutter/material.dart';
import '../../core/api/api_exception.dart';
import '../../models/appointments/appointment_model.dart';
import '../../services/appointment/appointment_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentService _service = AppointmentService();

  // ═══ STATE ═══
  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  bool _isBooking = false;
  String? _error;
  String? _successMessage;

  // ═══ GETTERS ═══
  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  bool get isBooking => _isBooking;
  String? get error => _error;
  String? get successMessage => _successMessage;

  // ═══ FILTERED GETTERS ═══
  List<AppointmentModel> get upcomingAppointments => _appointments
      .where(
        (a) =>
            a.date.isAfter(DateTime.now()) &&
            (a.status == 'PENDING' || a.status == 'CONFIRMED'),
      )
      .toList();

  List<AppointmentModel> get pastAppointments =>
      _appointments.where((a) => a.date.isBefore(DateTime.now())).toList();

  List<AppointmentModel> get pendingAppointments =>
      _appointments.where((a) => a.status == 'PENDING').toList();

  // ═══ FETCH MY APPOINTMENTS ═══
  Future<void> fetchMyAppointments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _appointments = await _service.getMyAppointments();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ═══ BOOK APPOINTMENT ═══
  Future<bool> bookAppointment({
    required String doctorId,
    required String date,
    required String timeSlot,
    String? reason,
    String? reportFilePath,
  }) async {
    _isBooking = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final appointment = await _service.bookAppointment(
        doctorId: doctorId,
        date: date,
        timeSlot: timeSlot,
        reason: reason,
        reportFilePath: reportFilePath,
      );
      _appointments.insert(0, appointment);
      _successMessage = 'Appointment booked successfully';
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isBooking = false;
      notifyListeners();
    }
  }

  // ═══ CLEAR ═══
  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

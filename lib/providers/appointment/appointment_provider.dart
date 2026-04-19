import 'package:flutter/material.dart';
import '../../core/api/api_exception.dart';
import '../../models/appointments/appointment_model.dart';
import '../../services/appointment/appointment_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentService _service = AppointmentService();

  
  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  bool _isBooking = false;
  String? _error;
  String? _successMessage;

  
  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  bool get isBooking => _isBooking;
  String? get error => _error;
  String? get successMessage => _successMessage;

  
  List<AppointmentModel> get upcomingAppointments => _appointments
      .where(
        (a) =>
            a.date.isAfter(DateTime.now()) &&
            (a.status == 'PENDING' || a.status == 'CONFIRMED'),
      )
      .toList();
  List<AppointmentModel> get completedAppointments =>
      _appointments.where((a) => a.status == 'COMPLETED').toList();

  List<AppointmentModel> get cancelledAppointments =>
      _appointments.where((a) => a.status == 'CANCELLED').toList();
  List<AppointmentModel> get pastAppointments =>
      _appointments.where((a) => a.date.isBefore(DateTime.now())).toList();

  List<AppointmentModel> get pendingAppointments =>
      _appointments.where((a) => a.status == 'PENDING').toList();

  
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

  
  Future<bool> bookAppointment({
    required String doctorId,
    required String date,
    required String timeSlot,
    String? reason,
    String? reportFilePath,
    String? predictionId,
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
        predictionId: predictionId,
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

  Future<bool> cancelAppointment(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.cancelAppointment(id);
      // Update locally so UI refreshes immediately
      _appointments = _appointments.map((a) {
        if (a.id == id) {
          return AppointmentModel(
            id: a.id,
            userId: a.userId,
            doctorId: a.doctorId,
            date: a.date,
            timeSlot: a.timeSlot,
            reason: a.reason,
            reportFile: a.reportFile,
            status: 'CANCELLED',
            notes: a.notes,
            consultationNotes: a.consultationNotes,
            prescription: a.prescription,
            diagnosis: a.diagnosis,
            createdAt: a.createdAt,
            updatedAt: a.updatedAt,
            doctor: a.doctor,
          );
        }
        return a;
      }).toList();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
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

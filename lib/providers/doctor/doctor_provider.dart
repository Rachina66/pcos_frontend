import 'package:flutter/material.dart';
import '../../core/api/api_exception.dart';
import '../../models/doctor/doctor_model.dart';
import '../../services/doctor/doctor_service.dart';

class DoctorProvider extends ChangeNotifier {
  final DoctorService _service = DoctorService();

  // ═══ STATE ═══
  List<DoctorModel> _doctors = [];
  DoctorModel? _selectedDoctor;
  AvailableSlotsModel? _availableSlots;

  bool _isLoading = false;
  bool _isSlotsLoading = false;
  String? _error;

  // ═══ GETTERS ═══
  List<DoctorModel> get doctors => _doctors;
  DoctorModel? get selectedDoctor => _selectedDoctor;
  AvailableSlotsModel? get availableSlots => _availableSlots;
  bool get isLoading => _isLoading;
  bool get isSlotsLoading => _isSlotsLoading;
  String? get error => _error;

  // ═══ FETCH ALL DOCTORS ═══
  Future<void> fetchDoctors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _doctors = await _service.getAllDoctors();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ═══ FETCH SINGLE DOCTOR ═══
  Future<void> fetchDoctorById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedDoctor = await _service.getDoctorById(id);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ═══ FETCH AVAILABLE SLOTS ═══
  Future<void> fetchAvailableSlots(String doctorId, String date) async {
    _isSlotsLoading = true;
    _availableSlots = null;
    _error = null;
    notifyListeners();

    try {
      _availableSlots = await _service.getAvailableSlots(doctorId, date);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
    } finally {
      _isSlotsLoading = false;
      notifyListeners();
    }
  }

  // ═══ CLEAR ═══
  void clearSelectedDoctor() {
    _selectedDoctor = null;
    _availableSlots = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../../core/api/api_exception.dart';
import '../../models/cycle/cycle_model.dart';
import '../../services/cycle/cycle_service.dart';

class CycleProvider extends ChangeNotifier {
  final CycleService _service = CycleService();

  // ═══ STATE ═══
  List<CycleLogModel> _cycles = [];
  CyclePredictionModel? _prediction;
  SymptomInsightModel? _insights;
  List<String> _todaySymptoms = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  // ═══ GETTERS ═══
  List<CycleLogModel> get cycles => _cycles;
  CyclePredictionModel? get prediction => _prediction;
  SymptomInsightModel? get insights => _insights;
  List<String> get todaySymptoms => _todaySymptoms;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  // ═══ GET ALL DATA AT ONCE ═══
  Future<void> loadAllData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getCycleHistory(),
        _service.getPrediction(),
        _service.getTodaySymptoms(),
      ]);

      _cycles = results[0] as List<CycleLogModel>;
      _prediction = results[1] as CyclePredictionModel;
      _todaySymptoms = results[2] as List<String>;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ═══ LOG PERIOD ═══
  Future<bool> logPeriod({
    required String startDate,
    String? endDate,
    required List<String> symptoms,
    String? notes,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final cycle = await _service.logPeriod(
        startDate: startDate,
        endDate: endDate,
        symptoms: symptoms,
        notes: notes,
      );
      _cycles.insert(0, cycle);
      await _refreshPrediction();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ═══ UPDATE CYCLE ═══
  Future<bool> updateCycleLog(
    String id, {
    String? startDate,
    String? endDate,
    List<String>? symptoms,
    String? notes,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _service.updateCycleLog(
        id,
        startDate: startDate,
        endDate: endDate,
        symptoms: symptoms,
        notes: notes,
      );
      final index = _cycles.indexWhere((c) => c.id == id);
      if (index != -1) _cycles[index] = updated;
      await _refreshPrediction();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Something went wrong.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ═══ DELETE CYCLE ═══
  Future<bool> deleteCycleLog(String id) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _service.deleteCycleLog(id);
      _cycles.removeWhere((c) => c.id == id);
      await _refreshPrediction();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ═══ LOG TODAY'S SYMPTOMS ═══
  Future<bool> logSymptoms(List<String> symptoms) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _service.logSymptoms(symptoms);
      _todaySymptoms = symptoms;
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ═══ LOAD INSIGHTS ═══
  Future<void> loadInsights() async {
    _isLoading = true;
    notifyListeners();

    try {
      _insights = await _service.getSymptomInsights();
    } on ApiException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ═══ HELPER ═══
  Future<void> _refreshPrediction() async {
    _prediction = await _service.getPrediction();
    notifyListeners();
  }

  // ═══ GET PERIOD DAYS FOR CALENDAR ═══
  Set<DateTime> get periodDays {
    final days = <DateTime>{};
    for (final cycle in _cycles) {
      if (cycle.endDate != null) {
        DateTime current = cycle.startDate;
        while (!current.isAfter(cycle.endDate!)) {
          days.add(DateTime(current.year, current.month, current.day));
          current = current.add(const Duration(days: 1));
        }
      } else {
        days.add(
          DateTime(
            cycle.startDate.year,
            cycle.startDate.month,
            cycle.startDate.day,
          ),
        );
      }
    }
    return days;
  }

  // ═══ GET PREDICTED DAYS FOR CALENDAR ═══
  Set<DateTime> get predictedDays {
    if (_prediction == null ||
        !_prediction!.predicted ||
        _prediction!.nextPeriodDate == null) {
      return {};
    }

    final days = <DateTime>{};
    final start = _prediction!.nextPeriodDate!;
    final duration = _prediction!.avgDuration ?? 5;

    for (int i = 0; i < duration; i++) {
      final day = start.add(Duration(days: i));
      days.add(DateTime(day.year, day.month, day.day));
    }
    return days;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

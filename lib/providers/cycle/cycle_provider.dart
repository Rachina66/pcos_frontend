import 'package:flutter/material.dart';
import '../../core/api/api_exception.dart';
import '../../models/cycle/cycle_model.dart';
import '../../services/cycle/cycle_service.dart';

class CycleProvider extends ChangeNotifier {
  final CycleService _service = CycleService();

  List<CycleLogModel> _cycles = [];
  List<DailyLogModel> _dailyLogs = [];
  CyclePredictionModel? _prediction;
  CycleInsightsModel? _insights;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  List<CycleLogModel> get cycles => _cycles;
  List<DailyLogModel> get dailyLogs => _dailyLogs;
  CyclePredictionModel? get prediction => _prediction;
  CycleInsightsModel? get insights => _insights;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  Future<void> loadAllData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final from =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-01';
      final to =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final results = await Future.wait([
        _service.getCycleHistory(),
        _service.getPrediction(),
        _service.getDailyLogsInRange(from, to),
      ]);

      _cycles = results[0] as List<CycleLogModel>;
      _prediction = results[1] as CyclePredictionModel;
      _dailyLogs = results[2] as List<DailyLogModel>;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> upsertDailyLog({
    required String date,
    required bool isPeriod,
    String? flow,
    String? mood,
    int? energy,
    List<String>? symptoms,
    String? notes,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final log = await _service.upsertDailyLog(
        date: date,
        isPeriod: isPeriod,
        flow: flow,
        mood: mood,
        energy: energy,
        symptoms: symptoms,
        notes: notes,
      );

      final index = _dailyLogs.indexWhere((l) =>
          l.date.year == log.date.year &&
          l.date.month == log.date.month &&
          l.date.day == log.date.day);

      if (index != -1) {
        _dailyLogs[index] = log;
      } else {
        _dailyLogs.add(log);
      }

      await _refreshCyclesAndPrediction();
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

  Future<void> loadInsights() async {
    _isLoading = true;
    notifyListeners();

    try {
      _insights = await _service.getInsights();
    } on ApiException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _refreshCyclesAndPrediction() async {
    final results = await Future.wait([
      _service.getCycleHistory(),
      _service.getPrediction(),
    ]);
    _cycles = results[0] as List<CycleLogModel>;
    _prediction = results[1] as CyclePredictionModel;
    notifyListeners();
  }

  // Period days from CycleLog for calendar highlighting
  Set<DateTime> get periodDays {
    final days = <DateTime>{};
    for (final cycle in _cycles) {
      DateTime current = cycle.startDate;
      while (!current.isAfter(cycle.endDate)) {
        days.add(DateTime(current.year, current.month, current.day));
        current = current.add(const Duration(days: 1));
      }
    }
    return days;
  }

  // Predicted days from prediction window
  Set<DateTime> get predictedDays {
    if (_prediction == null ||
        !_prediction!.predicted ||
        _prediction!.nextPeriodStart == null) {
      return {};
    }

    final days = <DateTime>{};
    final start = _prediction!.nextPeriodStart!;
    final end = _prediction!.nextPeriodEnd ?? start;

    DateTime current = start;
    while (!current.isAfter(end)) {
      days.add(DateTime(current.year, current.month, current.day));
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
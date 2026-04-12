import 'package:flutter/material.dart';
import '../../core/api/api_exception.dart';
import '../../models/prediction/prediction_model.dart';
import '../../services/prediction/prediction_service.dart';

class PredictionProvider extends ChangeNotifier {
  final PredictionService _service = PredictionService();

  List<PredictionModel> _predictions = [];
  PredictionResult? _latestResult;
  bool _isLoading = false;
  String? _error;

  List<PredictionModel> get predictions => _predictions;
  PredictionResult? get latestResult => _latestResult;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> predict({
    required double age,
    required double weight,
    required double height,
    required double bmi,
    required String bloodGroup,
    required double cycleLengthDays,
    required double periodLengthDays,
    required bool regularOvulation,
    required double fshLevel,
    required double lhLevel,
    required double androgenLevel,
    required double cystCount,
    required bool hirsutism,
    required double fastingGlucose,
    required int activityLevel,
    required int stressLevel,
    required bool pregnant,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _latestResult = await _service.predict(
        age: age,
        weight: weight,
        height: height,
        bmi: bmi,
        bloodGroup: bloodGroup,
        cycleLengthDays: cycleLengthDays,
        periodLengthDays: periodLengthDays,
        regularOvulation: regularOvulation,
        fshLevel: fshLevel,
        lhLevel: lhLevel,
        androgenLevel: androgenLevel,
        cystCount: cystCount,
        hirsutism: hirsutism,
        fastingGlucose: fastingGlucose,
        activityLevel: activityLevel,
        stressLevel: stressLevel,
        pregnant: pregnant,
      );
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

  Future<void> fetchMyPredictions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _predictions = await _service.getMyPredictions();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Something went wrong.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearResult() {
    _latestResult = null;
    notifyListeners();
  }
}

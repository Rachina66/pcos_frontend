class CycleLogModel {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime? endDate;
  final int? periodLength;
  final List<String> symptoms;
  final String? notes;
  final DateTime createdAt;

  CycleLogModel({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    this.periodLength,
    required this.symptoms,
    this.notes,
    required this.createdAt,
  });

  factory CycleLogModel.fromJson(Map<String, dynamic> json) {
    return CycleLogModel(
      id: json['id'],
      userId: json['userId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      periodLength: json['periodLength'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class CyclePredictionModel {
  final bool predicted;
  final DateTime? nextPeriodDate;
  final int? avgCycleLength;
  final int? avgDuration;
  final String? regularity;
  final int? variation;
  final int? daysUntil;
  final int? currentCycleDay;
  final DateTime? lastPeriodDate;
  final String? message;
  final String? note;

  CyclePredictionModel({
    required this.predicted,
    this.nextPeriodDate,
    this.avgCycleLength,
    this.avgDuration,
    this.regularity,
    this.variation,
    this.daysUntil,
    this.currentCycleDay,
    this.lastPeriodDate,
    this.message,
    this.note,
  });

  factory CyclePredictionModel.fromJson(Map<String, dynamic> json) {
    return CyclePredictionModel(
      predicted: json['predicted'] ?? false,
      nextPeriodDate: json['nextPeriodDate'] != null
          ? DateTime.parse(json['nextPeriodDate'])
          : null,
      avgCycleLength: json['avgCycleLength'],
      avgDuration: json['avgDuration'],
      regularity: json['regularity'],
      variation: json['variation'],
      daysUntil: json['daysUntil'],
      currentCycleDay: json['currentCycleDay'],
      lastPeriodDate: json['lastPeriodDate'] != null
          ? DateTime.parse(json['lastPeriodDate'])
          : null,
      message: json['message'],
      note: json['note'],
    );
  }
}

class SymptomInsightModel {
  final bool hasInsights;
  final String? message;
  final int? cyclesAnalyzed;
  final List<SymptomTrend> improving;
  final List<SymptomTrend> worsening;
  final List<SymptomTrend> consistent;
  final List<String> mostCommon;

  SymptomInsightModel({
    required this.hasInsights,
    this.message,
    this.cyclesAnalyzed,
    required this.improving,
    required this.worsening,
    required this.consistent,
    required this.mostCommon,
  });

  factory SymptomInsightModel.fromJson(Map<String, dynamic> json) {
    return SymptomInsightModel(
      hasInsights: json['hasInsights'] ?? false,
      message: json['message'],
      cyclesAnalyzed: json['cyclesAnalyzed'],
      improving: (json['improving'] as List? ?? [])
          .map((e) => SymptomTrend.fromJson(e))
          .toList(),
      worsening: (json['worsening'] as List? ?? [])
          .map((e) => SymptomTrend.fromJson(e))
          .toList(),
      consistent: (json['consistent'] as List? ?? [])
          .map((e) => SymptomTrend.fromJson(e))
          .toList(),
      mostCommon: List<String>.from(json['mostCommon'] ?? []),
    );
  }
}

class SymptomTrend {
  final String symptom;
  final String trend;
  final int frequency;
  final int totalOccurrences;
  final int cyclesTracked;

  SymptomTrend({
    required this.symptom,
    required this.trend,
    required this.frequency,
    required this.totalOccurrences,
    required this.cyclesTracked,
  });

  factory SymptomTrend.fromJson(Map<String, dynamic> json) {
    return SymptomTrend(
      symptom: json['symptom'],
      trend: json['trend'],
      frequency: json['frequency'],
      totalOccurrences: json['totalOccurrences'],
      cyclesTracked: json['cyclesTracked'],
    );
  }
}

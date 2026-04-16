class DailyLogModel {
  final String id;
  final String userId;
  final DateTime date;
  final bool isPeriod;
  final String? flow;
  final String? mood;
  final int? energy;
  final List<String> symptoms;
  final String? notes;
  final DateTime createdAt;

  DailyLogModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.isPeriod,
    this.flow,
    this.mood,
    this.energy,
    required this.symptoms,
    this.notes,
    required this.createdAt,
  });

  factory DailyLogModel.fromJson(Map<String, dynamic> json) {
    return DailyLogModel(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      isPeriod: json['isPeriod'] ?? false,
      flow: json['flow'],
      mood: json['mood'],
      energy: json['energy'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class CycleLogModel {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final int periodLength;
  final DateTime createdAt;

  CycleLogModel({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.periodLength,
    required this.createdAt,
  });

  factory CycleLogModel.fromJson(Map<String, dynamic> json) {
    return CycleLogModel(
      id: json['id'],
      userId: json['userId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      periodLength: json['periodLength'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class CyclePredictionModel {
  final bool predicted;
  final DateTime? nextPeriodStart;
  final DateTime? nextPeriodEnd;
  final int? avgCycleLength;
  final int? avgPeriodLength;
  final String? regularity;
  final int? variation;
  final String? confidence;
  final int? daysUntil;
  final String? status;
  final int? basedOn;
  final int? currentCycleDay;
  final DateTime? lastPeriodDate;
  final String? message;
  final String? note;

  CyclePredictionModel({
    required this.predicted,
    this.nextPeriodStart,
    this.nextPeriodEnd,
    this.avgCycleLength,
    this.avgPeriodLength,
    this.regularity,
    this.variation,
    this.confidence,
    this.daysUntil,
    this.status,
    this.basedOn,
    this.currentCycleDay,
    this.lastPeriodDate,
    this.message,
    this.note,
  });

  factory CyclePredictionModel.fromJson(Map<String, dynamic> json) {
    return CyclePredictionModel(
      predicted: json['predicted'] ?? false,
      nextPeriodStart: json['nextPeriodStart'] != null
          ? DateTime.parse(json['nextPeriodStart'])
          : null,
      nextPeriodEnd: json['nextPeriodEnd'] != null
          ? DateTime.parse(json['nextPeriodEnd'])
          : null,
      avgCycleLength: json['avgCycleLength'],
      avgPeriodLength: json['avgPeriodLength'],
      regularity: json['regularity'],
      variation: json['variation'],
      confidence: json['confidence'],
      daysUntil: json['daysUntil'],
      status: json['status'],
      basedOn: json['basedOn'],
      currentCycleDay: json['currentCycleDay'],
      lastPeriodDate: json['lastPeriodDate'] != null
          ? DateTime.parse(json['lastPeriodDate'])
          : null,
      message: json['message'],
      note: json['note'],
    );
  }
}

class CycleInsightsModel {
  final bool hasInsights;
  final String? message;
  final int? cyclesAnalyzed;
  final List<TopSymptom> topSymptoms;
  final MoodInsight? mood;
  final EnergyInsight? energy;

  CycleInsightsModel({
    required this.hasInsights,
    this.message,
    this.cyclesAnalyzed,
    required this.topSymptoms,
    this.mood,
    this.energy,
  });

  factory CycleInsightsModel.fromJson(Map<String, dynamic> json) {
    return CycleInsightsModel(
      hasInsights: json['hasInsights'] ?? false,
      message: json['message'],
      cyclesAnalyzed: json['cyclesAnalyzed'],
      topSymptoms: (json['topSymptoms'] as List? ?? [])
          .map((e) => TopSymptom.fromJson(e))
          .toList(),
      mood: json['mood'] != null ? MoodInsight.fromJson(json['mood']) : null,
      energy: json['energy'] != null
          ? EnergyInsight.fromJson(json['energy'])
          : null,
    );
  }
}

class TopSymptom {
  final String symptom;
  final int count;
  final int frequency;

  TopSymptom({
    required this.symptom,
    required this.count,
    required this.frequency,
  });

  factory TopSymptom.fromJson(Map<String, dynamic> json) {
    return TopSymptom(
      symptom: json['symptom'],
      count: json['count'],
      frequency: json['frequency'],
    );
  }
}

class MoodInsight {
  final int? duringPeriod;
  final int? outsidePeriod;

  MoodInsight({this.duringPeriod, this.outsidePeriod});

  factory MoodInsight.fromJson(Map<String, dynamic> json) {
    return MoodInsight(
      duringPeriod: json['duringPeriod'],
      outsidePeriod: json['outsidePeriod'],
    );
  }
}

class EnergyInsight {
  final int? duringPeriod;
  final int? outsidePeriod;

  EnergyInsight({this.duringPeriod, this.outsidePeriod});

  factory EnergyInsight.fromJson(Map<String, dynamic> json) {
    return EnergyInsight(
      duringPeriod: json['duringPeriod'],
      outsidePeriod: json['outsidePeriod'],
    );
  }
}

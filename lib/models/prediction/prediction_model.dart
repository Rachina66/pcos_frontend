class PredictionModel {
  final String id;
  final String userId;
  final double age;
  final double weight;
  final double height;
  final double bmi;
  final String bloodGroup;
  final double cycleLengthDays;
  final double periodLengthDays;
  final bool regularOvulation;
  final double fshLevel;
  final double lhLevel;
  final double androgenLevel;
  final double cystCount;
  final bool hirsutism;
  final double fastingGlucose;
  final int activityLevel;
  final int stressLevel;
  final bool pregnant;
  final int prediction;
  final double probability;
  final String riskLevel;
  final double confidence;
  final DateTime createdAt;

  PredictionModel({
    required this.id,
    required this.userId,
    required this.age,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.bloodGroup,
    required this.cycleLengthDays,
    required this.periodLengthDays,
    required this.regularOvulation,
    required this.fshLevel,
    required this.lhLevel,
    required this.androgenLevel,
    required this.cystCount,
    required this.hirsutism,
    required this.fastingGlucose,
    required this.activityLevel,
    required this.stressLevel,
    required this.pregnant,
    required this.prediction,
    required this.probability,
    required this.riskLevel,
    required this.confidence,
    required this.createdAt,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      id: json['id'],
      userId: json['userId'],
      age: (json['age'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      bloodGroup: json['bloodGroup'] ?? 'Unknown',
      cycleLengthDays: (json['cycleLengthDays'] as num).toDouble(),
      periodLengthDays: (json['periodLengthDays'] as num).toDouble(),
      regularOvulation: json['regularOvulation'] ?? false,
      fshLevel: (json['fshLevel'] as num).toDouble(),
      lhLevel: (json['lhLevel'] as num).toDouble(),
      androgenLevel: (json['androgenLevel'] as num).toDouble(),
      cystCount: (json['cystCount'] as num).toDouble(),
      hirsutism: json['hirsutism'] ?? false,
      fastingGlucose: (json['fastingGlucose'] as num).toDouble(),
      activityLevel: json['activityLevel'],
      stressLevel: json['stressLevel'],
      pregnant: json['pregnant'] ?? false,
      prediction: json['prediction'],
      probability: (json['probability'] as num).toDouble(),
      riskLevel: json['riskLevel'],
      confidence: (json['confidence'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class PredictionResult {
  final String predictionId;
  final int prediction;
  final String riskLevel;
  final double confidence;
  final double probability;

  PredictionResult({
    required this.predictionId,
    required this.prediction,
    required this.riskLevel,
    required this.confidence,
    required this.probability,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictionId: json['predictionId'],
      prediction: json['result']['prediction'],
      riskLevel: json['result']['riskLevel'],
      confidence: (json['result']['confidence'] as num).toDouble(),
      probability: (json['result']['probability'] as num).toDouble(),
    );
  }
}

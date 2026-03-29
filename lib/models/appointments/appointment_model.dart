class AppointmentModel {
  final String id;
  final String userId;
  final String doctorId;
  final DateTime date;
  final String timeSlot;
  final String? reason;
  final String? reportFile;
  final String status;
  final String? notes;
  final String? consultationNotes;
  final String? prescription;
  final String? diagnosis;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DoctorSummary? doctor;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.date,
    required this.timeSlot,
    this.reason,
    this.reportFile,
    required this.status,
    this.notes,
    this.consultationNotes,
    this.prescription,
    this.diagnosis,
    required this.createdAt,
    required this.updatedAt,
    this.doctor,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      userId: json['userId'],
      doctorId: json['doctorId'],
      date: DateTime.parse(json['date']),
      timeSlot: json['timeSlot'],
      reason: json['reason'],
      reportFile: json['reportFile'],
      status: json['status'],
      notes: json['notes'],
      consultationNotes: json['consultationNotes'],
      prescription: json['prescription'],
      diagnosis: json['diagnosis'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      doctor: json['doctor'] != null
          ? DoctorSummary.fromJson(json['doctor'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'reason': reason,
      'reportFile': reportFile,
      'status': status,
      'notes': notes,
      'consultationNotes': consultationNotes,
      'prescription': prescription,
      'diagnosis': diagnosis,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class DoctorSummary {
  final String id;
  final String name;
  final String specialization;
  final String? hospital;
  final String? imageUrl;
  final double? consultFee;

  DoctorSummary({
    required this.id,
    required this.name,
    required this.specialization,
    this.hospital,
    this.imageUrl,
    this.consultFee,
  });

  factory DoctorSummary.fromJson(Map<String, dynamic> json) {
    return DoctorSummary(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      hospital: json['hospital'],
      imageUrl: json['imageUrl'],
      consultFee: json['consultFee'] != null
          ? (json['consultFee'] as num).toDouble()
          : null,
    );
  }
}

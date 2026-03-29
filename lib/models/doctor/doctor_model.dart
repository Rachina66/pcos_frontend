import 'package:frontend/models/appointments/appointment_model.dart';

class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final String qualification;
  final int experience;
  final String hospital;
  final String location;
  final String phone;
  final String email;
  final String? bio;
  final String? imageUrl;
  final List<String> availableDays;
  final List<String> timeSlots;
  final double consultFee;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.qualification,
    required this.experience,
    required this.hospital,
    required this.location,
    required this.phone,
    required this.email,
    this.bio,
    this.imageUrl,
    required this.availableDays,
    required this.timeSlots,
    required this.consultFee,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      qualification: json['qualification'],
      experience: json['experience'],
      hospital: json['hospital'],
      location: json['location'],
      phone: json['phone'],
      email: json['email'],
      bio: json['bio'],
      imageUrl: json['imageUrl'],
      availableDays: List<String>.from(json['availableDays'] ?? []),
      timeSlots: List<String>.from(json['timeSlots'] ?? []),
      consultFee: (json['consultFee'] as num).toDouble(),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'qualification': qualification,
      'experience': experience,
      'hospital': hospital,
      'location': location,
      'phone': phone,
      'email': email,
      'bio': bio,
      'imageUrl': imageUrl,
      'availableDays': availableDays,
      'timeSlots': timeSlots,
      'consultFee': consultFee,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AvailableSlotsModel {
  final DoctorSummary? doctor;
  final String date;
  final List<String> allSlots;
  final List<String> bookedSlots;
  final List<String> availableSlots;

  AvailableSlotsModel({
    this.doctor,
    required this.date,
    required this.allSlots,
    required this.bookedSlots,
    required this.availableSlots,
  });

  factory AvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    return AvailableSlotsModel(
      doctor: json['doctor'] != null
          ? DoctorSummary.fromJson(json['doctor'])
          : null,
      date: json['date'],
      allSlots: List<String>.from(json['allSlots'] ?? []),
      bookedSlots: List<String>.from(json['bookedSlots'] ?? []),
      availableSlots: List<String>.from(json['availableSlots'] ?? []),
    );
  }
}

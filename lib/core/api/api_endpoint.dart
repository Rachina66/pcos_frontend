class ApiEndpoints {
  static const String ip = 'https://self-plaza-calibrate.ngrok-free.dev';
  static const String baseUrl =
      'https://self-plaza-calibrate.ngrok-free.dev/api';

  // auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';
  static const String verifyEmail = '/auth/verify-email';
  //public
  static const String doctors = '/public/doctors';
  static String doctorById(String id) => '/public/doctors/$id';
  static String availableSlots(String id) =>
      '/public/doctors/$id/available-slots';

  static const String content = '/public/content';
  static String contentById(String id) => '/public/content/$id';
  static String contentByCategory(String category) =>
      '/public/content?category=$category';

  //user
  static const String myAppointments = '/user/appointments';
  static const String bookAppointment = '/user/appointments';

  static const String myPredictions = '/user/predictions';
  static const String createPrediction = '/user/predictions';
  static String cancelAppointment(String id) => '/user/appointments/$id';
  //doctor
  static const String doctorProfile = '/doctor/profile';
  static const String doctorStats = '/doctor/stats';

  static const String doctorAppointments = '/doctor/appointments';
  static const String doctorAppointmentsToday = '/doctor/appointments/today';
  static const String doctorAppointmentsUpcoming =
      '/doctor/appointments/upcoming';
  static const String doctorAppointmentsPast = '/doctor/appointments/past';
  static const String doctorBulkConfirm = '/doctor/appointments/bulk-confirm';
  static String doctorUpdateAppointment(String id) =>
      '/doctor/appointments/$id';
  static String doctorAppointmentNotes(String id) =>
      '/doctor/appointments/$id/notes';

  static const String doctorPatients = '/doctor/patients';
  static String doctorPatientById(String id) => '/doctor/patients/$id';
  static String doctorPatientAppointments(String id) =>
      '/doctor/patients/$id/appointments';
  static String doctorPatientPredictions(String id) =>
      '/doctor/patients/$id/predictions';

  //admin
  static const String adminStats = '/admin/stats';
  static const String adminUsers = '/admin/users';

  static const String adminDoctors = '/admin/doctors';
  static String adminDoctorById(String id) => '/admin/doctors/$id';

  static const String adminContent = '/admin/content';
  static String adminContentById(String id) => '/admin/content/$id';

  static const String adminAppointments = '/admin/appointments';
  static String adminAppointmentById(String id) => '/admin/appointments/$id';

  // Cycle
  static const String cycles = '/user/cycles';
  static const String cyclesPrediction = '/user/cycles/prediction';
  static const String cyclesSymptoms = '/user/cycles/symptoms';
  static const String cyclesTodaySymptoms = '/user/cycles/symptoms/today';
  static const String cyclesInsights = '/user/cycles/symptoms/insights';
  static String cycleById(String id) => '/user/cycles/$id';

  // prediction
  static const String predict = '/prediction/predict';
  static const String predictions = '/prediction/predictions';
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/api/api_client.dart';
import 'providers/auth/auth_provider.dart';
import 'providers/appointment/appointment_provider.dart';
import 'providers/doctor/doctor_provider.dart';
import 'providers/cycle/cycle_provider.dart';
import 'providers/prediction/prediction_provider.dart';
import 'providers/meal/meal_provider.dart';
import 'providers/profile/profile_provider.dart';
import 'providers/notification/notification_provider.dart';
import 'routes/index.dart';
import 'screens/pages/home_screen.dart';
import 'screens/doctors/doctors_list_screen.dart';
import 'screens/appointment/appointment_screen.dart';
import 'screens/my_appointments/my_appointments_screen.dart';
import 'screens/my_appointments/appointment_details_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/cycle/cycle_tracking_screen.dart';
import 'screens/pcos_check/pcos_check_screen.dart';
import 'screens/pcos_check/prediction_history_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/meal/meal_plan_sreen.dart';
import 'screens/profile/profile_screen.dart';
import 'providers/content/content_provider.dart';
import 'screens/content/content_screen.dart';
import 'screens/notification/notification_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient().initialize();

  // ── Instantiate and wire providers ──
  final authProvider         = AuthProvider();
  final notificationProvider = NotificationProvider();
  authProvider.setNotificationProvider(notificationProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: notificationProvider),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => CycleProvider()),
        ChangeNotifierProvider(create: (_) => PredictionProvider()),
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ContentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PCOS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      initialRoute: AppRoutes.initialRoute,
      routes: {
        ...AppRoutes.routes,
        '/home':                (context) => const HomeScreen(),
        '/doctors':             (context) => const DoctorsListScreen(),
        '/book-appointment':    (context) => const BookAppointmentScreen(),
        '/my-appointments':     (context) => const MyAppointmentsScreen(),
        '/appointment-results': (context) => const AppointmentDetailScreen(),
        '/history-reports':     (context) => const HistoryReportsScreen(),
        '/cycle-tracking':      (context) => const CycleTrackingScreen(),
        '/pcos-check':          (context) => const PcosCheckScreen(),
        '/prediction-history':  (context) => const PredictionHistoryScreen(),
        '/otp-verify':          (context) => const OtpVerificationScreen(),
        '/meal-plan':           (context) => const MealPlanScreen(),
        '/profile':             (context) => const ProfileScreen(),
        '/content':             (context) => const ContentScreen(),
        '/notifications':       (context) => const NotificationScreen(),
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment/appointment_provider.dart';
import 'widgets/appointment_card.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().fetchMyAppointments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ═══ HEADER ═══
          _buildHeader(context),

          // ═══ TABS ═══
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFFB565A7),
              unselectedLabelColor: Colors.black38,
              indicatorColor: const Color(0xFFB565A7),
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Pending'),
                Tab(text: 'Past'),
              ],
            ),
          ),

          // ═══ TAB CONTENT ═══
          Expanded(
            child: Consumer<AppointmentProvider>(
              builder: (context, appointmentProvider, child) {
                if (appointmentProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFB565A7)),
                  );
                }

                if (appointmentProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          appointmentProvider.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            appointmentProvider.fetchMyAppointments();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB565A7),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    // Upcoming tab
                    _buildAppointmentList(
                      appointmentProvider.upcomingAppointments,
                      'No upcoming appointments',
                    ),

                    // Pending tab
                    _buildAppointmentList(
                      appointmentProvider.pendingAppointments,
                      'No pending appointments',
                    ),

                    // Past tab
                    _buildAppointmentList(
                      appointmentProvider.pastAppointments,
                      'No past appointments',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══ APPOINTMENT LIST ═══
  Widget _buildAppointmentList(List appointments, String emptyMessage) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48,
              color: Colors.black.withOpacity(0.2),
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: const TextStyle(color: Colors.black38, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return AppointmentCard(appointment: appointments[index]);
      },
    );
  }

  // ═══ HEADER ═══
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 20,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB565A7), Color(0xFFE8A0D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'My Appointments',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}

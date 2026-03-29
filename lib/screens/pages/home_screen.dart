import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ═══ HEADER ═══
              _buildHeader(context),

              const SizedBox(height: 24),

              // ═══ BODY ═══
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Start PCOS Check Button
                    _buildStartPCOSButton(context),

                    const SizedBox(height: 12),

                    // Connect Doctor Button
                    _buildConnectDoctorButton(context),

                    const SizedBox(height: 28),

                    // Track & Manage Section
                    const Text(
                      'Track & Manage',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildTrackManageGrid(context),

                    const SizedBox(height: 28),

                    // Quick Access Section
                    const Text(
                      'Quick Access',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),
                    _buildQuickAccessItem(
                      icon: Icons.calendar_month_outlined,
                      label: 'My Appointments',
                      onTap: () {
                        Navigator.pushNamed(context, '/my-appointments');
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildQuickAccessItem(
                      icon: Icons.history,
                      label: 'History & Reports',
                      onTap: () {
                        // TODO: navigate to history
                      },
                    ),

                    const SizedBox(height: 10),

                    _buildQuickAccessItem(
                      icon: Icons.person_outline,
                      label: 'Profile & Settings',
                      onTap: () {
                        // TODO: navigate to profile
                      },
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══ HEADER ═══
  Widget _buildHeader(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.user?.name ?? 'User';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB565A7), Color(0xFFE8C4E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Welcome text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back,',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  // ═══ START PCOS CHECK BUTTON ═══
  Widget _buildStartPCOSButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: navigate to PCOS check
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB565A7),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.health_and_safety_outlined, size: 20),
        label: const Text(
          'Start PCOS Check',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ═══ CONNECT DOCTOR BUTTON ═══
  Widget _buildConnectDoctorButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/doctors');
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFB565A7),
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Color(0xFFB565A7), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.medical_services_outlined, size: 20),
        label: const Text(
          'Connect Doctor',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ═══ TRACK & MANAGE GRID ═══
  Widget _buildTrackManageGrid(BuildContext context) {
    final items = [
      {
        'icon': Icons.calendar_month_outlined,
        'label': 'Track Menstruation',
        'onTap': () {}, // TODO
      },
      {
        'icon': Icons.restaurant_menu_outlined,
        'label': 'Meal Plan',
        'onTap': () {}, // TODO
      },
      {
        'icon': Icons.monitor_heart_outlined,
        'label': 'Daily Symptoms',
        'onTap': () {}, // TODO
      },
      {
        'icon': Icons.tips_and_updates_outlined,
        'label': 'Health Tips',
        'onTap': () {}, // TODO
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: items.map((item) {
        return _buildGridItem(
          icon: item['icon'] as IconData,
          label: item['label'] as String,
          onTap: item['onTap'] as VoidCallback,
        );
      }).toList(),
    );
  }

  // ═══ GRID ITEM ═══
  Widget _buildGridItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFB565A7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFB565A7), size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══ QUICK ACCESS ITEM ═══
  Widget _buildQuickAccessItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFB565A7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFB565A7), size: 20),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            const Text(
              '...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black38,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/screens/pcos_check/pcos_results_screen.dart

import 'package:flutter/material.dart';
import '../../models/prediction/prediction_model.dart';
import 'diet_preference_screen.dart';
import 'prediction_history_screen.dart';

class PcosResultScreen extends StatelessWidget {
  final PredictionResult result;
  const PcosResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isHighRisk = result.riskLevel == 'High Risk';
    final probabilityPercent = (result.probability * 100).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              const Text(
                'Assessment Results',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // ── main result card ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isHighRisk
                            ? const Color(0xFFFFEBEB)
                            : const Color(0xFFEBF7EB),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isHighRisk
                            ? Icons.error_outline_rounded
                            : Icons.check_circle_outline_rounded,
                        size: 44,
                        color: isHighRisk
                            ? const Color(0xFFE05C5C)
                            : const Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      result.riskLevel,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isHighRisk
                            ? const Color(0xFFE05C5C)
                            : const Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Based on your symptom assessment',
                      style: TextStyle(fontSize: 13, color: Colors.black45),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Risk Level',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$probabilityPercent%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isHighRisk
                                ? const Color(0xFFE05C5C)
                                : const Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: result.probability,
                        backgroundColor: Colors.black.withOpacity(0.08),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isHighRisk
                              ? const Color(0xFFE05C5C)
                              : const Color(0xFF4CAF50),
                        ),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F0F7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFFB565A7),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isHighRisk
                                  ? 'Your symptoms suggest a higher likelihood of PCOS. Please consult with a healthcare provider soon for proper diagnosis and treatment planning.'
                                  : 'Your symptoms suggest a lower likelihood of PCOS. Keep maintaining a healthy lifestyle and monitor your symptoms regularly.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── buttons ──
              _buildPrimaryButton(
                icon: Icons.restaurant_menu_outlined,
                label: 'Get Meal Recommendations',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DietPreferenceScreen(result: result),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildOutlineButton(
                icon: Icons.medical_services_outlined,
                label: 'Connect Doctor',
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/doctors',
                  (route) => route.settings.name == '/home',
                ),
              ),
              const SizedBox(height: 12),
              _buildOutlineButton(
                icon: Icons.history_outlined,
                label: 'View Past Predictions',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PredictionHistoryScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              GestureDetector(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB565A7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7B3FA0),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildOutlineButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF7B3FA0),
          side: const BorderSide(color: Color(0xFFB565A7), width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

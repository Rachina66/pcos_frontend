// lib/screens/pcos_check/diet_preference_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/prediction/prediction_model.dart';
import '../../providers/meal/meal_provider.dart';
import '../meal/meal_plan_sreen.dart';

class DietPreferenceScreen extends StatefulWidget {
  final PredictionResult result;
  const DietPreferenceScreen({super.key, required this.result});

  @override
  State<DietPreferenceScreen> createState() => _DietPreferenceScreenState();
}

class _DietPreferenceScreenState extends State<DietPreferenceScreen> {
  String _selected = 'NON_VEG';

  final List<Map<String, dynamic>> _options = [
    {
      'key': 'NON_VEG',
      'label': 'Non-Vegetarian',
      'subtitle': 'Includes fish, chicken, eggs and dairy',
      'icon': Icons.set_meal_outlined,
    },
    {
      'key': 'VEG',
      'label': 'Vegetarian',
      'subtitle': 'Includes eggs, dairy, paneer and tofu',
      'icon': Icons.eco_outlined,
    },
    {
      'key': 'VEGAN',
      'label': 'Vegan',
      'subtitle': 'Plant-based only — tofu, lentils, vegetables',
      'icon': Icons.grass_outlined,
    },
  ];

  Future<void> _generate() async {
    final provider = context.read<MealProvider>();
    provider.setDietPreference(_selected);

    final success = await provider.generateMealPlan(
      predictionId: widget.result.predictionId,
    );

    if (!mounted) return;

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MealPlanScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to generate plan'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0F8),
      body: SafeArea(
        child: Column(
          children: [
            // ── header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Your Preference',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // ── intro card ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFFB565A7).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.restaurant_menu_outlined,
                              color: Color(0xFFB565A7),
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Personalised Meal Plan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'We will generate a 7-day PCOS-friendly meal plan based on your risk level and diet preference.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F0F7),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFB565A7).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.analytics_outlined,
                                  color: Color(0xFFB565A7),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Risk Level: ${widget.result.riskLevel}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFB565A7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── preference options ──
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select your diet preference',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...(_options.map((opt) {
                      final isSelected = _selected == opt['key'];
                      return GestureDetector(
                        onTap: () => setState(() => _selected = opt['key']),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFB565A7).withOpacity(0.08)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFB565A7)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(
                                          0xFFB565A7,
                                        ).withOpacity(0.15)
                                      : const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Icon(
                                    opt['icon'] as IconData,
                                    color: isSelected
                                        ? const Color(0xFFB565A7)
                                        : Colors.black38,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      opt['label'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? const Color(0xFFB565A7)
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      opt['subtitle'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFFB565A7),
                                  size: 22,
                                ),
                            ],
                          ),
                        ),
                      );
                    })),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // ── generate button ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: const Color(0xFFF5F0F8),
              child: Consumer<MealProvider>(
                builder: (context, provider, _) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: provider.isLoading ? null : _generate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B3FA0),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: provider.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.auto_awesome_outlined, size: 18),
                    label: Text(
                      provider.isLoading
                          ? 'Generating your plan...'
                          : 'Generate My Meal Plan',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

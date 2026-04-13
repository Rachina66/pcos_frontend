// lib/screens/history/prediction_history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/prediction/prediction_model.dart';
import '../../providers/prediction/prediction_provider.dart';
import '../pcos_check/diet_preference_screen.dart';

class PredictionHistoryScreen extends StatefulWidget {
  const PredictionHistoryScreen({super.key});

  @override
  State<PredictionHistoryScreen> createState() =>
      _PredictionHistoryScreenState();
}

class _PredictionHistoryScreenState extends State<PredictionHistoryScreen> {
  bool _newestFirst = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PredictionProvider>().fetchMyPredictions();
    });
  }

  List<PredictionModel> _getSorted(List<PredictionModel> predictions) {
    final list = List<PredictionModel>.from(predictions);
    list.sort(
      (a, b) => _newestFirst
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt),
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Consumer<PredictionProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFB565A7)),
                  );
                }

                if (provider.error != null) {
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
                          provider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => provider.fetchMyPredictions(),
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

                final sorted = _getSorted(provider.predictions);

                return Column(
                  children: [
                    _buildSortBar(sorted.length),
                    Expanded(
                      child: sorted.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              itemCount: sorted.length,
                              itemBuilder: (_, index) =>
                                  _buildPredictionCard(context, sorted[index]),
                            ),
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
              'Prediction History',
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

  Widget _buildSortBar(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            '$count assessment${count != 1 ? 's' : ''} found',
            style: const TextStyle(fontSize: 13, color: Colors.black45),
          ),
          const Spacer(),
          const Text(
            'Sort:',
            style: TextStyle(fontSize: 13, color: Colors.black45),
          ),
          const SizedBox(width: 8),
          _buildSortChip('Newest', true),
          const SizedBox(width: 6),
          _buildSortChip('Oldest', false),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, bool isNewest) {
    final isSelected = _newestFirst == isNewest;
    return GestureDetector(
      onTap: () => setState(() => _newestFirst = isNewest),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB565A7) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFB565A7) : Colors.black12,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFB565A7).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black45,
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionCard(
    BuildContext context,
    PredictionModel prediction,
  ) {
    final isHighRisk = prediction.riskLevel == 'High Risk';
    final riskColor = isHighRisk
        ? const Color(0xFFE05C5C)
        : const Color(0xFF4CAF50);
    final riskBg = isHighRisk
        ? const Color(0xFFFFEBEB)
        : const Color(0xFFEBF7EB);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── top row: icon + risk + date ──
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: riskBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isHighRisk
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline_rounded,
                  color: riskColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prediction.riskLevel,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: riskColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'BMI: ${prediction.bmi.toStringAsFixed(1)} · Age: ${prediction.age.toInt()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${prediction.createdAt.day}/${prediction.createdAt.month}/${prediction.createdAt.year}',
                style: const TextStyle(fontSize: 12, color: Colors.black38),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),

          // ── probability bar ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Risk Probability',
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
              Text(
                '${(prediction.probability * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: riskColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: prediction.probability,
              backgroundColor: Colors.black.withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation<Color>(riskColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),

          // ── key stats ──
          Row(
            children: [
              _buildStatChip(
                Icons.monitor_heart_outlined,
                'Cycle',
                '${prediction.cycleLengthDays.toInt()}d',
              ),
              const SizedBox(width: 8),
              _buildStatChip(
                Icons.science_outlined,
                'FSH',
                prediction.fshLevel.toStringAsFixed(1),
              ),
              const SizedBox(width: 8),
              _buildStatChip(
                Icons.bloodtype_outlined,
                'Glucose',
                prediction.fastingGlucose.toStringAsFixed(1),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── get meal plan button ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Build a PredictionResult from this PredictionModel
                final result = PredictionResult(
                  predictionId: prediction.id,
                  prediction: prediction.prediction,
                  riskLevel: prediction.riskLevel,
                  confidence: prediction.confidence,
                  probability: prediction.probability,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DietPreferenceScreen(result: result),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB565A7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.restaurant_menu_outlined, size: 16),
              label: const Text(
                'Get Meal Plan for this Result',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFFB565A7)),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 10, color: Colors.black38),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 60,
            color: Colors.black.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          const Text(
            'No assessments yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black38,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your PCOS assessment results\nwill appear here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black26),
          ),
        ],
      ),
    );
  }
}

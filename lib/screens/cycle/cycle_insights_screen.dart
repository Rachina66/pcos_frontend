// lib/screens/cycle/cycle_insights_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cycle/cycle_provider.dart';

class CycleInsightsScreen extends StatefulWidget {
  const CycleInsightsScreen({super.key});

  @override
  State<CycleInsightsScreen> createState() => _CycleInsightsScreenState();
}

class _CycleInsightsScreenState extends State<CycleInsightsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CycleProvider>().loadInsights();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Consumer<CycleProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFB565A7)),
                  );
                }

                final insights = provider.insights;

                if (insights == null || !insights.hasInsights) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insights_outlined,
                            size: 60,
                            color: Colors.black.withOpacity(0.15),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            insights?.message ??
                                'Log at least 2 cycles to see insights',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary card
                      _buildSummaryCard(insights.cyclesAnalyzed ?? 0),
                      const SizedBox(height: 16),

                      // Top symptoms
                      if (insights.topSymptoms.isNotEmpty) ...[
                        _buildSectionTitle('Top Symptoms'),
                        const SizedBox(height: 10),
                        _buildSymptomsCard(insights.topSymptoms),
                        const SizedBox(height: 16),
                      ],

                      // Mood comparison
                      if (insights.mood != null) ...[
                        _buildSectionTitle('Mood Comparison'),
                        const SizedBox(height: 10),
                        _buildComparisonCard(
                          duringValue: insights.mood!.duringPeriod,
                          outsideValue: insights.mood!.outsidePeriod,
                          maxValue: 5,
                          duringLabel: 'During period',
                          outsideLabel: 'Outside period',
                          duringColor: const Color(0xFF993556),
                          outsideColor: const Color(0xFF4CAF50),
                          note: insights.mood!.outsidePeriod == null
                              ? 'Log non-period days to see comparison'
                              : null,
                          description: 'Mood score out of 5 (5 = happiest)',
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Energy comparison
                      if (insights.energy != null) ...[
                        _buildSectionTitle('Energy Comparison'),
                        const SizedBox(height: 10),
                        _buildComparisonCard(
                          duringValue: insights.energy!.duringPeriod,
                          outsideValue: insights.energy!.outsidePeriod,
                          maxValue: 5,
                          duringLabel: 'During period',
                          outsideLabel: 'Outside period',
                          duringColor: const Color(0xFFFF9800),
                          outsideColor: const Color(0xFF2196F3),
                          note: insights.energy!.outsidePeriod == null
                              ? 'Log non-period days to see comparison'
                              : null,
                          description: 'Energy level out of 5',
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Footer note
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F0F7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFB565A7).withOpacity(0.2),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Color(0xFFB565A7),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Log daily — period and non-period days — for richer insights over time.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFB565A7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
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
              'Cycle Insights',
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

  Widget _buildSummaryCard(int cycles) {
    return Container(
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFBEAF0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.insights,
              color: Color(0xFF993556),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Based on $cycles cycle${cycles != 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                cycles < 4
                    ? 'Log more cycles for better accuracy'
                    : 'Good data quality',
                style: TextStyle(
                  fontSize: 12,
                  color: cycles < 4 ? Colors.orange : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSymptomsCard(List<dynamic> symptoms) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: symptoms.map<Widget>((s) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.symptom,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${s.frequency}%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF993556),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: s.frequency / 100,
                    backgroundColor: Colors.black.withOpacity(0.06),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFD4537E),
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Logged ${s.count} time${s.count != 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 11, color: Colors.black38),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildComparisonCard({
    required int? duringValue,
    required int? outsideValue,
    required int maxValue,
    required String duringLabel,
    required String outsideLabel,
    required Color duringColor,
    required Color outsideColor,
    String? note,
    String? description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description != null) ...[
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: Colors.black38),
            ),
            const SizedBox(height: 14),
          ],

          // During period bar
          _buildComparisonBar(
            label: duringLabel,
            value: duringValue,
            maxValue: maxValue,
            color: duringColor,
          ),
          const SizedBox(height: 12),

          // Outside period bar
          _buildComparisonBar(
            label: outsideLabel,
            value: outsideValue,
            maxValue: maxValue,
            color: outsideColor,
            isEmpty: outsideValue == null,
          ),

          if (note != null) ...[
            const SizedBox(height: 10),
            Text(
              note,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black38,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildComparisonBar({
    required String label,
    required int? value,
    required int maxValue,
    required Color color,
    bool isEmpty = false,
  }) {
    final double barValue = isEmpty || value == null ? 0 : value / maxValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            Text(
              isEmpty || value == null ? '—' : '$value / $maxValue',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isEmpty ? Colors.black26 : color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: barValue,
            backgroundColor: Colors.black.withOpacity(0.06),
            valueColor: AlwaysStoppedAnimation<Color>(
              isEmpty ? Colors.black12 : color,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

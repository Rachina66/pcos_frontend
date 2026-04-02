import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cycle/cycle_provider.dart';
import '../../models/cycle/cycle_model.dart';

class SymptomInsightsScreen extends StatefulWidget {
  const SymptomInsightsScreen({super.key});

  @override
  State<SymptomInsightsScreen> createState() => _SymptomInsightsScreenState();
}

class _SymptomInsightsScreenState extends State<SymptomInsightsScreen> {
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
              builder: (context, provider, child) {
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
                      // ── Summary Card ──
                      _buildSummaryCard(
                        insights.cyclesAnalyzed ?? 0,
                        insights.mostCommon,
                      ),
                      const SizedBox(height: 16),

                      // ── Improving ──
                      if (insights.improving.isNotEmpty) ...[
                        _buildSectionTitle(
                          'Getting Better',
                          Icons.trending_down,
                          Colors.green,
                        ),
                        const SizedBox(height: 10),
                        ...insights.improving.map((s) => _buildSymptomCard(s)),
                        const SizedBox(height: 16),
                      ],

                      // ── Worsening ──
                      if (insights.worsening.isNotEmpty) ...[
                        _buildSectionTitle(
                          'Needs Attention',
                          Icons.trending_up,
                          Colors.red,
                        ),
                        const SizedBox(height: 10),
                        ...insights.worsening.map((s) => _buildSymptomCard(s)),
                        const SizedBox(height: 16),
                      ],

                      // ── Consistent ──
                      if (insights.consistent.isNotEmpty) ...[
                        _buildSectionTitle(
                          'Consistent',
                          Icons.trending_flat,
                          Colors.orange,
                        ),
                        const SizedBox(height: 10),
                        ...insights.consistent.map((s) => _buildSymptomCard(s)),
                        const SizedBox(height: 24),
                      ],
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
              'Symptom Insights',
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

  Widget _buildSummaryCard(int cycles, List<String> mostCommon) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Based on $cycles cycles',
            style: const TextStyle(fontSize: 13, color: Colors.black45),
          ),
          const SizedBox(height: 10),
          const Text(
            'Most Common Symptoms',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: mostCommon
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F0F7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFB565A7).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      s,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB565A7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomCard(SymptomTrend symptom) {
    Color trendColor;
    IconData trendIcon;

    switch (symptom.trend) {
      case 'improving':
        trendColor = Colors.green;
        trendIcon = Icons.trending_down;
        break;
      case 'worsening':
        trendColor = Colors.red;
        trendIcon = Icons.trending_up;
        break;
      default:
        trendColor = Colors.orange;
        trendIcon = Icons.trending_flat;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symptom.symptom,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Occurred in ${symptom.totalOccurrences} of ${symptom.cyclesTracked} cycles',
                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                ),
                const SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: symptom.frequency / 100,
                    backgroundColor: Colors.black.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(trendColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            children: [
              Icon(trendIcon, color: trendColor, size: 24),
              Text(
                '${symptom.frequency}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: trendColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

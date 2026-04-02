import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../providers/cycle/cycle_provider.dart';
import 'widgets/log_period_bottom_sheet.dart';
import './symptoms_insights_screen.dart';

class CycleTrackingScreen extends StatefulWidget {
  const CycleTrackingScreen({super.key});

  @override
  State<CycleTrackingScreen> createState() => _CycleTrackingScreenState();
}

class _CycleTrackingScreenState extends State<CycleTrackingScreen> {
  DateTime _focusedDay = DateTime.now();
  final List<String> _allSymptoms = [
    'Cramps',
    'Bloating',
    'Fatigue',
    'Headache',
    'Mood Swings',
    'Acne',
    'Back Pain',
    'Nausea',
  ];

  List<String> _selectedSymptoms = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<CycleProvider>().loadAllData();
      if (mounted) {
        final provider = context.read<CycleProvider>();
        setState(() {
          _selectedSymptoms = List.from(provider.todaySymptoms);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Consumer<CycleProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildHeader(context, provider),
              Expanded(
                child: provider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFB565A7),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Log Period Button ──
                            _buildLogPeriodButton(context, provider),
                            const SizedBox(height: 16),

                            // ── Calendar ──
                            _buildCalendar(provider),
                            const SizedBox(height: 16),

                            // ── Cycle Insights ──
                            _buildSectionTitle('Cycle Insights'),
                            const SizedBox(height: 10),
                            _buildInsightCards(provider),
                            const SizedBox(height: 16),

                            // ── Today's Symptoms ──
                            _buildSectionTitle("Log Today's Symptoms"),
                            const SizedBox(height: 10),
                            _buildSymptomsSection(provider),
                            const SizedBox(height: 16),

                            // ── Symptom Insights Button ──
                            _buildSymptomInsightsButton(context),
                            const SizedBox(height: 16),

                            // ── Cycle History ──
                            _buildSectionTitle('Cycle History'),
                            const SizedBox(height: 10),
                            _buildCycleHistory(context, provider),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── HEADER ──
  Widget _buildHeader(BuildContext context, CycleProvider provider) {
    final prediction = provider.prediction;

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
      child: Column(
        children: [
          Row(
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
                  'Cycle Tracking',
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
          const SizedBox(height: 16),

          // ── Summary Card ──
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Cycle',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          prediction?.predicted == true &&
                                  prediction?.currentCycleDay != null
                              ? 'Day ${prediction!.currentCycleDay}'
                              : 'No data',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (prediction?.predicted == true &&
                        prediction?.nextPeriodDate != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Next Period',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '${prediction!.nextPeriodDate!.day}/${prediction.nextPeriodDate!.month}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'in ${prediction.daysUntil} days',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildHeaderStat(
                        'Last Period',
                        prediction?.lastPeriodDate != null
                            ? '${prediction!.lastPeriodDate!.day}/${prediction.lastPeriodDate!.month}/${prediction.lastPeriodDate!.year}'
                            : '—',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildHeaderStat(
                        'Avg Cycle',
                        prediction?.avgCycleLength != null
                            ? '${prediction!.avgCycleLength} days'
                            : '—',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── LOG PERIOD BUTTON ──
  Widget _buildLogPeriodButton(BuildContext context, CycleProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => LogPeriodBottomSheet(
              onSaved: () {
                provider.loadAllData();
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB565A7),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.add_circle_outline, size: 20),
        label: const Text(
          'Log New Period',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ── CALENDAR ──
  Widget _buildCalendar(CycleProvider provider) {
    return Container(
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
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 180)),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            onPageChanged: (focusedDay) {
              setState(() => _focusedDay = focusedDay);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final normalDay =
                    DateTime(day.year, day.month, day.day);
                final isPeriod =
                    provider.periodDays.contains(normalDay);
                final isPredicted =
                    provider.predictedDays.contains(normalDay);
                final isToday = isSameDay(day, DateTime.now());

                if (isPeriod) {
                  return _calendarDay(
                    day.day.toString(),
                    background: const Color(0xFFF4C0D1),
                    textColor: const Color(0xFF72243E),
                  );
                }

                if (isPredicted) {
                  return _calendarDay(
                    day.day.toString(),
                    background: const Color(0xFFFBEAF0),
                    textColor: const Color(0xFF993556),
                    isDashed: true,
                  );
                }

                if (isToday) {
                  return _calendarDay(
                    day.day.toString(),
                    background: const Color(0xFFB565A7),
                    textColor: Colors.white,
                  );
                }

                return null;
              },
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color(0xFFB565A7),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(0xFFB565A7),
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.black54),
              defaultTextStyle: TextStyle(color: Colors.black87),
            ),
          ),

          // ── Legend ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _buildLegend(const Color(0xFFF4C0D1), 'Period'),
                const SizedBox(width: 16),
                _buildLegend(
                  const Color(0xFFFBEAF0),
                  'Predicted',
                  isDashed: true,
                ),
                const SizedBox(width: 16),
                _buildLegend(const Color(0xFFB565A7), 'Today'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendarDay(
    String day, {
    required Color background,
    required Color textColor,
    bool isDashed = false,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
        border: isDashed
            ? Border.all(color: const Color(0xFFD4537E), width: 1)
            : null,
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label, {bool isDashed = false}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: isDashed
                ? Border.all(color: const Color(0xFFD4537E), width: 1)
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black45),
        ),
      ],
    );
  }

  // ── INSIGHT CARDS ──
  Widget _buildInsightCards(CycleProvider provider) {
    final p = provider.prediction;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: [
        _buildInsightCard(
          'Avg Cycle Length',
          p?.avgCycleLength != null ? '${p!.avgCycleLength} days' : '—',
          'Normal range',
        ),
        _buildInsightCard(
          'Period Duration',
          p?.avgDuration != null ? '${p!.avgDuration} days' : '—',
          'Normal range',
        ),
        _buildInsightCard(
          'Regularity',
          p?.regularity ?? '—',
          p?.variation != null ? 'Varies ±${p!.variation} days' : '',
          valueColor: p?.regularity == 'Irregular'
              ? const Color(0xFF993556)
              : Colors.green,
        ),
        _buildInsightCard(
          'Cycles Logged',
          '${provider.cycles.length} cycles',
          provider.cycles.isNotEmpty
              ? 'Since ${provider.cycles.last.startDate.month}/${provider.cycles.last.startDate.year}'
              : '',
        ),
      ],
    );
  }

  Widget _buildInsightCard(
    String label,
    String value,
    String subtitle, {
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black38),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black87,
            ),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.black38),
            ),
        ],
      ),
    );
  }

  // ── SYMPTOMS SECTION ──
  Widget _buildSymptomsSection(CycleProvider provider) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allSymptoms.map((symptom) {
              final isSelected = _selectedSymptoms.contains(symptom);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSymptoms.remove(symptom);
                    } else {
                      _selectedSymptoms.add(symptom);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFB565A7)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFB565A7)
                          : Colors.black12,
                    ),
                  ),
                  child: Text(
                    symptom,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: provider.isSaving
                  ? null
                  : () async {
                      final success = await provider
                          .logSymptoms(_selectedSymptoms);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Symptoms saved!'
                                  : provider.error ?? 'Failed to save',
                            ),
                            backgroundColor: success
                                ? const Color(0xFFB565A7)
                                : Colors.red,
                          ),
                        );
                      }
                    },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFB565A7),
                side: const BorderSide(color: Color(0xFFB565A7)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: provider.isSaving
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFB565A7),
                      ),
                    )
                  : const Text('Save Symptoms'),
            ),
          ),
        ],
      ),
    );
  }

  // ── SYMPTOM INSIGHTS BUTTON ──
  Widget _buildSymptomInsightsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/symptom-insights');
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFB565A7),
          side: const BorderSide(color: Color(0xFFB565A7)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.insights_outlined, size: 18),
        label: const Text(
          'View Symptom Insights',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ── CYCLE HISTORY ──
  Widget _buildCycleHistory(BuildContext context, CycleProvider provider) {
    if (provider.cycles.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No cycles logged yet',
            style: TextStyle(color: Colors.black38, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      children: provider.cycles.map((cycle) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
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
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEAF0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  color: Color(0xFF993556),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cycle.endDate != null
                          ? '${cycle.startDate.day}/${cycle.startDate.month} → ${cycle.endDate!.day}/${cycle.endDate!.month}'
                          : '${cycle.startDate.day}/${cycle.startDate.month}/${cycle.startDate.year}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (cycle.symptoms.isNotEmpty)
                      Text(
                        cycle.symptoms.join(', '),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (cycle.periodLength != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBEAF0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${cycle.periodLength} days',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF993556),
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
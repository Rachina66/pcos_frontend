// lib/screens/cycle/cycle_tracking_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../providers/cycle/cycle_provider.dart';
import 'daily_log_screen.dart';
import 'cycle_insights_screen.dart';

class CycleTrackingScreen extends StatefulWidget {
  const CycleTrackingScreen({super.key});

  @override
  State<CycleTrackingScreen> createState() => _CycleTrackingScreenState();
}

class _CycleTrackingScreenState extends State<CycleTrackingScreen> {
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CycleProvider>().loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Consumer<CycleProvider>(
        builder: (context, provider, _) {
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
                            _buildLogTodayButton(context, provider),
                            const SizedBox(height: 16),
                            _buildCalendar(provider),
                            const SizedBox(height: 16),
                            _buildSectionTitle('Cycle Insights'),
                            const SizedBox(height: 10),
                            _buildInsightCards(provider),
                            const SizedBox(height: 16),
                            _buildInsightsButton(context),
                            const SizedBox(height: 16),
                            _buildSectionTitle('Cycle History'),
                            const SizedBox(height: 10),
                            _buildCycleHistory(provider),
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

  Widget _buildHeader(BuildContext context, CycleProvider provider) {
    final p = provider.prediction;
    final status = p?.status;

    Color statusColor = Colors.white70;
    String statusLabel = '';
    if (status == 'late') {
      statusColor = const Color(0xFFFFCDD2);
      statusLabel = 'Period may be late';
    } else if (status == 'due') {
      statusColor = const Color(0xFFFFE0B2);
      statusLabel = 'Period due soon';
    }

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

          // Status banner if late or due
          if (statusLabel.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: statusColor.withOpacity(0.5)),
              ),
              child: Text(
                statusLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],

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
                          style: TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                        Text(
                          p?.predicted == true && p?.currentCycleDay != null
                              ? 'Day ${p!.currentCycleDay}'
                              : 'No data',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (p?.predicted == true && p?.nextPeriodStart != null)
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
                              '${p!.nextPeriodStart!.day}/${p.nextPeriodStart!.month}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              p.daysUntil != null && p.daysUntil! >= 0
                                  ? 'in ${p.daysUntil} days'
                                  : '${p.daysUntil!.abs()} days ago',
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
                        p?.lastPeriodDate != null
                            ? '${p!.lastPeriodDate!.day}/${p.lastPeriodDate!.month}/${p.lastPeriodDate!.year}'
                            : '—',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildHeaderStat(
                        'Avg Cycle',
                        p?.avgCycleLength != null
                            ? '${p!.avgCycleLength} days'
                            : '—',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildHeaderStat(
                        'Confidence',
                        p?.confidence != null
                            ? _capitalize(p!.confidence!)
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

  Widget _buildLogTodayButton(BuildContext context, CycleProvider provider) {
    final today = DateTime.now();
    final todayStr = provider.formatDate(today);
    final alreadyLogged = provider.dailyLogs.any(
      (l) =>
          l.date.year == today.year &&
          l.date.month == today.month &&
          l.date.day == today.day,
    );

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DailyLogScreen(date: todayStr)),
          );
          provider.loadAllData();
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
        icon: Icon(
          alreadyLogged ? Icons.edit_outlined : Icons.add_circle_outline,
          size: 20,
        ),
        label: Text(
          alreadyLogged ? 'Edit Today\'s Log' : 'Log Today',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

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
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            onPageChanged: (d) => setState(() => _focusedDay = d),
            onDaySelected: (selected, focused) async {
              setState(() => _focusedDay = focused);
              // Tap any past/today date to log it
              if (!selected.isAfter(DateTime.now())) {
                final provider = context.read<CycleProvider>();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DailyLogScreen(date: provider.formatDate(selected)),
                  ),
                );
                provider.loadAllData();
              }
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final norm = DateTime(day.year, day.month, day.day);
                final isPeriod = provider.periodDays.contains(norm);
                final isPredicted = provider.predictedDays.contains(norm);
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
              weekendTextStyle: TextStyle(color: Colors.black54),
              defaultTextStyle: TextStyle(color: Colors.black87),
            ),
          ),
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
          'Normal: 21–35 days',
        ),
        _buildInsightCard(
          'Period Duration',
          p?.avgPeriodLength != null ? '${p!.avgPeriodLength} days' : '—',
          'Normal: 3–7 days',
        ),
        _buildInsightCard(
          'Regularity',
          p?.regularity != null ? _capitalize(p!.regularity!) : '—',
          p?.variation != null ? 'Varies ±${p!.variation} days' : '',
          valueColor: p?.regularity == 'irregular'
              ? const Color(0xFF993556)
              : p?.regularity == 'regular'
              ? Colors.green
              : Colors.black87,
        ),
        _buildInsightCard(
          'Confidence',
          p?.confidence != null ? _capitalize(p!.confidence!) : '—',
          'Based on ${p?.basedOn ?? 0} cycle(s)',
          valueColor: p?.confidence == 'high'
              ? Colors.green
              : p?.confidence == 'medium'
              ? Colors.orange
              : Colors.black54,
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

  Widget _buildInsightsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CycleInsightsScreen()),
        ),
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
          'View Insights',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCycleHistory(CycleProvider provider) {
    if (provider.cycles.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.water_drop_outlined, size: 40, color: Colors.black12),
              SizedBox(height: 10),
              Text(
                'No cycles logged yet',
                style: TextStyle(color: Colors.black38, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'Tap Log Today to get started',
                style: TextStyle(color: Colors.black26, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: provider.cycles.map((cycle) {
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEAF0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  color: Color(0xFF993556),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${cycle.startDate.day}/${cycle.startDate.month} - ${cycle.endDate.day}/${cycle.endDate.month}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${cycle.startDate.year}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
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

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

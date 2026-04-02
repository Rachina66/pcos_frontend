import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../providers/cycle/cycle_provider.dart';

class LogPeriodBottomSheet extends StatefulWidget {
  final VoidCallback onSaved;

  const LogPeriodBottomSheet({super.key, required this.onSaved});

  @override
  State<LogPeriodBottomSheet> createState() => _LogPeriodBottomSheetState();
}

class _LogPeriodBottomSheetState extends State<LogPeriodBottomSheet> {
  final Set<DateTime> _selectedDays = {};
  final TextEditingController _notesController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  List<String> _selectedSymptoms = [];

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

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  DateTime? get _startDate {
    if (_selectedDays.isEmpty) return null;
    return _selectedDays.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  DateTime? get _endDate {
    if (_selectedDays.isEmpty) return null;
    return _selectedDays.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _save() async {
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final startDate = _startDate!;
    final endDate = _endDate!;

    final String startStr =
        '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    final String endStr =
        '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

    final success = await context.read<CycleProvider>().logPeriod(
      startDate: startStr,
      endDate: endStr,
      symptoms: _selectedSymptoms,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      widget.onSaved();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Period logged successfully!'),
          backgroundColor: Color(0xFFB565A7),
        ),
      );
    } else {
      final error =
          context.read<CycleProvider>().error ?? 'Failed to log period';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ── Drag Handle ──
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Title ──
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(
                  'Log Your Period',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Instruction ──
                  const Text(
                    'Tap the days your period occurred',
                    style: TextStyle(fontSize: 13, color: Colors.black45),
                  ),
                  const SizedBox(height: 12),

                  // ── Calendar ──
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.08)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.now().subtract(
                        const Duration(days: 180),
                      ),
                      lastDay: DateTime.now(),
                      focusedDay: _focusedDay,
                      calendarFormat: CalendarFormat.month,
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month',
                      },
                      selectedDayPredicate: (day) {
                        final normalized = DateTime(
                          day.year,
                          day.month,
                          day.day,
                        );
                        return _selectedDays.contains(normalized);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        final normalized = DateTime(
                          selectedDay.year,
                          selectedDay.month,
                          selectedDay.day,
                        );
                        setState(() {
                          _focusedDay = focusedDay;
                          if (_selectedDays.contains(normalized)) {
                            _selectedDays.remove(normalized);
                          } else {
                            _selectedDays.add(normalized);
                          }
                        });
                      },
                      onPageChanged: (focusedDay) {
                        setState(() => _focusedDay = focusedDay);
                      },
                      calendarStyle: const CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Color(0xFFB565A7),
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Color(0xFFE8A0D5),
                          shape: BoxShape.circle,
                        ),
                        weekendTextStyle: TextStyle(color: Colors.black54),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // ── Selected Summary ──
                  if (_selectedDays.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBEAF0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.water_drop_outlined,
                            color: Color(0xFF993556),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _startDate == _endDate
                                ? _formatDate(_startDate!)
                                : '${_formatDate(_startDate!)} → ${_formatDate(_endDate!)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF993556),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${_selectedDays.length} day${_selectedDays.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF993556),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // ── Symptoms ──
                  const Text(
                    'Symptoms',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
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

                  const SizedBox(height: 20),

                  // ── Notes ──
                  const Text(
                    'Notes (optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Any additional notes...',
                      hintStyle: const TextStyle(
                        color: Colors.black38,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Save Button ──
                  Consumer<CycleProvider>(
                    builder: (context, provider, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: provider.isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB565A7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: provider.isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Save Period Log',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

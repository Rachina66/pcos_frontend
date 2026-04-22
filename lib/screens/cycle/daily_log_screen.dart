import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cycle/cycle_provider.dart';

class DailyLogScreen extends StatefulWidget {
  final String date;

  const DailyLogScreen({super.key, required this.date});

  @override
  State<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends State<DailyLogScreen> {
  bool _isPeriod = false;
  String? _flow;
  String? _mood;
  int _energy = 3;
  List<String> _selectedSymptoms = [];
  final _notesController = TextEditingController();
  bool _isLoaded = false;

  final List<String> _allSymptoms = [
    'Cramps',
    'Bloating',
    'Fatigue',
    'Headache',
    'Mood Swings',
    'Acne',
    'Back Pain',
    'Nausea',
    'Hair Loss',
    'Excess Hair',
    'Weight Gain',
    'Spotting',
  ];

  final List<Map<String, dynamic>> _moods = [
    {
      'label': 'Happy',
      'value': 'HAPPY',
      'icon': Icons.sentiment_very_satisfied_outlined,
    },
    {
      'label': 'Neutral',
      'value': 'NEUTRAL',
      'icon': Icons.sentiment_neutral_outlined,
    },
    {
      'label': 'Sad',
      'value': 'SAD',
      'icon': Icons.sentiment_dissatisfied_outlined,
    },
    {
      'label': 'Irritable',
      'value': 'IRRITABLE',
      'icon': Icons.sentiment_very_dissatisfied_outlined,
    },
    {'label': 'Tired', 'value': 'TIRED', 'icon': Icons.bedtime_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingLog();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingLog() async {
    final provider = context.read<CycleProvider>();

    // Check if we already have this log in memory
    final parts = widget.date.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    final existing = provider.dailyLogs
        .where(
          (l) =>
              l.date.year == year && l.date.month == month && l.date.day == day,
        )
        .toList();

    if (existing.isNotEmpty) {
      final log = existing.first;
      setState(() {
        _isPeriod = log.isPeriod;
        _flow = log.flow;
        _mood = log.mood;
        _energy = log.energy ?? 3;
        _selectedSymptoms = List<String>.from(log.symptoms);
        _notesController.text = log.notes ?? '';
      });
    }

    setState(() => _isLoaded = true);
  }

  String _formatDisplayDate() {
    final parts = widget.date.split('-');
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _save() async {
    final provider = context.read<CycleProvider>();

    final success = await provider.upsertDailyLog(
      date: widget.date,
      isPeriod: _isPeriod,
      flow: _isPeriod ? _flow : null,
      mood: _mood,
      energy: _energy,
      symptoms: _selectedSymptoms,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Log saved successfully!'),
          backgroundColor: const Color(0xFFB565A7),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to save log'),
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: !_isLoaded
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
                          // Date display
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Color(0xFFB565A7),
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _formatDisplayDate(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Period toggle
                          _buildSectionCard(
                            title: 'Period',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'On your period today?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                Switch(
                                  value: _isPeriod,
                                  onChanged: (val) =>
                                      setState(() => _isPeriod = val),
                                  activeColor: const Color(0xFFB565A7),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Flow — only if on period
                          if (_isPeriod) ...[
                            _buildSectionCard(
                              title: 'Flow intensity',
                              child: Row(
                                children: ['LIGHT', 'MEDIUM', 'HEAVY']
                                    .map(
                                      (f) => Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: GestureDetector(
                                            onTap: () =>
                                                setState(() => _flow = f),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _flow == f
                                                    ? const Color(0xFFB565A7)
                                                    : const Color(0xFFF5F5F5),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: _flow == f
                                                      ? const Color(0xFFB565A7)
                                                      : Colors.transparent,
                                                ),
                                              ),
                                              child: Text(
                                                _capitalize(f.toLowerCase()),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: _flow == f
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          // Mood
                          _buildSectionCard(
                            title: 'Mood',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _moods.map((m) {
                                final isSelected = _mood == m['value'];
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _mood = m['value']),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(
                                                  0xFFB565A7,
                                                ).withOpacity(0.15)
                                              : const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFFB565A7)
                                                : Colors.transparent,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            m['icon'] as IconData,
                                            size: 22,
                                            color: isSelected
                                                ? const Color(0xFFB565A7)
                                                : Colors.black38,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        m['label'],
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isSelected
                                              ? const Color(0xFFB565A7)
                                              : Colors.black38,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Energy
                          _buildSectionCard(
                            title: 'Energy level',
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Very Low',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black38,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFB565A7,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '$_energy / 5',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFB565A7),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'High',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                                Slider(
                                  value: _energy.toDouble(),
                                  min: 1,
                                  max: 5,
                                  divisions: 4,
                                  activeColor: const Color(0xFFB565A7),
                                  inactiveColor: const Color(
                                    0xFFB565A7,
                                  ).withOpacity(0.2),
                                  onChanged: (val) =>
                                      setState(() => _energy = val.round()),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Symptoms
                          _buildSectionCard(
                            title: 'Symptoms',
                            subtitle: 'Optional',
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _allSymptoms.map((symptom) {
                                final isSelected = _selectedSymptoms.contains(
                                  symptom,
                                );
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    if (isSelected) {
                                      _selectedSymptoms.remove(symptom);
                                    } else {
                                      _selectedSymptoms.add(symptom);
                                    }
                                  }),
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
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Notes
                          _buildSectionCard(
                            title: 'Notes',
                            subtitle: 'Optional',
                            child: TextField(
                              controller: _notesController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'How are you feeling today?',
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
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Save button
                          Consumer<CycleProvider>(
                            builder: (context, provider, _) => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: provider.isSaving ? null : _save,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB565A7),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
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
                                        'Save Log',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
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
              'Daily Log',
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

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
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
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

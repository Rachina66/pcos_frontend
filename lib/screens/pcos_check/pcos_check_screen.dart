import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pcos_blood_test_screen.dart';

class PcosCheckScreen extends StatefulWidget {
  const PcosCheckScreen({super.key});

  @override
  State<PcosCheckScreen> createState() => _PcosCheckScreenState();
}

class _PcosCheckScreenState extends State<PcosCheckScreen> {
  int _currentQuestion = 0;
  final Map<String, dynamic> _answers = {};

  // controllers for input questions
  final _inputController1 = TextEditingController();
  final _inputController2 = TextEditingController();

  final List<Map<String, dynamic>> _questions = [
    {
      'title': 'How old are you?',
      'subtitle': 'Enter your age in years',
      'type': 'input',
      'hint': 'e.g. 25',
      'key': 'age',
    },
    {
      'title': 'Your Weight & Height',
      'subtitle': 'We will calculate your BMI automatically',
      'type': 'double_input',
      'hint1': 'Weight (kg) e.g. 60',
      'hint2': 'Height (cm) e.g. 160',
      'key': 'weight_height',
    },
    {
      'title': 'Blood Group',
      'subtitle': 'Select your blood group',
      'type': 'single',
      'options': [
        'A positive',
        'A negative',
        'B positive',
        'B negative',
        'O positive',
        'O negative',
        'AB positive',
        'AB negative',
      ],
      'key': 'bloodGroup',
    },
    {
      'title': 'Menstrual Cycle Regularity',
      'subtitle': 'How regular is your menstrual cycle?',
      'type': 'single',
      'options': [
        'Regular (21-35 days)',
        'Irregular (36-45 days)',
        'Absent/Very irregular (>45 days)',
      ],
      'key': 'cycle',
    },
    {
      'title': 'Period Length',
      'subtitle': 'How long does your period usually last?',
      'type': 'single',
      'options': ['Short (1-3 days)', 'Normal (4-7 days)', 'Long (>7 days)'],
      'key': 'periodLength',
    },
    {
      'title': 'Excessive Hair Growth?',
      'subtitle':
          'Do you experience excessive facial or body hair growth? (Hirsutism)',
      'type': 'single',
      'options': ['Yes', 'No'],
      'key': 'hirsutism',
    },
    {
      'title': 'Activity Level',
      'subtitle': 'How active are you on a daily basis?',
      'type': 'single',
      'options': [
        'Very active (gym/sports daily)',
        'Moderately active (3-4x/week)',
        'Slightly active (light walks)',
        'Sedentary (mostly sitting)',
      ],
      'key': 'activityLevel',
    },
    {
      'title': 'Stress Level',
      'subtitle': 'How would you describe your stress level?',
      'type': 'single',
      'options': [
        'Low (rarely stressed)',
        'Moderate (sometimes stressed)',
        'High (frequently stressed)',
      ],
      'key': 'stressLevel',
    },
    {
      'title': 'Pregnancy Status',
      'subtitle': 'Are you currently pregnant?',
      'type': 'single',
      'options': ['Yes', 'No'],
      'key': 'pregnant',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDisclaimerDialog();
    });
  }

  @override
  void dispose() {
    _inputController1.dispose();
    _inputController2.dispose();
    super.dispose();
  }

  Future<void> _openNearbyLab() async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/pathology+lab+near+me',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFB565A7).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: Color(0xFFB565A7),
                  size: 30,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Before You Begin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This assessment uses your clinical test results for accurate PCOS risk prediction.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F0F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You will also need:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildRequirement(
                      'Blood test results',
                      'FSH, LH, Androgen, Glucose levels',
                    ),
                    const SizedBox(height: 6),
                    _buildRequirement(
                      'Ultrasound report',
                      'Cyst count from sonography',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _openNearbyLab();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB565A7),
                    side: const BorderSide(color: Color(0xFFB565A7)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.location_on_outlined, size: 16),
                  label: const Text(
                    'Find Nearby Lab',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB565A7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'I Have My Reports, Start',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFFB565A7), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.black45),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _canGoNext() {
    final question = _questions[_currentQuestion];
    final key = question['key'];
    final type = question['type'];

    if (type == 'input') {
      return _inputController1.text.trim().isNotEmpty;
    }
    if (type == 'double_input') {
      return _inputController1.text.trim().isNotEmpty &&
          _inputController2.text.trim().isNotEmpty;
    }
    return _answers.containsKey(key);
  }

  void _goNext() {
    final question = _questions[_currentQuestion];
    final type = question['type'];
    final key = question['key'];

    // save input values
    if (type == 'input') {
      _answers[key] = _inputController1.text.trim();
      _inputController1.clear();
    } else if (type == 'double_input') {
      _answers['weight'] = _inputController1.text.trim();
      _answers['height'] = _inputController2.text.trim();
      final weight = double.tryParse(_inputController1.text) ?? 0;
      final height = double.tryParse(_inputController2.text) ?? 0;
      if (height > 0) {
        _answers['bmi'] = (weight / ((height / 100) * (height / 100)))
            .toStringAsFixed(1);
      }
      _inputController1.clear();
      _inputController2.clear();
    }

    if (_currentQuestion < _questions.length - 1) {
      setState(() => _currentQuestion++);
    } else {
      _submitAssessment();
    }
  }

  void _goBack() {
    if (_currentQuestion > 0) {
      setState(() => _currentQuestion--);
    } else {
      Navigator.pop(context);
    }
  }

  void _submitAssessment() {
    // map answers to API fields
    final cycle = _answers['cycle'] ?? '';
    double cycleLengthDays = 28;
    bool regularOvulation = true;

    if (cycle.contains('Regular')) {
      cycleLengthDays = 28;
      regularOvulation = true;
    } else if (cycle.contains('Irregular')) {
      cycleLengthDays = 40;
      regularOvulation = false;
    } else if (cycle.contains('Absent')) {
      cycleLengthDays = 50;
      regularOvulation = false;
    }

    final period = _answers['periodLength'] ?? '';
    double periodLengthDays = 5;
    if (period.contains('Short'))
      periodLengthDays = 2;
    else if (period.contains('Normal'))
      periodLengthDays = 5;
    else if (period.contains('Long'))
      periodLengthDays = 8;

    final activity = _answers['activityLevel'] ?? '';
    int activityLevel = 3;
    if (activity.contains('Very'))
      activityLevel = 5;
    else if (activity.contains('Moderately'))
      activityLevel = 4;
    else if (activity.contains('Slightly'))
      activityLevel = 2;
    else if (activity.contains('Sedentary'))
      activityLevel = 1;

    final stress = _answers['stressLevel'] ?? '';
    int stressLevel = 3;
    if (stress.contains('Low'))
      stressLevel = 2;
    else if (stress.contains('Moderate'))
      stressLevel = 3;
    else if (stress.contains('High'))
      stressLevel = 5;

    // pass to blood test screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PcosBloodTestScreen(
          age: double.tryParse(_answers['age'] ?? '0') ?? 0,
          weight: double.tryParse(_answers['weight'] ?? '0') ?? 0,
          height: double.tryParse(_answers['height'] ?? '0') ?? 0,
          bmi: double.tryParse(_answers['bmi'] ?? '0') ?? 0,
          bloodGroup: _answers['bloodGroup'] ?? 'Unknown',
          cycleLengthDays: cycleLengthDays,
          periodLengthDays: periodLengthDays,
          regularOvulation: regularOvulation,
          hirsutism: _answers['hirsutism'] == 'Yes',
          activityLevel: activityLevel,
          stressLevel: stressLevel,
          pregnant: _answers['pregnant'] == 'Yes',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;
    final percentage = (progress * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(context, percentage, progress),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildQuestionCard(question),
                ],
              ),
            ),
          ),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int percentage, double progress) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 16,
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
                onTap: _goBack,
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
                  'PCOS Assessment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestion + 1} of ${_questions.length}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            question['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB565A7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question['subtitle'],
            style: const TextStyle(fontSize: 13, color: Colors.black45),
          ),
          const SizedBox(height: 20),
          if (question['type'] == 'input') _buildInputField(question),
          if (question['type'] == 'double_input')
            _buildDoubleInputField(question),
          if (question['type'] == 'single') _buildOptions(question),
        ],
      ),
    );
  }

  Widget _buildInputField(Map<String, dynamic> question) {
    return TextField(
      controller: _inputController1,
      keyboardType: TextInputType.number,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: question['hint'],
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB565A7), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildDoubleInputField(Map<String, dynamic> question) {
    return Column(
      children: [
        TextField(
          controller: _inputController1,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: question['hint1'],
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFB565A7),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _inputController2,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: question['hint2'],
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFB565A7),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptions(Map<String, dynamic> question) {
    final key = question['key'];
    return Column(
      children: List.generate((question['options'] as List).length, (index) {
        final option = question['options'][index];
        final isSelected = _answers[key] == option;

        return GestureDetector(
          onTap: () => setState(() => _answers[key] = option),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFB565A7).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFFB565A7) : Colors.black12,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFB565A7)
                          : Colors.black26,
                      width: 1.5,
                    ),
                    color: isSelected ? const Color(0xFFB565A7) : Colors.white,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? const Color(0xFFB565A7)
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNextButton() {
    final isLast = _currentQuestion == _questions.length - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _canGoNext() ? _goNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB565A7),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLast ? 'Next →' : 'Next',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                isLast ? Icons.arrow_forward : Icons.arrow_forward,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

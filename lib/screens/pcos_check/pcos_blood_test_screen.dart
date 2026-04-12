import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/prediction/prediction_provider.dart';
import 'pcos_results_screen.dart';

class PcosBloodTestScreen extends StatefulWidget {
  final double age;
  final double weight;
  final double height;
  final double bmi;
  final String bloodGroup;
  final double cycleLengthDays;
  final double periodLengthDays;
  final bool regularOvulation;
  final bool hirsutism;
  final int activityLevel;
  final int stressLevel;
  final bool pregnant;

  const PcosBloodTestScreen({
    super.key,
    required this.age,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.bloodGroup,
    required this.cycleLengthDays,
    required this.periodLengthDays,
    required this.regularOvulation,
    required this.hirsutism,
    required this.activityLevel,
    required this.stressLevel,
    required this.pregnant,
  });

  @override
  State<PcosBloodTestScreen> createState() => _PcosBloodTestScreenState();
}

class _PcosBloodTestScreenState extends State<PcosBloodTestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fshController = TextEditingController();
  final _lhController = TextEditingController();
  final _androgenController = TextEditingController();
  final _cystCountController = TextEditingController();
  final _glucoseController = TextEditingController();

  @override
  void dispose() {
    _fshController.dispose();
    _lhController.dispose();
    _androgenController.dispose();
    _cystCountController.dispose();
    _glucoseController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await context.read<PredictionProvider>().predict(
      age: widget.age,
      weight: widget.weight,
      height: widget.height,
      bmi: widget.bmi,
      bloodGroup: widget.bloodGroup,
      cycleLengthDays: widget.cycleLengthDays,
      periodLengthDays: widget.periodLengthDays,
      regularOvulation: widget.regularOvulation,
      fshLevel: double.parse(_fshController.text),
      lhLevel: double.parse(_lhController.text),
      androgenLevel: double.parse(_androgenController.text),
      cystCount: double.parse(_cystCountController.text),
      hirsutism: widget.hirsutism,
      fastingGlucose: double.parse(_glucoseController.text),
      activityLevel: widget.activityLevel,
      stressLevel: widget.stressLevel,
      pregnant: widget.pregnant,
    );

    if (!mounted) return;

    if (success) {
      final result = context.read<PredictionProvider>().latestResult!;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PcosResultScreen(result: result)),
      );
    } else {
      final error = context.read<PredictionProvider>().error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // info note
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F0F7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFB565A7).withOpacity(0.3),
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFFB565A7),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Enter the values from your recent blood test and ultrasound report. Ask your doctor if unsure.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('FSH Level (mIU/mL)'),
                    _buildField(
                      controller: _fshController,
                      hint: 'e.g. 7.5',
                      min: 0,
                      max: 200,
                      label: 'FSH',
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('LH Level (mIU/mL)'),
                    _buildField(
                      controller: _lhController,
                      hint: 'e.g. 3.2',
                      min: 0,
                      max: 200,
                      label: 'LH',
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('Androgen Level'),
                    _buildField(
                      controller: _androgenController,
                      hint: 'e.g. 65.0',
                      min: 0,
                      max: 500,
                      label: 'Androgen',
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('Cyst Count (from ultrasound)'),
                    _buildField(
                      controller: _cystCountController,
                      hint: 'e.g. 5',
                      min: 0,
                      max: 50,
                      label: 'Cyst Count',
                    ),
                    const SizedBox(height: 16),

                    _buildLabel('Fasting Glucose (mg/dL)'),
                    _buildField(
                      controller: _glucoseController,
                      hint: 'e.g. 95',
                      min: 50,
                      max: 400,
                      label: 'Fasting Glucose',
                    ),
                    const SizedBox(height: 32),

                    Consumer<PredictionProvider>(
                      builder: (context, provider, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: provider.isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB565A7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: provider.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Check PCOS Risk',
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
              'Blood Test Values',
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

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required double min,
    required double max,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (v) {
        final val = double.tryParse(v ?? '');
        if (val == null || val < min || val > max) {
          return 'Enter valid $label ($min - $max)';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB565A7), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

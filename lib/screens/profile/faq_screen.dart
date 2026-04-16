// lib/screens/profile/faq_screen.dart

import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'What is PCOS?',
      'answer':
          'Polycystic Ovary Syndrome (PCOS) is a hormonal disorder common among women of reproductive age. It involves irregular periods, excess androgen levels, and polycystic ovaries. It can affect fertility, metabolism, and overall health.',
    },
    {
      'question': 'How accurate is the PCOS prediction?',
      'answer':
          'Our ML model is trained on clinical data including hormonal levels, cycle patterns, and physical indicators. It provides a risk assessment — not a diagnosis. Always consult a healthcare professional for a proper medical diagnosis.',
    },
    {
      'question': 'What blood tests do I need for the assessment?',
      'answer':
          'You need FSH (Follicle Stimulating Hormone), LH (Luteinizing Hormone), Androgen levels, and Fasting Glucose levels. You also need an ultrasound report showing cyst count.',
    },
    {
      'question': 'How does the meal plan work?',
      'answer':
          'Based on your PCOS risk level and diet preference, we generate a 7-day personalised meal plan. It is based on a 2022 Mediterranean Low-Carb clinical trial that showed 86.7% menstrual cycle restoration in PCOS patients after 12 weeks.',
    },
    {
      'question': 'Can I change my meal plan?',
      'answer':
          'Yes! You can swap individual meals using the "Swap this Meal" button, or regenerate your entire plan using the refresh button at the top of the meal plan screen.',
    },
    {
      'question': 'How does cycle tracking work?',
      'answer':
          'Log your period start and end dates using the Log Period screen. The app calculates your average cycle length, predicts your next period, and tracks symptom trends across cycles.',
    },
    {
      'question': 'How many cycles do I need to log for insights?',
      'answer':
          'You need at least 2 cycles logged to see symptom insights and trend analysis. More cycles logged means more accurate predictions and insights.',
    },
    {
      'question': 'Is my health data private?',
      'answer':
          'Yes. Your health data is stored securely and is only accessible to you. We do not share your personal health information with third parties.',
    },
    {
      'question': 'Can I book a doctor appointment through the app?',
      'answer':
          'Yes! Go to the Doctors section from the home screen to browse available doctors, view their profiles, and book appointments. You can also upload your medical reports when booking.',
    },
    {
      'question': 'What does "Low Risk" and "High Risk" mean?',
      'answer':
          'Low Risk means your clinical indicators suggest a lower likelihood of PCOS. High Risk means your indicators suggest a higher likelihood. This is a risk assessment only — consult a doctor for actual diagnosis.',
    },
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _faqs.length,
              itemBuilder: (context, index) {
                final faq = _faqs[index];
                final isExpanded = _expandedIndex == index;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: isExpanded
                        ? Border.all(
                            color: const Color(0xFFB565A7).withOpacity(0.3),
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => setState(() {
                          _expandedIndex = isExpanded ? null : index;
                        }),
                        title: Text(
                          faq['question']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isExpanded
                                ? const Color(0xFFB565A7)
                                : Colors.black87,
                          ),
                        ),
                        trailing: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: isExpanded
                              ? const Color(0xFFB565A7)
                              : Colors.black38,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                      ),
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          child: Text(
                            faq['answer']!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ),
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
              'FAQ',
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
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class PetQuizScreen extends StatefulWidget {
  const PetQuizScreen({Key? key}) : super(key: key);

  @override
  State<PetQuizScreen> createState() => _PetQuizScreenState();
}

class _PetQuizScreenState extends State<PetQuizScreen> {
  int _currentQuestionIndex = 0;

  // Dynamic Decision Matrix Variables
  double _catCompatibility = 0;
  double _dogCompatibility = 0;
  double _spaceFactor = 0;

  final List<Map<String, Object>> _questions = [
    {
      'questionText': 'What type of home environment do you manage?',
      'answers': [
        {
          'text': 'Apartment / Cozy Studio',
          'cat': 25.0,
          'dog': 10.0,
          'space': 5.0
        },
        {
          'text': 'House with a Small Yard',
          'cat': 20.0,
          'dog': 20.0,
          'space': 15.0
        },
        {
          'text': 'Spacious House with a Garden',
          'cat': 15.0,
          'dog': 30.0,
          'space': 30.0
        },
      ],
    },
    {
      'questionText': 'How much daily active time can you invest?',
      'answers': [
        {
          'text': 'Minimal (<30 mins) - Low maintenance',
          'cat': 30.0,
          'dog': 5.0,
          'space': 0.0
        },
        {
          'text': 'Moderate (30-60 mins) - Balanced play',
          'cat': 20.0,
          'dog': 20.0,
          'space': 10.0
        },
        {
          'text': 'High (1+ hour) - Highly energetic',
          'cat': 5.0,
          'dog': 35.0,
          'space': 20.0
        },
      ],
    },
    {
      'questionText': 'Describe your typical daily occupancy routine:',
      'answers': [
        {
          'text': 'Remote Work / High Availability',
          'cat': 20.0,
          'dog': 30.0,
          'space': 0.0
        },
        {
          'text': 'Hybrid Schedule / Moderately Away',
          'cat': 25.0,
          'dog': 15.0,
          'space': 0.0
        },
        {
          'text': 'Frequent Travel / Full-time Office',
          'cat': 15.0,
          'dog': 5.0,
          'space': 0.0
        },
      ],
    },
    {
      'questionText': 'What is your preference regarding shedding and grooming?',
      'answers': [
        {
          'text': 'Strictly low shedding / hypoallergenic',
          'cat': 10.0,
          'dog': 10.0,
          'space': 0.0
        },
        {
          'text': 'Don\'t mind regular maintenance and brushing',
          'cat': 25.0,
          'dog': 25.0,
          'space': 0.0
        },
      ],
    }
  ];

  void _processDecisionMatrix(double cat, double dog, double space) {
    _catCompatibility += cat;
    _dogCompatibility += dog;
    _spaceFactor += space;

    setState(() {
      _currentQuestionIndex++;
    });
  }

  void _resetMatrix() {
    setState(() {
      _currentQuestionIndex = 0;
      _catCompatibility = 0;
      _dogCompatibility = 0;
      _spaceFactor = 0;
    });
  }

  Map<String, dynamic> _calculateFinalRecommendation() {
    double totalCombined = _catCompatibility + _dogCompatibility;
    double catPercentage = (_catCompatibility / totalCombined) * 100;
    double dogPercentage = (_dogCompatibility / totalCombined) * 100;

    if (catPercentage > dogPercentage && _spaceFactor < 25) {
      return {
        'title': 'Premium Persian or British Shorthair Cat',
        'type': 'Feline Companion',
        'catPct': catPercentage.toStringAsFixed(1),
        'dogPct': dogPercentage.toStringAsFixed(1),
        'desc': 'Our matrix identified that your quiet routine and optimized living space show an outstanding affinity for a cat companion.'
      };
    } else if (dogPercentage >= catPercentage && _spaceFactor >= 20) {
      return {
        'title': 'Loyal Golden Retriever or Active Pup',
        'type': 'Canine Companion',
        'catPct': catPercentage.toStringAsFixed(1),
        'dogPct': dogPercentage.toStringAsFixed(1),
        'desc': 'Your high energy metrics and spacious environment heavily weigh towards a canine companion who requires active engagement.'
      };
    } else {
      return {
        'title': 'Pocket-Sized Companion (Pug / French Bulldog)',
        'type': 'Adaptive Breed',
        'catPct': catPercentage.toStringAsFixed(1),
        'dogPct': dogPercentage.toStringAsFixed(1),
        'desc': 'Your metrics show a hybrid need—high companionship desire but constrained space. An adaptive small dog breed is optimal.'
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFinished = _currentQuestionIndex >= _questions.length;
    final evaluation = isFinished ? _calculateFinalRecommendation() : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'AI Decision Matrix Quiz',
          style: GoogleFonts.jost(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: !isFinished
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: (_currentQuestionIndex + 1) / _questions.length,
                      backgroundColor: const Color(0xffEFC7E8).withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff8D11CB)),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Analytical Node Evaluation: ${_currentQuestionIndex + 1} / ${_questions.length}',
                      style: GoogleFonts.jost(
                        color: const Color(0xff8D11CB),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _questions[_currentQuestionIndex]['questionText'] as String,
                      style: GoogleFonts.jost(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ...(_questions[_currentQuestionIndex]['answers'] as List<Map<String, dynamic>>).map((answer) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _processDecisionMatrix(
                              answer['cat'] as double,
                              answer['dog'] as double,
                              answer['space'] as double,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              side: const BorderSide(color: Color(0xffEFC7E8), width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                answer['text'] as String,
                                style: GoogleFonts.jost(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      // 1. Theme Cohesive Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xff8D11CB).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome, size: 14, color: Color(0xff8D11CB)),
                            const SizedBox(width: 6),
                            Text(
                              'MATCH FOUND',
                              style: GoogleFonts.jost(
                                fontSize: 10,
                                color: const Color(0xff8D11CB),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2. Main Match Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          evaluation!['title']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jost(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xff1A1A1A),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 3. Match Analytics Panel
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0xffEFC7E8), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff8D11CB).withOpacity(0.04),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            // Feline Affinity Matrix Row
                            Row(
                              children: [
                                Text(
                                  '🐱 Feline Match Ratio',
                                  style: GoogleFonts.jost(fontWeight: FontWeight.w700, fontSize: 13, color: const Color(0xff2D2D2D)),
                                ),
                                const Spacer(),
                                Text(
                                  '${evaluation['catPct']}%',
                                  style: GoogleFonts.jost(fontWeight: FontWeight.w800, fontSize: 14, color: const Color(0xff8D11CB)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 8,
                              width: double.infinity,
                              decoration: BoxDecoration(color: const Color(0xffF5F5F7), borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 800),
                                    width: (MediaQuery.of(context).size.width - 88) * (double.parse(evaluation['catPct']!) / 100),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff8D11CB),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Canine Affinity Matrix Row
                            Row(
                              children: [
                                Text(
                                  '🐶 Canine Match Ratio',
                                  style: GoogleFonts.jost(fontWeight: FontWeight.w700, fontSize: 13, color: const Color(0xff2D2D2D)),
                                ),
                                const Spacer(),
                                Text(
                                  '${evaluation['dogPct']}%',
                                  style: GoogleFonts.jost(fontWeight: FontWeight.w800, fontSize: 14, color: const Color(0xff8D11CB)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 8,
                              width: double.infinity,
                              decoration: BoxDecoration(color: const Color(0xffF5F5F7), borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 800),
                                    width: (MediaQuery.of(context).size.width - 88) * (double.parse(evaluation['dogPct']!) / 100),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffEFC7E8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 4. Description Box (Soft Light Pink Tint)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xffEFC7E8).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xffEFC7E8).withOpacity(0.5), width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xff8D11CB)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                evaluation['desc']!,
                                style: GoogleFonts.jost(
                                  fontSize: 12.5,
                                  color: const Color(0xff8D11CB),
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // 5. Action Elements (Firebase Integration)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              final user = FirebaseAuth.instance.currentUser;

                              if (user != null) {
                                await FirebaseFirestore.instance
                                    .collection('quiz_results')
                                    .doc(user.uid)
                                    .set({
                                  'userId': user.uid,
                                  'matchTitle': evaluation['title'],
                                  'matchType': evaluation['type'],
                                  'felineScore': evaluation['catPct'],
                                  'canineScore': evaluation['dogPct'],
                                  'timestamp': FieldValue.serverTimestamp(),
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Saved successfully!', style: GoogleFonts.jost()),
                                    backgroundColor: const Color(0xff8D11CB),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('No active user session found.', style: GoogleFonts.jost())),
                                );
                              }
                            } catch (e) {
                              print("Firebase Save Error: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to save: $e', style: GoogleFonts.jost())),
                              );
                            }

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8D11CB),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Save Profile & Exit',
                            style: GoogleFonts.jost(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      TextButton(
                        onPressed: _resetMatrix,
                        child: Text(
                          'Retake Quiz',
                          style: GoogleFonts.jost(
                            color: const Color(0xff686868),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
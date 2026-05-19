import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart'; // 🔥 Premium typography ke liye
import '../../../resources/colors/app_colors.dart'; // Apni colors file ka sahi path check kar lena
import 'pet_quiz_screen.dart';

class PawsAiScreen extends StatefulWidget {
  const PawsAiScreen({Key? key}) : super(key: key);

  @override
  State<PawsAiScreen> createState() => _PawsAiScreenState();
}

class _PawsAiScreenState extends State<PawsAiScreen> {
  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Row(
                children: [
                  Text(
                    'Paws AI Hub',
                    style: GoogleFonts.jost(
                      fontSize: 26, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black87, // 🔥 App Theme Match
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.auto_awesome, color: AppColors.DarkPink),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Advanced smart tools for your pet journey',
                style: GoogleFonts.jost(fontSize: 14, color: const Color(0xff686868)),
              ),
              const SizedBox(height: 24),

              // --- Interactive Quiz Card ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  // Premium soft aesthetic blend
                  color: AppColors.DarkPink.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.DarkPink.withOpacity(0.15), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'INTERACTIVE',
                        style: GoogleFonts.jost(
                          fontSize: 10, 
                          fontWeight: FontWeight.bold, 
                          color: AppColors.DarkPink,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Find Your Perfect Match',
                      style: GoogleFonts.jost(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take our 1-minute smart lifestyle quiz to discover your ideal pet companion.',
                      style: GoogleFonts.jost(fontSize: 13, color: const Color(0xff555555), height: 1.4),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PetQuizScreen()),
                        );
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.DarkPink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Start Quiz', 
                        style: GoogleFonts.jost(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Firebase Recent Quiz Result ---
              Text(
                'Your History',
                style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 12),

              _currentUserId == null
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "Please log in to see your history.",
                          style: GoogleFonts.jost(color: Colors.grey),
                        ),
                      ),
                    )
                  : StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection('quiz_results').doc(_currentUserId).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.DarkPink));
                        }

                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Center(
                              child: Text(
                                'No recent quiz results found.',
                                style: GoogleFonts.jost(color: Colors.grey, fontSize: 13),
                              ),
                            ),
                          );
                        }

                        var data = snapshot.data!.data() as Map<String, dynamic>;
                        String breedName = data['matchTitle'] ?? 'Unknown Pet';
                        String matchType = data['matchType'] ?? 'Match';
                        String? catImageUrl = data['matchImage'];

                        String matchDate = "Recent";
                        if (data['timestamp'] != null) {
                          DateTime date = (data['timestamp'] as Timestamp).toDate();
                          matchDate = "${date.day}/${date.month}/${date.year}";
                        }

                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: AppColors.DarkPink.withOpacity(0.2), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // --- Dynamic Pet Image ---
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: catImageUrl != null && catImageUrl.isNotEmpty
                                    ? Image.network(
                                        catImageUrl,
                                        width: 55,
                                        height: 55,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 55,
                                            height: 55,
                                            color: AppColors.DarkPink.withOpacity(0.1),
                                            child: const Icon(Icons.pets, size: 26, color: AppColors.DarkPink),
                                          );
                                        },
                                      )
                                    : Container(
                                        width: 55,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          color: AppColors.DarkPink.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: const Icon(Icons.pets, size: 26, color: AppColors.DarkPink),
                                      ),
                              ),
                              const SizedBox(width: 16),

                              // --- Text Content ---
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            breedName,
                                            style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.DarkPink.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            matchType,
                                            style: GoogleFonts.jost(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.DarkPink),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Best match based on your lifestyle',
                                      style: GoogleFonts.jost(fontSize: 12, color: Colors.grey.shade600),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Quiz taken on $matchDate',
                                      style: GoogleFonts.jost(fontSize: 11, color: Colors.grey.shade400, fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
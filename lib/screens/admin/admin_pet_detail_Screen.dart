import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../resources/colors/app_colors.dart';

class AdminPetDetailScreen extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> petData;

  const AdminPetDetailScreen({super.key, required this.docId, required this.petData});

  @override
  Widget build(BuildContext context) {
    String currentStatus = petData['status'] ?? 'pending';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Pet Verification Details", style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: AppColors.AppColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.AppColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Image Display
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: petData['image'] != null && petData['image'].toString().startsWith('http')
                  ? Image.network(petData['image'], height: 250, width: double.infinity, fit: BoxFit.cover)
                  : Container(height: 250, color: Colors.grey[200], child: const Icon(Icons.pets, size: 80, color: Colors.grey)),
            ),
            const SizedBox(height: 20),

            // Detail Key-Value Pairs
            _buildDetailTile("Pet Name", petData['name']),
            _buildDetailTile("Breed / Category", petData['breed']),
            _buildDetailTile("Age", "${petData['age']} Months"),
            _buildDetailTile("City / Location", petData['city']),
            _buildDetailTile("Donor Contact", petData['donorPhone'] ?? 'Not Provided'),
            _buildDetailTile("Current Status", currentStatus.toUpperCase(), isStatus: true),

            const SizedBox(height: 40),

            // Condition: Agar status pehle se pending hai tou hi buttons dikhao
            if (currentStatus == 'pending')
              Row(
                children: [
                  // Reject Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection('pet_requests').doc(docId).update({'status': 'rejected'});
                        Get.back();
                        Get.snackbar("Rejected", "Pet request has been rejected.", backgroundColor: Colors.red, colorText: Colors.white);
                      },
                      child: Text("Reject Request", style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Approve Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection('pet_requests').doc(docId).update({'status': 'approved'});
                        Get.back();
                        Get.snackbar("Approved", "Pet is now live on the marketplace!", backgroundColor: Colors.green, colorText: Colors.white);
                      },
                      child: Text("Approve & Live", style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              )
            else
              Center(
                child: Text(
                  "This request has already been ${currentStatus}.",
                  style: GoogleFonts.montserrat(color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String label, String? value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            value ?? 'N/A',
            style: GoogleFonts.jost(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: isStatus ? (value == 'approved' ? Colors.green : (value == 'rejected' ? Colors.red : Colors.orange)) : AppColors.AppColor
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
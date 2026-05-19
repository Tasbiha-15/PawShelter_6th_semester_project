import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // kIsWeb k liye
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // User tracking k liye import add kiya
import '../../controller/profile/profile_controller.dart';
import '../../resources/colors/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final donorNameController = TextEditingController();
  final donorPhoneController = TextEditingController();
  
  String selectedType = 'Cat';
  String selectedCity = 'Faisalabad';
  
  File? _pickedFile;          // Mobile local file path k liye
  Uint8List? _webImageBytes;  // Safe side agar web par run ho raha ho
  String? _base64String;      // Yeh text string direct Firestore m save hogi

  final List<String> pakCities = ['Faisalabad', 'Lahore', 'Karachi', 'Islamabad', 'Rawalpindi', 'Multan'];

  // Version-safe Pure File Picker Logic (No ImagePicker conflicts)
  Future<void> _selectImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      if (kIsWeb) {
        setState(() {
          _webImageBytes = result.files.first.bytes;
          _base64String = base64Encode(_webImageBytes!);
        });
      } else {
        final filePath = result.files.first.path;
        if (filePath != null) {
          final File file = File(filePath);
          final List<int> imageBytes = await file.readAsBytes();
          setState(() {
            _pickedFile = file;
            _base64String = base64Encode(imageBytes);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("List Pet for Donation", style: GoogleFonts.jost(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.DarkPink,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Donor Verification Details 🐾", style: GoogleFonts.jost(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.DarkPink)),
                const SizedBox(height: 5),
                Text("Upload your real pet picture and enter registration details.", style: GoogleFonts.jost(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 25),

                // --- REAL IMAGE UPLOADER CONTAINER ---
                Center(
                  child: GestureDetector(
                    onTap: _selectImageFromGallery,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.DarkPink.withOpacity(0.3), width: 2),
                      ),
                      child: _base64String != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: kIsWeb 
                                  ? Image.memory(_webImageBytes!, fit: BoxFit.cover)
                                  : Image.file(_pickedFile!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.cloud_upload_outlined, size: 40, color: AppColors.DarkPink),
                                const SizedBox(height: 8),
                                Text("Open Gallery", style: GoogleFonts.jost(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // --- SECTION 1: DONOR DETAILS ---
                Text("Donor Name", style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: donorNameController,
                  decoration: _buildInputDecoration(Icons.person, hint: "Enter your full name"),
                  validator: (v) => v!.isEmpty ? "Please enter donor name" : null,
                ),
                const SizedBox(height: 15),

                Text("Donor Contact Number", style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: donorPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration(Icons.phone, hint: "e.g., 03001234567"),
                  validator: (v) => v!.isEmpty ? "Please enter contact number" : null,
                ),
                const SizedBox(height: 25),
                
                const Divider(),
                const SizedBox(height: 15),

                // --- SECTION 2: PET DETAILS ---
                Text("Pet Category", style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: _buildInputDecoration(Icons.category),
                  items: ['Cat', 'Dog'].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (val) => setState(() => selectedType = val!),
                ),
                const SizedBox(height: 15),

                Text("Pet Name", style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: nameController,
                  decoration: _buildInputDecoration(Icons.badge, hint: "e.g., Bella, Max"),
                  validator: (v) => v!.isEmpty ? "Please enter pet name" : null,
                ),
                const SizedBox(height: 15),

                Text("Breed / Group", style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: breedController,
                  decoration: _buildInputDecoration(Icons.pets, hint: "e.g., Siamese, Russian Blue"),
                  validator: (v) => v!.isEmpty ? "Please enter breed" : null,
                ),
                const SizedBox(height: 15),

                Text("Age", style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: ageController,
                  decoration: _buildInputDecoration(Icons.hourglass_bottom, hint: "e.g., 8 Months"),
                  validator: (v) => v!.isEmpty ? "Please specify age" : null,
                ),
                const SizedBox(height: 15),

                Text("Select City Location", style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedCity,
                  decoration: _buildInputDecoration(Icons.location_city),
                  items: pakCities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                  onChanged: (val) => setState(() => selectedCity = val!),
                ),
                const SizedBox(height: 35),

                // Submit Button
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_base64String == null) {
                        Get.snackbar("Image Required", "Please select a real image from gallery.",
                            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
                        return;
                      }

                      // Show loading loader
                      Get.dialog(const Center(child: CircularProgressIndicator(color: AppColors.DarkPink)), barrierDismissible: false);

                      // Current logged-in user ki unique identification tracking k liye
                      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "anonymous";

                      Map<String, dynamic> petRequest = {
                        "donorId": currentUserId, // 1. Added donorId tracking for "My Listings" tracker
                        "name": nameController.text.trim(),
                        "breed": breedController.text.trim(),
                        "age": ageController.text.trim(),
                        "city": selectedCity,
                        "image": _base64String,
                        "isCat": selectedType == 'Cat',
                        "status": "pending", // 2. Default status tracking is pending
                        "donorName": donorNameController.text.trim(),
                        "donorPhone": donorPhoneController.text.trim(),
                        "timestamp": FieldValue.serverTimestamp(),
                      };

                      try {
                        // Single collection point model handle krein gy taake code redundancy na ho
                        await FirebaseFirestore.instance.collection('pet_requests').add(petRequest);
                        
                        try { (controller as dynamic).myListedPets.add(petRequest); } catch(e) {}

                        Get.back(); // Close loading dialog
                        Get.back(); // Go back to profile screen
                        
                        Get.snackbar(
                          "Request Sent", 
                          "Pet submitted! It will appear after Admin approval.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      } catch (e) {
                        Get.back(); // Close loading
                        Get.snackbar("Error", "Something went wrong: $e", backgroundColor: Colors.red, colorText: Colors.white);
                      }
                    }
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(color: AppColors.DarkPink, borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text("Submit to Adoption Pool", style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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

  InputDecoration _buildInputDecoration(IconData icon, {String? hint}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.DarkPink, size: 20),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: AppColors.DarkPink)),
    );
  }
}
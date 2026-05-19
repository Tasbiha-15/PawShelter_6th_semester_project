import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../resources/colors/app_colors.dart';

class CheckoutScreen extends StatelessWidget {
  final String requestId;
  final dynamic controller;
  final Map<String, dynamic> itemData;

  CheckoutScreen({
    super.key, 
    required this.requestId, 
    required this.controller,
    required this.itemData,
  });

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Price Logic
    double petPrice = 0.0;
    if (itemData.containsKey('price') && itemData['price'] != null) {
      petPrice = double.tryParse(itemData['price'].toString()) ?? 0.0;
    }
    double deliveryFee = 250.0; 
    double totalBill = petPrice + deliveryFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.DarkPink, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Review & Confirm",
          style: GoogleFonts.jost(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏷️ Section: Order Summary
            Text(
              "Order Summary",
              style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Item", style: GoogleFonts.jost(fontSize: 14, color: Colors.black54)),
                      Text(
                        "${itemData['petName'] ?? itemData['name'] ?? 'Pet'}", 
                        style: GoogleFonts.jost(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(height: 1, thickness: 0.5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Adoption Fee", style: GoogleFonts.jost(fontSize: 14, color: Colors.black54)),
                      Text(
                        petPrice == 0 ? "Sponsored (Free)" : "Rs. ${petPrice.toStringAsFixed(0)}", 
                        style: GoogleFonts.jost(
                          fontSize: 14, 
                          fontWeight: FontWeight.w600, 
                          color: petPrice == 0 ? Colors.green.shade700 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Standard Delivery", style: GoogleFonts.jost(fontSize: 14, color: Colors.black54)),
                      Text("Rs. ${deliveryFee.toStringAsFixed(0)}", style: GoogleFonts.jost(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(height: 1, thickness: 1, color: AppColors.LightPink),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Payable", style: GoogleFonts.jost(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text("Rs. ${totalBill.toStringAsFixed(0)}", style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.DarkPink)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 📬 Section: Delivery Information
            Text(
              "Delivery Information",
              style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // Full Name Field
Text("Receiver's Name", style: GoogleFonts.jost(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54)),
const SizedBox(height: 6),
Container(
  padding: const EdgeInsets.symmetric(horizontal: 14),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey.shade300),
  ),
  child: TextField(
    controller: nameController,
    keyboardType: TextInputType.name,
    style: GoogleFonts.jost(fontSize: 14),
    decoration: InputDecoration(
      hintText: "e.g., Tasbiha Khan",
      hintStyle: GoogleFonts.jost(color: Colors.grey.shade400, fontSize: 14),
      icon: Icon(Icons.person_outline_rounded, color: Colors.grey.shade500, size: 20),
      border: InputBorder.none,
    ),
  ),
),
const SizedBox(height: 16),

            // Phone Field
            Text("Contact Number", style: GoogleFonts.jost(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.jost(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "e.g., +92 300 1234567",
                  hintStyle: GoogleFonts.jost(color: Colors.grey.shade400, fontSize: 14),
                  icon: Icon(Icons.phone_outlined, color: Colors.grey.shade500, size: 20),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Address Field
            Text("Shipping Address", style: GoogleFonts.jost(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: addressController,
                maxLines: 3,
                style: GoogleFonts.jost(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Complete house address, street number, and city",
                  hintStyle: GoogleFonts.jost(color: Colors.grey.shade400, fontSize: 14),
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 35.0), // Icon align karne ke liye
                    child: Icon(Icons.location_on_outlined, color: Colors.grey.shade500, size: 20),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 💳 Payment Method Status Tile
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.radio_button_checked_rounded, color: AppColors.DarkPink, size: 20),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Payment Method", style: GoogleFonts.jost(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text("Cash on Delivery (COD)", style: GoogleFonts.jost(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 🚀 Professional Action Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ButtonColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                onPressed: () async {
                  if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty || addressController.text.trim().isEmpty) {
                    Get.snackbar(
                      "Incomplete Fields", 
                      "Please fill in all required fields.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade50,
                      colorText: Colors.red.shade800,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 8,
                    );
                    return;
                  }
                  
                  await controller.sendContactDetails(
                    requestId: requestId,
                    phone: phoneController.text.trim(),
                    address: addressController.text.trim(),
                    totalAmount: totalBill,
                  );
                  
                  Get.back();
                  Get.snackbar(
                    "Order Placed", 
                    "Your request confirmation has been successfully processed.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.shade50,
                    colorText: Colors.green.shade800,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 8,
                  );
                },
                child: Text(
                  "Place Order — Rs. ${totalBill.toStringAsFixed(0)}",
                  style: GoogleFonts.jost(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
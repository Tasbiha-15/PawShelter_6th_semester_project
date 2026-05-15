import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../resources/colors/app_colors.dart';

class VerticalPetCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String info;
  final String shelterName;
  final bool isCat;
  final VoidCallback onTap;

  const VerticalPetCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.info,
    required this.shelterName,
    required this.isCat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // --- Dynamic Color Logic ---
    Color getStatusColor() {
      if (shelterName.contains("ACCEPTED")) return Colors.green;
      if (shelterName.contains("REJECTED")) return Colors.red;
      if (shelterName.contains("PENDING")) return Colors.orange;
      return AppColors.DarkPink; // Default for Favorites/Saved Pets
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // LEFT: Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[200],
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, color: Colors.grey),
                  ),
                ),
              ),

              // RIGHT: Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge (Cat/Dog)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isCat ? AppColors.LightPink : Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          isCat ? "Cat" : "Dog",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isCat ? AppColors.DarkPink : Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Name
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.jost(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Breed / Info
                      Text(
                        info,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.jost(fontSize: 12, color: Colors.grey),
                      ),

                      const Spacer(),

                      // Shelter Info / Status
                      Row(
                        children: [
                          Icon(
                            shelterName.contains("STATUS") ? Icons.info_outline : Icons.location_on, 
                            size: 12, 
                            color: getStatusColor()
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              shelterName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.jost(
                                  fontSize: 12,
                                  color: getStatusColor(), // Ab ye dynamic color use karega
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
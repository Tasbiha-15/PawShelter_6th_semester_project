import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Hamari helper file ka import
import '../../../pet_image_helper.dart';

class HorizontalPetCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final VoidCallback onTap;

  const HorizontalPetCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 10),
        color: Colors.transparent,
        child: Column(
          children: [
            // Circular Image (Yahan humne apna helper widget use kar liya)
            // Card ke image section ke andar bas yeh call kar do:
            ClipOval(
              child: SizedBox(
                width: 70, // Jo bhi tumhaari UI ka size hai circular image ka
                height: 70,
                child: buildPetImage(imageUrl,
                    size: 70), // Universal custom helper function call kiya
              ),
            ),
            const SizedBox(height: 5),
            // Name Text
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  GoogleFonts.jost(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

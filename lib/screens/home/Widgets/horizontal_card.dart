import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            // Circular Image
            ClipOval(
              child: Container(
                height: 80,
                width: 80,
                color: Colors.grey[200],
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.pets, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Name Text
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.jost(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }
}
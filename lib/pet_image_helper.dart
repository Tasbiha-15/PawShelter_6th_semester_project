import 'dart:convert';
import 'package:flutter/material.dart'; // Yeh import laazmi add karna Colors aur Icons ke errors khatam karne ke liye

Widget buildPetImage(String imageString, {double size = 70}) {
  if (imageString.isEmpty) {
    return Container(
      height: size,
      width: size, 
      color: Colors.grey[200], 
      child: const Icon(Icons.pets, color: Colors.grey),
    );
  }

  if (!imageString.startsWith('http')) {
    try {
      return Image.memory(
        base64Decode(imageString),
        height: size,
        width: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: size, width: size, color: Colors.grey[200], child: const Icon(Icons.broken_image),
        ),
      );
    } catch (e) {
      return Container(height: size, width: size, color: Colors.grey[200], child: const Icon(Icons.error));
    }
  } else {
    return Image.network(
      imageString,
      height: size,
      width: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: size, width: size, color: Colors.grey[200], child: const Icon(Icons.pets),
      ),
    );
  }
}
class DogModel {
  String? id;
  String? url;
  String? name;
  String? lifeSpan;
  String? breedGroup;
  String? temperament;
  String? origin;
  Weight? weight;
  String? referenceImageId; // <--- 1. ADD THIS FIELD

  DogModel({
    this.id,
    this.url,
    this.name,
    this.lifeSpan,
    this.breedGroup,
    this.temperament,
    this.origin,
    this.weight,
    this.referenceImageId,
  });

  DogModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    url = json['url'];
    referenceImageId = json['reference_image_id']; // <--- 2. PARSE IT

    // Logic to extract breed details (handles both API structures)
    if (json['breeds'] != null && (json['breeds'] as List).isNotEmpty) {
      final breed = json['breeds'][0];
      name = breed['name'];
      lifeSpan = breed['life_span'];
      breedGroup = breed['breed_group'];
      temperament = breed['temperament'];
      origin = breed['origin'];
      weight = breed['weight'] != null ? Weight.fromJson(breed['weight']) : null;

      // Sometimes reference ID is inside the breed object
      if (referenceImageId == null) {
        referenceImageId = breed['reference_image_id'];
      }
    } else {
      // Fallback if data is at root
      name = json['name'];
      lifeSpan = json['life_span'];
      breedGroup = json['breed_group'];
      temperament = json['temperament'];
      origin = json['origin'];
      weight = json['weight'] != null ? Weight.fromJson(json['weight']) : null;
    }
  }

  // --- 3. SMART GETTER FOR IMAGE ---
  // This checks both: direct URL OR constructs it from the ID
  String get imageUrl {
    if (url != null && url!.isNotEmpty) {
      return url!;
    }
    if (referenceImageId != null && referenceImageId!.isNotEmpty) {
      return "https://cdn2.thedogapi.com/images/$referenceImageId.jpg";
    }
    return ""; // Return empty if neither exists (UI will show placeholder)
  }
}

// --- Weight Class (Same as before) ---
class Weight {
  String? imperial;
  String? metric;

  Weight({this.imperial, this.metric});

  Weight.fromJson(Map<String, dynamic> json) {
    imperial = json['imperial'];
    metric = json['metric'];
  }
}
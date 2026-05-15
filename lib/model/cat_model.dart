class CatModel {
  String? id;
  String? url;
  List<Breed>? breeds; // This is the list of breeds

  CatModel({this.id, this.url, this.breeds});

  CatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    if (json['breeds'] != null) {
      breeds = <Breed>[];
      json['breeds'].forEach((v) {
        breeds!.add(Breed.fromJson(v));
      });
    }
  }
}

class Breed {
  String? id;
  String? name;
  String? temperament;
  String? origin;
  String? description;
  String? lifeSpan;
  // --- NEW: Add Weight ---
  Weight? weight;

  Breed({
    this.id,
    this.name,
    this.temperament,
    this.origin,
    this.description,
    this.lifeSpan,
    this.weight,
  });

  Breed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    temperament = json['temperament'];
    origin = json['origin'];
    description = json['description'];
    lifeSpan = json['life_span'];
    // --- NEW: Map Weight ---
    weight = json['weight'] != null ? Weight.fromJson(json['weight']) : null;
  }
}

// --- NEW CLASS: Paste this at the bottom if not already there ---
class Weight {
  String? imperial;
  String? metric;

  Weight({this.imperial, this.metric});

  Weight.fromJson(Map<String, dynamic> json) {
    imperial = json['imperial'];
    metric = json['metric'];
  }
}
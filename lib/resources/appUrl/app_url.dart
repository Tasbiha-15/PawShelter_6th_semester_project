class AppUrl {
  // --- API Keys ---
  static const String catApiKey = "live_gn0kXmJEec05i9yPPj1inrB8SUhfALpXqryieVukn0pJrkN9eJUfuvHfY7VufsFv";
  static const String dogApiKey = "live_PBMo0a0Tgd6Kj0AZ6iNW1CgMTPQFQR4MRXP6UcfOAemPGHRND5HUAoJ0ldiqTX0c";

  // --- Base URLs ---
  static const String catBase = "https://api.thecatapi.com/v1";
  static const String dogBase = "https://api.thedogapi.com/v1";

  // --- For Cats ---
  static String catListUrl = '$catBase/images/search?limit=10&has_breeds=1';

  // --- For Dogs ---
static String dogListUrl = '$dogBase/images/search?limit=10&has_breeds=1';
  // --- Search URLs ---
  static String searchCat(String query) => '$catBase/breeds/search?q=$query';
  static String searchDog(String query) => '$dogBase/breeds/search?q=$query';

  // --- Get Images by Breed ID (Step 2 of search) ---
  static String catImagesByBreedId(String breedId) => '$catBase/images/search?limit=10&breed_ids=$breedId&has_breeds=1';
  static String dogImagesByBreedId(String breedId) => '$dogBase/images/search?limit=10&breed_ids=$breedId&has_breeds=1';
}
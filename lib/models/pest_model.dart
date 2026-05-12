class Pest {
  final String name;
  final String scientificName;
  final String description;
  final String imagePath;
  final List<String> gallery;
  final List<String> sources;

  Pest({
    required this.name,
    required this.scientificName,
    required this.description,
    required this.imagePath,
    required this.gallery,
    required this.sources,
  });
}
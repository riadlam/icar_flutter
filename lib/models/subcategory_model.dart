
class Subcategory {
  final String id;
  final String name;
  final String imagePath;
  final String categoryId;

  const Subcategory({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.categoryId,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'categoryId': categoryId,
    };
  }
}

import 'dart:convert';

class Category {
  final String categoryName;
  final String imageUrl;

  Category({
    required this.categoryName,
    required this.imageUrl,
  });

 factory Category.fromMap(Map<String, dynamic> map) {
  return Category(
    categoryName: map['categoryName'] ?? 'Unnamed Category',
    imageUrl: map['imageUrl'] ?? '',
  );
}

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'imageUrl': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}

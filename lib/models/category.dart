// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Category {
  final String categoryName;
  final String imageUrl;

  Category({required this.categoryName, required this.imageUrl});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryName': categoryName,
      'imageUrl': imageUrl,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryName: map['categoryName'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source) as Map<String, dynamic>);
}

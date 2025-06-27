// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  final String id;
  final String productName;
  final int productPrice;
  final int quantity;
  final String description;
  final String category;
  final List<String> images;
  final double averageRating;
  final int totalRatings;

  Product({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.description,
    required this.category,
    required this.images,
    required this.averageRating,
    required this.totalRatings,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'description': description,
      'category': category,
      'images': images,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    List<String> imageList = [];
    if (map['images'] != null && map['images']['L'] != null) {
      imageList =
          (map['images']['L'] as List)
              .map((item) => item['S'] as String)
              .toList();
    }

    return Product(
      id: map['id']['S'] as String,
      productName: map['productName']['S'] as String,
      productPrice: int.parse(map['productPrice']['N']),
      quantity: int.parse(map['quantity']['N']),
      description: map['description']['S'] as String,
      category: map['category']['S'] as String,
      images: imageList,
      averageRating: double.parse(map['averageRating']['N']),
      totalRatings: int.parse(map['totalRatings']['N']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}

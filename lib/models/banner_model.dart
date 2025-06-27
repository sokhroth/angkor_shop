// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BannerModel {
  final String imageUrl;
  final String productId;
  final String productName;

  BannerModel({required this.imageUrl, required this.productId, required this.productName });

 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageUrl': imageUrl,
      'productId': productId,
      'productName': productName,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      imageUrl: map['imageUrl'] as String,
      productId: map['productId'] as String,
      productName: map['productName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerModel.fromJson(String source) => BannerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

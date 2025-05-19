// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QuickAdsModel {
  final String imageUrl;
  final String productId;
  final String productName;

  QuickAdsModel({required this.imageUrl, required this.productId, required this.productName });

 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageUrl': imageUrl,
      'productId': productId,
      'productName': productName,
    };
  }

  factory QuickAdsModel.fromMap(Map<String, dynamic> map) {
    return QuickAdsModel(
      imageUrl: map['imageUrl'] as String,
      productId: map['productId'] as String,
      productName: map['productName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuickAdsModel.fromJson(String source) => QuickAdsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

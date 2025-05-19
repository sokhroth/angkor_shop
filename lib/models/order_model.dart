// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrderModel {
  final String id;
  final String userId;
  final String productId;
  final String productName;
  final int productPrice;
  final int quantity;
  final String email;
  final bool orderPlaced;
  final bool inProgress;
  final bool shipped;
  final  bool delivered;

  OrderModel({required this.id, required this.userId, required this.productId, required this.productName, required this.productPrice, required this.quantity, required this.email, required this.orderPlaced, required this.inProgress, required this.shipped, required this.delivered});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'email': email,
      'orderPlaced': orderPlaced,
      'inProgress': inProgress,
      'shipped': shipped,
      'delivered': delivered,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as int,
      quantity: map['quantity'] as int,
      email: map['email'] as String,
      orderPlaced: map['orderPlaced'] as bool,
      inProgress: map['inProgress'] as bool,
      shipped: map['shipped'] as bool,
      delivered: map['delivered'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

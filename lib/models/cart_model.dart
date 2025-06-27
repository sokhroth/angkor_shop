import 'dart:convert';
import 'package:angkor_shop/models/product_model.dart';

class CartItem {
  final Product product; // Represents the product in the cart
  int quantity; // Represents the quantity of the product in the cart

  // Constructor to initialize CartItem with a Product and an optional quantity
  CartItem({
    required this.product,
    this.quantity = 1, // Default quantity is 1 if not specified
  });

  // Convert CartItem to a map for serialization (e.g., storing in SharedPreferences or sending to an API)
  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(), // Convert the Product to a map
      'quantity': quantity, // Include quantity
    };
  }

  // Convert a map to a CartItem (for deserialization)
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(
        map['product'] as Map<String, dynamic>,
      ), // Create Product from the map
      quantity: map['quantity'] as int, // Assign the quantity
    );
  }

  // Convert CartItem to a JSON string (for storing in SharedPreferences, or API communication)
  String toJson() => json.encode(toMap());

  // Convert a JSON string back into a CartItem (for deserialization)
  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));
}

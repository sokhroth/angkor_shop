import 'dart:convert';

import 'package:angkor_shop/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderController {
  Future<List<OrderModel>> loadOrders() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userId = preferences.getString("userId");

      if (userId == null) {
        throw Exception('User ID not found in local storage');
      }

      final response = await http.get(
        Uri.parse(
          'https://4o37rvzbu9.execute-api.ap-southeast-1.amazonaws.com/get-user-orders?userId=$userId',
        ),
        headers: {"Content-Type": 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((order) => OrderModel.fromMap(order)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Failed to load orders");
      }
    } catch (e) {
      throw Exception('Error loading orders: $e');
    }
  }

   Future<void> placeOrder({
    required String productId,
    required int quantity,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userId = preferences.getString("userId");

      if (userId == null) {
        throw Exception('User ID not found in local storage');
      }

      final response = await http.post(
        Uri.parse('https://4o37rvzbu9.execute-api.ap-southeast-1.amazonaws.com/place-order'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id': productId,
          'userId': userId,
          'quantity': quantity,
          'email': email,
          'phoneNumber': phoneNumber,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Order placed successfully. Order ID: ${data['orderId']}");
      } else {
        final error = jsonDecode(response.body);
        throw Exception('Failed to place order: ${error['error']}');
      }
    } catch (e) {
      print("Error placing order: $e");
      rethrow;
    }
  }
}

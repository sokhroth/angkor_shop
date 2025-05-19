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
}

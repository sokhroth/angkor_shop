import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:angkor_shop/views/mainScreens/widgets/paypal_web_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaypalController {
  static const String backendBaseUrl =
      "https://sesmpv1a96.execute-api.us-east-1.amazonaws.com/create-payment";
  static const String verifyPaymentUrl =
      "https://sesmpv1a96.execute-api.us-east-1.amazonaws.com/verify-payment";
  static const String placeOrderUrl =
      "https://4o37rvzbu9.execute-api.ap-southeast-1.amazonaws.com/place-order";

  static Future<void> initiatePaypalPayment({
    required double amount,
    required List<Map<String, dynamic>> items,
    required String email,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(backendBaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to create PayPal order");
      }

      final data = jsonDecode(response.body);
      final String? paymentUrl = data['paymentUrl'];

      if (paymentUrl != null && paymentUrl.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => PaypalWebView(
                  paymentUrl: paymentUrl,
                  onPaymentSuccess: (token) {
                    if (token.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('❌ Invalid PayPal token')),
                      );
                      return;
                    }

                    verifyPayment(
                      token: token,
                      items: items,
                      email: email,
                      context: context,
                    );
                  },
                ),
          ),
        );
      } else {
        throw Exception("Invalid payment URL received");
      }
    } catch (e) {
      print('❌ Error during PayPal payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.toString()}')),
      );
    }
  }

  static Future<void> verifyPayment({
    required String token,
    required List<Map<String, dynamic>> items,
    required String email,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final response = await http.post(
        Uri.parse(verifyPaymentUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('✅ Verification response: $data');

        // Check if 'items' has valid data
        if (items.isEmpty) {
          print("❌ Items list is empty!");
          return;
        }

        // Loop through the items and check their values
        for (var item in items) {
          print('Processing item: $item');
          if (item['id'] == null || item['quantity'] == null) {
            print("❌ Invalid item data: $item");
            continue; // Skip the invalid item
          }

          await placeOrder(
            id: item['id'],
            userId: userId!,
            quantity: item['quantity'],
            email: email,
            context: context,
          );
        }

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => PaymentSuccessPage()),
          );
        }
      } else {
        print('❌ Verification failed: ${response.body}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Payment verification failed')),
          );
        }
      }
    } catch (e) {
      print('❌ Exception during verification: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Verification error: ${e.toString()}')),
        );
      }
    }
  }

  static Future<void> placeOrder({
    required String id,
    required int quantity,
    required String email,
    required String userId,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(placeOrderUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": id,
          "quantity": quantity,
          "email": email,
          "userId": userId,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print('✅ Order placed: ${data['orderId']}');
      } else {
        print('❌ Order failed: ${data['error']}');
      }
    } catch (e) {
      print('❌ Exception placing order: $e');
    }
  }
}

class PaymentSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Success")),
      body: Center(child: Text('✅  payment success')),
    );
  }
}

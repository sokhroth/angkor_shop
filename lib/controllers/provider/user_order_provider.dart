import 'package:angkor_shop/controllers/order_controller.dart';
import 'package:angkor_shop/models/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userOrderProvider =
    StateNotifierProvider<UserOrderNotifier, List<OrderModel>>((ref) {
      return UserOrderNotifier()..loadOrders();
    });

class UserOrderNotifier extends StateNotifier<List<OrderModel>> {
  UserOrderNotifier() : super([]);

  Future<void> loadOrders() async {
    try {
      final orders = await OrderController().loadOrders();
      state = orders;
    } catch (e) {
      print('Error loading orders: $e');
    }
  }

  void setOrders(List<OrderModel> orders) {
    state = orders;
  }
}

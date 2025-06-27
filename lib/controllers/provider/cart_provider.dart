import 'package:angkor_shop/models/cart_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:angkor_shop/models/product_model.dart';

final paymentLoadingProvider = StateProvider<bool>((ref) => false);
final selectedPaymentMethodProvider = StateProvider<String>((ref) => 'PAYPAL');

// StateNotifier to manage cart state
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      // Product already in cart → increase quantity
      final updatedItem = state[index];
      updatedItem.quantity += 1;
      state = [...state]; // Trigger update
    } else {
      // Add new item
      state = [...state, CartItem(product: product)];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void changeQuantity(String productId, int quantity) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index != -1 && quantity > 0) {
      state[index].quantity = quantity;
      state = [...state]; // Trigger update
    }
  }

  void clearCart() {
    state = [];
  }

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => state.fold(
      0,
      (sum, item) =>
          sum + item.quantity * item.product.productPrice.toDouble());
}

// Provider
final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

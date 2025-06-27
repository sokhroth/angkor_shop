import 'package:angkor_shop/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/product_controller.dart'; // adjust path if needed

final productByCategoryProvider =
    StateNotifierProvider.family<ProductNotifier, List<Product>, String>((
      ref,
      category,
    ) {
      return ProductNotifier()..loadProductsByCategory(category);
    });

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  // Load products by category
  Future<void> loadProductsByCategory(String category) async {
    try {
      final products = await ProductController().loadProductsByCategory(
        category,
      );
      state = products;
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  void setProducts(List<Product> products) {
    state = products;
  }
}

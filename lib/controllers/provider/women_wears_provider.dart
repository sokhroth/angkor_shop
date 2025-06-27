import 'package:angkor_shop/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/product_controller.dart'; // adjust path if needed

final womentWearsProvider =
    StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
      return ProductNotifier()..loadWomensWears(); // Auto-fetch on use
    });

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  Future<void> loadWomensWears() async {
    try {
      final products = await ProductController().loadWomensWears();
      state = products;
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  void setProducts(List<Product> products) {
    state = products;
  }
}

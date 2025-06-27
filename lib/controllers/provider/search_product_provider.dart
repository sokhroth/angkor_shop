import 'package:angkor_shop/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/product_controller.dart';

final searchProductProvider =
    StateNotifierProvider.family<ProductNotifier, List<Product>, String>((
      ref,
      query,
    ) {
      return ProductNotifier()..loadSearchedProducts(query);
    });

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  Future<void> loadSearchedProducts(String query) async {
    try {
      final products = await ProductController().searchProducts(query);
      state = products;
    } catch (e) {
      print('Error loading searched products: $e');
    }
  }

  void setSearchProducts(List<Product> products) {
    state = products;
  }
}

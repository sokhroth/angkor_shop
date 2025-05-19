// recommended_product_provider.dart
import 'package:angkor_shop/controllers/provider/currentProductProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:angkor_shop/models/product_model.dart';
import 'package:angkor_shop/controllers/provider/product_provider.dart';

final recommendedProductProvider = Provider<List<Product>>((ref) {
  final allProducts = ref.watch(productProvider);
  final currentProduct = ref.watch(currentProductProvider);

  if (currentProduct == null) return [];

  return allProducts
      .where((p) => p.category == currentProduct.category && p.id != currentProduct.id)
      .toList();
});

// category_provider.dart
import 'package:angkor_shop/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/category_controller.dart'; // adjust if path is different

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
      return CategoryNotifier()
        ..loadCategories(); // Auto-fetch when provider is first used
    });

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]);

  Future<void> loadCategories() async {
    try {
      final categories = await CategoryController().loadCategories();
      state = categories;
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  void setCategories(List<Category> categories) {
    state = categories;
  }
}

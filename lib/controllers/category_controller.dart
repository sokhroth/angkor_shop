import 'dart:convert';
import 'package:angkor_shop/controllers/services/global_variables.dart';
import 'package:angkor_shop/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  // Load the uploaded categories
  Future<List<Category>> loadCategories() async {
    try {
      final response = await http.get(
        Uri.parse(categoriesAPIURL),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Correct way: use fromMap
        List<Category> categories = data
            .map((item) => Category.fromMap(item as Map<String, dynamic>))
            .toList();

        return categories;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load categories. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error loading categories: $e');
    }
  }
}

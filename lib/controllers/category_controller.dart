import 'dart:convert';

import 'package:angkor_shop/controllers/services/global_variables.dart';
import 'package:angkor_shop/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  //load the uploaded category

  Future<List<Category>> loadCategories() async {
    try {
      final response = await http.get(
        Uri.parse(categoriesAPIURL),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Category> categories =
            data.map((category) => Category.fromMap(category)).toList();
        return categories;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print(e);
      throw Exception('Error loading Categories: $e');
    }
  }

}

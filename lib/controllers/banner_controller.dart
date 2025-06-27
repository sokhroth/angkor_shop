import 'dart:convert';

import 'package:angkor_shop/controllers/services/global_variables.dart';
import 'package:angkor_shop/models/banner_model.dart';
import 'package:http/http.dart' as http;

class BannerController {
  //fetch banners

  Future<List<BannerModel>> loadBanners() async {
    try {
      final response = await http.get(
        Uri.parse(bannersAPIUrl),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );
      print('Banners ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners =
            data.map((category) => BannerModel.fromMap(category)).toList();
        return banners;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      print(e);
      throw Exception('Error loading banners: $e');
    }
  }
}

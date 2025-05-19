import 'dart:convert';

import 'package:angkor_shop/controllers/services/global_variables.dart';
import 'package:angkor_shop/models/quick_ads_model.dart';
import 'package:http/http.dart' as http;

class QuickAdsController {
  //fetch banners

  Future<List<QuickAdsModel>> loadQuickAds() async {
    try {
      final response = await http.get(
        Uri.parse(quickAdsAPIURL),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      print('quick adds ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<QuickAdsModel> quickads =
            data
                .map((quickAdsModel) => QuickAdsModel.fromMap(quickAdsModel))
                .toList();
        return quickads;
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

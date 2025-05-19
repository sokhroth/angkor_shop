// banner_provider.dart
import 'package:angkor_shop/controllers/quick_ads_controller.dart';
import 'package:angkor_shop/models/quick_ads_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quickAdsProvider =
    StateNotifierProvider<QuickAdsNotifier, List<QuickAdsModel>>((ref) {
      return QuickAdsNotifier()
        ..loadQuickAds(); // Auto-fetch when provider is first read
    });

class QuickAdsNotifier extends StateNotifier<List<QuickAdsModel>> {
  QuickAdsNotifier() : super([]);

  Future<void> loadQuickAds() async {
    try {
      final quickAds = await QuickAdsController().loadQuickAds();
      state = quickAds;
    } catch (e) {
      print('Error loading quick ads: $e');
    }
  }

  void setQuickAds(List<QuickAdsModel> quickAds) {
    state = quickAds;
  }
}

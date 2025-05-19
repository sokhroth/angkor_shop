import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/banner_controller.dart';
import '../../models/banner_model.dart';

final bannerProvider = StateNotifierProvider<BannerNotifier, List<BannerModel>>(
  (ref) {
    return BannerNotifier()..loadBanners();
  },
);

class BannerNotifier extends StateNotifier<List<BannerModel>> {
  BannerNotifier() : super([]);

  Future<void> loadBanners() async {
    try {
      final banners = await BannerController().loadBanners();
      state = banners;
    } catch (e) {
      print('Error loading banners: $e');
    }
  }

  void setBanners(List<BannerModel> banners) {
    state = banners;
  }
}

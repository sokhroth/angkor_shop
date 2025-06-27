import 'package:angkor_shop/views/mainScreens/recent_product_widget.dart';
import 'package:angkor_shop/views/mainScreens/widgets/category_widget.dart';
import 'package:angkor_shop/views/mainScreens/widgets/promo_banner_widget.dart';
import 'package:angkor_shop/views/mainScreens/widgets/popular_products.dart';
import 'package:angkor_shop/views/mainScreens/widgets/quick_ads_widget.dart';
import 'package:angkor_shop/views/mainScreens/widgets/search_bar_widget.dart';
import 'package:angkor_shop/views/mainScreens/widgets/shop_for_her_widget.dart';
import 'package:angkor_shop/views/mainScreens/widgets/topBar_widget.dart';
import 'package:angkor_shop/views/mainScreens/widgets/all_electonic_product_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:angkor_shop/controllers/provider/recommended_product_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedProducts = ref.watch(recommendedProductProvider);

    return SafeArea(
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: TopBar()),
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.all(8.0), child: SearchBarWidget()),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryList(),
                  const SizedBox(height: 16),
                  PromoBannerWidget(),
                  const SizedBox(height: 24),
                  RecentProductWidget(),
                  QuickAdsWidget(),
                  const SizedBox(height: 8),

                  // ✅ Show PopularProducts *only if* there are recommended products
                  if (recommendedProducts.isNotEmpty) PopularProductsSection(),
                  const SizedBox(height: 8),
                  ElectronicDevicesSection(),
                  const SizedBox(height: 8),
                  ShopForHerSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

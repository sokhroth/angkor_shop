import 'dart:async';
import 'package:angkor_shop/views/mainScreens/inner_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:angkor_shop/controllers/provider/banner_provider.dart';
import 'package:angkor_shop/controllers/provider/product_provider.dart';
import 'package:angkor_shop/controllers/provider/image_precache_provider.dart';

import 'package:angkor_shop/models/product_model.dart';

class PromoBannerWidget extends ConsumerStatefulWidget {
  const PromoBannerWidget({super.key});

  @override
  ConsumerState<PromoBannerWidget> createState() => _PromoBannerWidgetState();
}

class _PromoBannerWidgetState extends ConsumerState<PromoBannerWidget> {
  late final PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (_pageController.hasClients) {
        final banners = ref.read(bannerProvider);
        int nextPage = _currentPage + 1;
        if (nextPage >= banners.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _precacheImages(List banners, BuildContext context) async {
    for (var banner in banners) {
      await precacheImage(NetworkImage(banner.imageUrl), context);
    }
    if (mounted) {
      ref.read(imagesPrecachedProvider.notifier).state = true;
    }
  }

  Widget _buildBannerIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: _currentPage == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                _currentPage == index ? const Color(0xFF00CFFF) : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList(double bannerHeight, double bannerWidth) {
    return SizedBox(
      height: bannerHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: bannerWidth,
              height: bannerHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannerProvider);
    final products = ref.watch(productProvider);
    final imagesPrecached = ref.watch(imagesPrecachedProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final bannerWidth = screenWidth * 0.9;
    final bannerHeight = 200.0;

    // ✅ Show shimmer only if banners are still loading
    if (banners.isEmpty) {
      return _buildShimmerList(bannerHeight, bannerWidth);
    }

    // ✅ Precache images once
    if (!imagesPrecached) {
      _precacheImages(banners, context);
      return _buildShimmerList(bannerHeight, bannerWidth);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: bannerHeight,
            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final banner = banners[index];
                return InkWell(
                  onTap: () {
                    Product? matchingProduct;
                    try {
                      matchingProduct = products.firstWhere(
                        (p) => p.id == banner.productId,
                      );
                    } catch (_) {
                      matchingProduct = null;
                    }

                    if (matchingProduct != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProductDetailScreen(
                                product: matchingProduct!,
                              ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product not found')),
                      );
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      banner.imageUrl,
                      width: bannerWidth,
                      height: bannerHeight,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: bannerWidth,
                            height: bannerHeight,
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _buildBannerIndicator(banners.length),
        ],
      ),
    );
  }
}

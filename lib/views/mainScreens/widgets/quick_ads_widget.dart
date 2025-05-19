import 'package:angkor_shop/views/mainScreens/inner_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:angkor_shop/controllers/provider/quick_ads_provider.dart';
import 'package:angkor_shop/controllers/provider/product_provider.dart';
import 'package:angkor_shop/models/product_model.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickAdsWidget extends ConsumerWidget {
  const QuickAdsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickAds = ref.watch(quickAdsProvider);
    final products = ref.watch(productProvider);

    if (quickAds.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85,
            aspectRatio: 16 / 9,
            autoPlayInterval: const Duration(seconds: 5),
          ),
          items:
              quickAds.map((ad) {
                return Builder(
                  builder: (BuildContext context) {
                    Product? matchingProduct;
                    try {
                      matchingProduct = products.firstWhere(
                        (p) => p.id == ad.productId,
                      );
                    } catch (_) {
                      matchingProduct = null;
                    }

                    return GestureDetector(
                      onTap: () {
                        if (matchingProduct != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ProductDetailScreen(
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
                      child: SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Center the image with BoxFit.contain
                              Center(
                                child: Image.network(
                                  ad.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                          ),
                                ),
                              ),
                              // Shop Now button over the image
                              Positioned(
                                bottom: 30,
                                left: 12,
                                child: InkWell(
                                  onTap: () {
                                    if (matchingProduct != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => ProductDetailScreen(
                                                product: matchingProduct!,
                                              ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Product not found'),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    child: Text(
                                      'BUY NOW',
                                      style: GoogleFonts.poppins(
                                        color: Color(0xFF00CFFF),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
        ),
      ],
    );
  }
}

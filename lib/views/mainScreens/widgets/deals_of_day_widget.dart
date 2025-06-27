import 'package:angkor_shop/controllers/provider/banner_provider.dart';
import 'package:angkor_shop/controllers/provider/product_provider.dart';
import 'package:angkor_shop/models/product_model.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DealOfTheDayWidget extends ConsumerWidget {
  const DealOfTheDayWidget({super.key});

  Widget _buildTitleBar() {
    return Text(
      'Deal of the Day',
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: const Color(0xCC000000),
      ),
    );
  }

  Widget _buildPromoImage({
    required String imageUrl,
    required double width,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          imageUrl,
          width: width,
          height: width * (200 / 350), // Aspect ratio
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                width: width,
                height: width * (200 / 350),
                color: Colors.grey.shade300,
                child: const Icon(Icons.error, color: Colors.red),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banners = ref.watch(bannerProvider);
    final products = ref.watch(productProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.9;

    return SizedBox(
      width: containerWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleBar(),
          const SizedBox(height: 19),
          if (banners.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            ...banners.map((banner) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _buildPromoImage(
                  imageUrl: banner.imageUrl,
                  width: containerWidth,
                  onTap: () {
                    Product? product;
                    try {
                      product = products.firstWhere(
                        (p) => p.id == banner.productId,
                      );
                    } catch (_) {
                      product = null;
                    }

                    if (product != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ProductDetailScreen(product: product!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product not found')),
                      );
                    }
                  },
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

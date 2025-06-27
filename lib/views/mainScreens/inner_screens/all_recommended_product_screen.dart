import 'package:angkor_shop/controllers/provider/recommended_product_provider.dart';
import 'package:angkor_shop/views/mainScreens/widgets/popular_products.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Update the provider to hold a list of products

// AllRecommendedProductScreen widget to display recommended products
class AllRecommendedProductScreen extends ConsumerWidget {
  const AllRecommendedProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the recommendedProductProvider to get the current list of recommended products
    final recommendedProducts = ref.watch(recommendedProductProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recommended for You',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            // Display recommended products if available, else show a message
            recommendedProducts.isNotEmpty
                ? Column(
                  children:
                      recommendedProducts
                          .map((product) => RecommendedItem(product: product))
                          .toList(),
                )
                : Center(child: Text('No recommended products available')),
          ],
        ),
      ),
    );
  }
}

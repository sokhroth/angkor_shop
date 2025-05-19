import 'package:angkor_shop/controllers/provider/women_wears_provider.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/product_detail_screen.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/shopforher_detail_screen.dart';
import 'package:angkor_shop/views/mainScreens/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopForHerSection extends ConsumerWidget {
  const ShopForHerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(womentWearsProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.95,
      height: screenHeight * 0.55,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          // Header
          Positioned(
            top: screenHeight * 0.02,
            left: screenWidth * 0.045,
            right: screenWidth * 0.045,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shop for Her',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ShopforherDetailScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'See All',
                    style: GoogleFonts.poppins(
                      color: const Color(0x3F000000),
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Products List
          Positioned(
            top: screenHeight * 0.07,
            left: screenWidth * 0.045,
            right: screenWidth * 0.045,
            child:
                products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                      height: screenHeight * 0.45,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: products.length,
                        separatorBuilder:
                            (context, index) =>
                                SizedBox(height: screenHeight * 0.015),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProductDetailScreen(
                                      product: product,
                                    );
                                  },
                                ),
                              );
                            },
                            child: ProductCard(
                              imageUrl:
                                  product.images.isNotEmpty
                                      ? product.images[0]
                                      : '',
                              category: product.category,
                              title: product.productName,
                              price: "\$${product.productPrice}",
                              oldPrice:
                                  "\$${(product.productPrice * 1.5).toStringAsFixed(2)}",
                              rating: product.averageRating,
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

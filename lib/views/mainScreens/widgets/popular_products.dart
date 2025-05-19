import 'package:angkor_shop/controllers/provider/recommended_product_provider.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/all_recommended_product_screen.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:angkor_shop/models/product_model.dart'; // Import product model

// Update the provider to hold a list of products

// PopularProductsSection widget to display recommended products
class PopularProductsSection extends ConsumerWidget {
  const PopularProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the recommendedProductProvider to get the current list of recommended products
    final recommendedProducts = ref.watch(recommendedProductProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended for you',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AllRecommendedProductScreen();
                    },
                  ),
                );
              },
              child: Text(
                'See All',
                style: GoogleFonts.poppins(
                  color: Color(0x3F000000),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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
    );
  }
}

// RecommendedItem widget to display each individual recommended product
class RecommendedItem extends StatelessWidget {
  final Product product;

  const RecommendedItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth * 0.25;
    final itemHeight = screenWidth > 400 ? 120 : 110;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductDetailScreen(product: product);
            },
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: itemHeight.toDouble(),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: imageWidth,
              margin: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x0C000000)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.network(
                  product.images.isNotEmpty
                      ? product.images[0]
                      : 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 8),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.category,
                              style: GoogleFonts.robotoSerif(
                                color: Color(0x3F000000),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              product.productName,

                              style: GoogleFonts.poppins(
                                color: Color(0x99000000),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        // ⭐ Rating with stars and number
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              double rating = product.averageRating;
                              if (index < rating.floor()) {
                                return Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.yellow[700],
                                );
                              } else if (index < rating) {
                                return Icon(
                                  Icons.star_half,
                                  size: 14,
                                  color: Colors.yellow[700],
                                );
                              } else {
                                return Icon(
                                  Icons.star_border,
                                  size: 14,
                                  color: Colors.yellow[700],
                                );
                              }
                            }),
                            const SizedBox(width: 4),
                            Text(
                              product.averageRating.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                color: Color(0x3F000000),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "\$${product.productPrice}",
                              style: GoogleFonts.poppins(
                                color: Color(0xFF00CFFF),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "\$${(product.productPrice * 1.5).toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                color: Color(0x3F000000),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0x0C101010),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        child: const Center(
                          child: Icon(Icons.favorite_border, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

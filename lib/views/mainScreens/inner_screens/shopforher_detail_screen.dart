import 'package:angkor_shop/controllers/provider/currentProductProvider.dart';
import 'package:angkor_shop/controllers/provider/women_wears_provider.dart';
import 'package:angkor_shop/models/product_model.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopforherDetailScreen extends ConsumerStatefulWidget {
  const ShopforherDetailScreen({super.key});

  @override
  ConsumerState<ShopforherDetailScreen> createState() =>
      _ShopforherDetailScreenState();
}

class _ShopforherDetailScreenState
    extends ConsumerState<ShopforherDetailScreen> {
  Widget _buildProductCard(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) {
    return InkWell(
      onTap: () {
        ref.read(currentProductProvider.notifier).state = product;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 165,
        height: 254,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Color(0x1E000000), blurRadius: 10),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 165,
                height: 149,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5FDFF),
                  boxShadow: [
                    BoxShadow(color: Color(0x11000000), blurRadius: 8),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 21,
                      top: 32,
                      child: Image.network(
                        product.images.isNotEmpty
                            ? product.images[0]
                            : 'https://via.placeholder.com/150',
                        width: 123,
                        height: 102,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0x0A101010),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        child: const Center(
                          child: Icon(Icons.favorite_border, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 139,
              child: Container(
                width: 32,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF00CFFF),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(3),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.shopping_cart,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 11,
              top: 158,
              child: Text(
                product.category,
                style: GoogleFonts.poppins(
                  color: const Color(0x3F000000),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              left: 11,
              top: 175,
              child: Text(
                product.productName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: const Color(0xCC000000),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              left: 11,
              top: 229,
              child: Text(
                "\$${product.productPrice}",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF00CFFF),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              left: 68,
              top: 229,
              child: Text(
                "\$${(product.productPrice * 1.5).toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  color: const Color(0x3F000000),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 204,
              child: Row(
                children: [
                  ...List.generate(5, (index) {
                    double starRating = product.averageRating;
                    if (index < starRating.floor()) {
                      return Icon(
                        Icons.star,
                        color: Colors.yellow[700],
                        size: 16,
                      );
                    } else if (index < starRating) {
                      return Icon(
                        Icons.star_half,
                        color: Colors.yellow[700],
                        size: 16,
                      );
                    } else {
                      return Icon(
                        Icons.star_border,
                        color: Colors.yellow[700],
                        size: 16,
                      );
                    }
                  }),
                  const SizedBox(width: 5),
                  Text(
                    product.averageRating.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                      color: const Color(0x3F000000),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final womenProducts = ref.watch(womentWearsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shop for Her",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child:
            womenProducts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 165 / 254,
                  children:
                      womenProducts
                          .map(
                            (product) =>
                                _buildProductCard(context, ref, product),
                          )
                          .toList(),
                ),
      ),
    );
  }
}

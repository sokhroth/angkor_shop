import 'package:angkor_shop/controllers/provider/cart_provider.dart';
import 'package:angkor_shop/controllers/provider/recommended_product_provider.dart';
import 'package:angkor_shop/models/product_model.dart';
import 'package:angkor_shop/views/mainScreens/widgets/popular_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';


class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalCount = cartItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios, size: 18),
          ),
          Text(
            'Product Details',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xCC000000),
            ),
          ),
          Stack(
            children: [
              const Icon(Icons.shopping_cart_outlined),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    totalCount > 0
                        ? Positioned(
                          key: ValueKey<int>(totalCount),
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD7605F),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$totalCount',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Hero(
      tag: product.id,
      child: Image.network(
        product.images.isNotEmpty
            ? product.images[0]
            : 'https://via.placeholder.com/150',
        width: double.infinity,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0x99000000),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${product.productPrice}',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0x99000000),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(249 people bought this)',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0x66000000),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
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
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0x0A101010),
                borderRadius: BorderRadius.circular(21),
              ),
              child: Center(
                child: Image.network(
                  'https://storage.googleapis.com/codeless-app.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fddef1e7c-7fb5-47bb-a765-54462a0f553a.png',
                  width: 20,
                  height: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreInfo() {
    return FadeInLeft(
      duration: const Duration(milliseconds: 500),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(33),
          child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F564720c02df9eb429abe623cf80087685d0ad035Frame%2042.png?alt=media&token=4b8ddf7e-a6c6-4684-bbfc-70012e2ab327',
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          'Apple Store',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0x99000000),
          ),
        ),
        subtitle: Text(
          'online 9 minutes ago',
          style: GoogleFonts.poppins(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: const Color(0x66000000),
          ),
        ),
        trailing: Container(
          width: 92,
          height: 27,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), blurRadius: 4),
            ],
          ),
          child: Center(
            child: Text(
              'Follow',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0x7F000000),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Description',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0x99000000),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0x66000000),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final isInCart = cartItems.any((item) => item.product.id == product.id);

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color(0x19000000), blurRadius: 30)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap:
                    isInCart
                        ? null
                        : () {
                          ref.read(cartProvider.notifier).addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to cart')),
                          );
                        },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        isInCart
                            ? Colors.grey.shade400
                            : const Color(0xCC00CFFF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      isInCart ? 'In Cart' : 'Add to cart',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(color: Color(0x26000000), blurRadius: 8),
                  ],
                ),
                child: const Center(child: Text('Buy Now')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedProducts = ref.watch(recommendedProductProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, ref),
              _buildProductImage(),
              _buildProductInfo(),
              const Divider(height: 1),
              _buildStoreInfo(),
              const Divider(height: 1),
              _buildDescriptionSection(),
              if (recommendedProducts.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: PopularProductsSection(),
                ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context, ref),
    );
  }
}

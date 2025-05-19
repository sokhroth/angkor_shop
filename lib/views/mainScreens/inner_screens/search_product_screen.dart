import 'package:angkor_shop/controllers/provider/currentProductProvider.dart';
import 'package:angkor_shop/controllers/provider/search_product_provider.dart';
import 'package:angkor_shop/models/product_model.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/product_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

class SearchProductScreen extends ConsumerStatefulWidget {
  const SearchProductScreen({super.key});

  @override
  ConsumerState<SearchProductScreen> createState() =>
      _SearchProductScreenState();
}

class _SearchProductScreenState extends ConsumerState<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  String currentQuery = '';

  void _onSearchChanged(String query) {
    setState(() {
      currentQuery = query.trim();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults =
        currentQuery.isNotEmpty
            ? ref.watch(searchProductProvider(currentQuery))
            : <Product>[];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Search Bar
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for a product...',
                          hintStyle: GoogleFonts.poppins(),
                          border: InputBorder.none,
                        ),
                        onSubmitted: _onSearchChanged,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.clear,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Results Section
              Expanded(
                child:
                    currentQuery.isEmpty
                        ? Center(
                          child: Text(
                            'Enter a product name to search.',
                            style: GoogleFonts.poppins(),
                          ),
                        )
                        : searchResults.isEmpty
                        ? const Center(child: Text('No results found.'))
                        : Column(
                          children: [
                            // First Row: Two products side by side
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                                  searchResults
                                      .take(2)
                                      .map(
                                        (product) => _buildProductCard(
                                          context,
                                          ref,
                                          product,
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 10),
                            // Second Row: Two products side by side
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                                  searchResults
                                      .skip(2)
                                      .take(2)
                                      .map(
                                        (product) => _buildProductCard(
                                          context,
                                          ref,
                                          product,
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildProductCard(BuildContext context, WidgetRef ref, Product product) {
  return InkWell(
    onTap: () {
      // Save the selected product to the provider
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Color(0x1E000000), blurRadius: 10)],
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
                boxShadow: [BoxShadow(color: Color(0x11000000), blurRadius: 8)],
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
                borderRadius: BorderRadius.horizontal(left: Radius.circular(3)),
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.shopping_cart,
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
          // Updated stars section with rating next to it
          Positioned(
            left: 12,
            top: 204,
            child: Row(
              children: [
                // Display stars
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
                // Display rating number next to stars
                SizedBox(width: 5), // Space between stars and rating
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

import 'package:angkor_shop/controllers/provider/cart_provider.dart';
import 'package:angkor_shop/views/mainScreens/cart_empty_screen.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/checkout_screen.dart';
import 'package:angkor_shop/views/mainScreens/widgets/popular_products.dart'; // ✅ Import this
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);
    final totalPrice = cartItems.fold(
      0.0,
      (sum, item) => sum + item.quantity * item.product.productPrice.toDouble(),
    );
    final discount = totalPrice * 0.01;
    final finalAmount = totalPrice - discount;

    if (cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: const CartEmptyScreen()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(totalItems),
              const SizedBox(height: 20),
              for (var item in cartItems)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: _buildCartItem(
                    imageUrl: item.product.images[0],
                    title: item.product.productName,
                    price:
                        '\$${(item.product.productPrice * item.quantity).toStringAsFixed(2)}',
                    quantity: item.quantity,
                    onDelete: () {
                      ref
                          .read(cartProvider.notifier)
                          .removeFromCart(item.product.id);
                    },
                    onIncrement: () {
                      ref
                          .read(cartProvider.notifier)
                          .changeQuantity(item.product.id, item.quantity + 1);
                    },
                    onDecrement: () {
                      if (item.quantity > 1) {
                        ref
                            .read(cartProvider.notifier)
                            .changeQuantity(item.product.id, item.quantity - 1);
                      }
                    },
                  ),
                ),
              const SizedBox(height: 20),
              _buildPromoCodeField(),
              const SizedBox(height: 25),
              _buildPriceDetails(totalPrice, totalItems, discount, finalAmount),
              const SizedBox(height: 15),
              _buildSavingsInfo(discount),
              const SizedBox(height: 20),
              _buildPlaceOrderButton(totalPrice, finalAmount, context),
              const SizedBox(height: 30),
              PopularProductsSection(), // ✅ Added popular products at the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int totalItems) {
    return Center(
      child: Column(
        children: [
          Text(
            'My Cart',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xCC000000),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '($totalItems item${totalItems != 1 ? 's' : ''})',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0x66000000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem({
    required String imageUrl,
    required String title,
    required String price,
    required int quantity,
    required VoidCallback onDelete,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 3)],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x0C000000)),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.network(imageUrl, width: 78, height: 78),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xCC000000),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00CFFF),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: onDelete,
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, size: 14),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(color: Color(0x26000000), blurRadius: 4),
                  ],
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onDecrement,
                      child: Icon(CupertinoIcons.minus, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '$quantity',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00CFFF),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: onIncrement,
                      child: Icon(CupertinoIcons.plus, size: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeField() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0x0F000000),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined, color: Color(0x66000000)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter promo code',
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0x66000000),
                  fontSize: 15,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const Text(
            'Apply',
            style: TextStyle(
              color: Color(0xFF00CFFF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(
    double totalPrice,
    int totalItems,
    double discount,
    double finalAmount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Details',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: const Color(0xCC000000),
          ),
        ),
        const SizedBox(height: 10),
        _buildPriceRow(
          'Price ($totalItems items)',
          '\$${totalPrice.toStringAsFixed(2)}',
        ),
        _buildPriceRow(
          'Discount',
          '-\$${discount.toStringAsFixed(2)}',
          highlight: true,
        ),
        _buildPriceRow('Delivery Fee', 'Free Delivery', highlight: true),
        _buildPriceRow('Total Amount', '\$${finalAmount.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color:
                  highlight ? const Color(0xFF00CFFF) : const Color(0xCC000000),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color:
                  highlight ? const Color(0xFF00CFFF) : const Color(0xCC000000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsInfo(double discount) {
    return Text(
      'You will save \$${discount.toStringAsFixed(2)} on this order',
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF00CFFF),
      ),
    );
  }

  Widget _buildPlaceOrderButton(
    double totalPrice,
    double finalAmount,
    context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${totalPrice.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                decoration: TextDecoration.lineThrough,
                color: const Color(0x3F000000),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${finalAmount.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xCC000000),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CheckoutScreen();
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF00CFFF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  'Checkout',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:angkor_shop/controllers/payPal_controller.dart';
import 'package:angkor_shop/controllers/provider/cart_provider.dart';
import 'package:angkor_shop/controllers/provider/user_provider.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/shipping_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final selectedMethod = ref.watch(selectedPaymentMethodProvider);
    final isLoading = ref.watch(paymentLoadingProvider);
    final totalPrice = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.product.productPrice * item.quantity),
    );

    final user = ref.watch(userProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(
            color: const Color(0xCC000000),
            fontSize: screenWidth < 600 ? 16 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: ListView(
              children: [
                const SizedBox(height: 10),
                Text(
                  'CART SUMMARY',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth < 600 ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xCC000000),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      for (var item in cartItems)
                        _buildCartItem(
                          '${item.product.productName} x${item.quantity}',
                          '\$${(item.product.productPrice * item.quantity).toStringAsFixed(2)}',
                        ),
                      const Divider(thickness: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Total:',
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '\$${totalPrice.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth < 600 ? 16 : 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DELIVERY ADDRESS',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth < 600 ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xCC000000),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => const ShippingAddressDialogContent(),
                        );
                      },
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xDDF7F7F7),
                    border: Border.all(
                      color: const Color(0xFF00CFFF),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.home, color: Color(0xFF00CFFF)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) =>
                                          const ShippingAddressDialogContent(),
                                );
                              },
                              child: Text(
                                'HOME ADDRESS',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF00CFFF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            user!.state == ''
                                ? Text(
                                  'Enter Shipping address',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                                : Text(
                                  '${user.state}, ${user.city}, ${user.locality}',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth < 600 ? 13 : 15,
                                    color: const Color(0xCC000000),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle, color: Color(0xFF00CFFF)),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'PAYMENT METHOD',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth < 600 ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xCC000000),
                  ),
                ),
                const SizedBox(height: 10),
                _buildPaymentOption(
                  imageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F106106b23a705a1be08de4b252dc5fe9195fb197image%2018.png?alt=media&token=f4e26e29-d424-4779-918e-da60b168d432',
                  method: 'PAYPAL',
                  isSelected: selectedMethod == 'PAYPAL',
                  onTap:
                      () =>
                          ref
                              .read(selectedPaymentMethodProvider.notifier)
                              .state = 'PAYPAL',
                ),
                const SizedBox(height: 10),
                _buildPaymentOption(
                  imageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F6b31a6f398bb40371cde354bd457c6908eaba935image.png?alt=media&token=111fecd7-3b34-4a5d-ae5d-bf852e1d459d',
                  method: 'ABA PAYWAY',
                  isSelected: selectedMethod == 'ABA PAYWAY',
                  onTap:
                      () =>
                          ref
                              .read(selectedPaymentMethodProvider.notifier)
                              .state = 'ABA PAYWAY',
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        user.city == ''
                            ? null
                            : () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final email = prefs.getString('userEmail');
                              final method = ref.read(
                                selectedPaymentMethodProvider,
                              );

                              if (method == 'ABA PAYWAY') {
                                // Handle ABA PAYWAY logic
                              } else if (method == 'PAYPAL') {
                                List<Map<String, dynamic>> paypalItems =
                                    cartItems.map((item) {
                                      return {
                                        'id': item.product.id,
                                        'name': item.product.productName,
                                        'quantity': item.quantity,
                                        'price': item.product.productPrice
                                            .toStringAsFixed(2),
                                      };
                                    }).toList();

                                ref
                                    .read(paymentLoadingProvider.notifier)
                                    .state = true;

                                try {
                                  await PaypalController.initiatePaypalPayment(
                                    amount: totalPrice,
                                    context: context,
                                    email: email!,
                                    items: paypalItems,
                                  );
                                } finally {
                                  ref
                                      .read(paymentLoadingProvider.notifier)
                                      .state = false;
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please select a payment method",
                                    ),
                                  ),
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00CFFF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      user.city == ''
                          ? "Enter shipping address"
                          : 'Proceed With Payment',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth < 600 ? 14 : 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF00CFFF)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartItem(String name, String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            price,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String imageUrl,
    required String method,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF00CFFF) : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(imageUrl, height: 30),
            Text(
              method,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF00CFFF)),
          ],
        ),
      ),
    );
  }
}

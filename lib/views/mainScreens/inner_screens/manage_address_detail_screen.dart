import 'package:angkor_shop/controllers/provider/user_provider.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/shipping_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageAddressScreen extends ConsumerStatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  ConsumerState<ManageAddressScreen> createState() =>
      _ManageAddressScreenState();
}

class _ManageAddressScreenState extends ConsumerState<ManageAddressScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    // Construct the full address like in CheckoutScreen
    final fullAddress =
        user!.state == ''
            ? 'Enter Shipping address'
            : '${user.state}, ${user.city}, ${user.locality}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context); // You can now go back
          },
        ),
        centerTitle: true,
        title: const Text(
          'Manage Address',
          style: TextStyle(
            color: Color(0xCC000000),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _addressCard(
            context,
            title: 'Home',
            address: fullAddress,
            isDefault: true,
            icon: Icons.home,
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add, size: 18, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  'Add New Address',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressCard(
    BuildContext context, {
    required String title,
    required String address,
    required bool isDefault,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDefault ? const Color(0xFFEEFCFF) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.lightBlueAccent, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xB2000000),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lato',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const ShippingAddressDialogContent(),
                      );
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Colors.lightBlueAccent,
                      size: 16,
                    ),
                  ),

                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            address,
            style: const TextStyle(
              color: Color(0x7F000000),
              fontSize: 15,
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isDefault,
                    onChanged: (_) {},
                    activeColor: const Color(0xFF00CFFF),
                  ),
                  const Text(
                    'Make Default',
                    style: TextStyle(
                      color: Color(0x7F000000),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Lato',
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Remove',
                  style: TextStyle(
                    color: Color(0xFF00CFFF),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

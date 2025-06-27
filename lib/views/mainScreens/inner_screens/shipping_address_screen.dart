import 'package:angkor_shop/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:angkor_shop/controllers/provider/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingAddressDialogContent extends ConsumerStatefulWidget {
  const ShippingAddressDialogContent({super.key});

  @override
  ConsumerState<ShippingAddressDialogContent> createState() =>
      _ShippingAddressDialogContentState();
}

class _ShippingAddressDialogContentState
    extends ConsumerState<ShippingAddressDialogContent> {
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _streetAddressController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ref.read(userProvider);
    if (user != null) {
      _cityController.text = user.city;
      _stateController.text = user.state;
      _streetAddressController.text = user.locality;
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _stateController.dispose();
    _streetAddressController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final locality = _streetAddressController.text.trim();

    if (city.isEmpty || state.isEmpty || locality.isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Missing Fields'),
              content: const Text('Please fill in all fields.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    // ✅ Update directly here for clarity
    await ref
        .read(userProvider.notifier)
        .updateUserLocation(state: state, city: city, locality: locality)
        .whenComplete(() async {
          await AuthController().updateUserLocation(
            context: context,
            state: state,
            city: city,
            locality: locality,
            ref: ref,
          );
        });

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Shipping Address',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please enter your delivery address details',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              _buildInputField(
                controller: _cityController,
                label: 'City',
                icon: Icons.location_city_outlined,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _stateController,
                label: 'State / Province',
                icon: Icons.map_outlined,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _streetAddressController,
                label: 'Street Address',
                icon: Icons.home_outlined,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel', style: GoogleFonts.poppins()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveChanges,
                      child: Text(
                        'Save Address',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }
}

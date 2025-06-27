import 'dart:io';
import 'package:angkor_shop/controllers/provider/user_provider.dart';
import 'package:angkor_shop/controllers/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? _selectedImage;
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  String _profileImageUrl = '';
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    if (user != null) {
      _phoneController.text = user.phoneNumber;
      _profileImageUrl = user.profileImage;
    }
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    final phone = _phoneController.text.trim();
    final user = ref.read(userProvider);
    final email = user?.email ?? '';

    if ((_selectedImage == null && _profileImageUrl.isEmpty) || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select image and enter phone number")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String updatedImageUrl = _profileImageUrl;

      if (_selectedImage != null) {
        final fileName = path.basename(_selectedImage!.path);
        final mimeType = lookupMimeType(_selectedImage!.path) ?? 'image/jpeg';

        final apiUrl = Uri.parse(
          'https://117jajq1eb.execute-api.ap-southeast-1.amazonaws.com/update-profile',
        );

        final res = await http.post(
          apiUrl,
          headers: {'Content-Type': 'application/json'},
          body: '''
          {
            "fileName": "$fileName",
            "fileType": "$mimeType",
            "email": "$email",
            "phoneNumber": "$phone"
          }
        ''',
        );

        if (res.statusCode != 200) {
          throw Exception("Failed to get signed URL");
        }

        final uploadUrl = Uri.parse(
          RegExp(r'"uploadUrl"\s*:\s*"([^"]+)"')
                  .firstMatch(res.body)
                  ?.group(1) ??
              '',
        );

        updatedImageUrl = uploadUrl.toString().split('?').first;

        final uploadRes = await http.put(
          uploadUrl,
          headers: {'Content-Type': mimeType},
          body: await _selectedImage!.readAsBytes(),
        );

        if (uploadRes.statusCode != 200) {
          throw Exception("Failed to upload image to S3");
        }
      }

      // ✅ Update the provider with the new info
      final updatedUser = user!.copyWith(
        phoneNumber: phone,
        profileImage: updatedImageUrl,
      );

      await ref
          .read(userProvider.notifier)
          .updateUser(token: user.token, user: updatedUser);

      setState(() {
        _profileImageUrl = updatedImageUrl;
      });

      showSnackBar(context, 'Profile updated successfully');
    } catch (e) {
      print("Error: $e");
      showSnackBar(context, "Failed: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width.clamp(320.0, 600.0);
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: Text('Edit Profile', style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.04),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.14,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (_profileImageUrl.isNotEmpty
                          ? NetworkImage(_profileImageUrl)
                          : const NetworkImage("https://via.placeholder.com/150"))
                          as ImageProvider,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: screenWidth * 0.075,
                    height: screenWidth * 0.075,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xCC98E7F9), Color(0xFF00CFFF)],
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.025),
            _buildInputField(
              screenWidth,
              'Phone Number',
              '+855',
              _phoneController,
            ),
            SizedBox(height: screenHeight * 0.04),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Color(0xFF00CFFF),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: _isLoading ? null : _saveChanges,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Save Changes',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    double width,
    String label,
    String prefix,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(color: Color(0x3F000000), blurRadius: 3),
            ],
          ),
          child: Row(
            children: [
              Text(
                prefix,
                style: GoogleFonts.poppins(color: const Color(0x4C000000)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter phone number",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

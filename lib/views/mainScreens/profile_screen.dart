import 'package:angkor_shop/controllers/provider/user_provider.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/edit_profile_screen.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/help_center_screen.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/manage_address_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/order_screens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFFC5F3FD)),
          child: Column(
            children: [
              SizedBox(height: 24.h), // 0.03 * 812 ≈ 24
              Text(
                'Profile',
                style: GoogleFonts.poppins(
                  color: const Color(0xCC000000),
                  fontSize: 15.sp, // approx 0.06 * 375 ≈ 22.5
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h), // 0.02 * 812 ≈ 16
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 48.w, // 0.13 * 375 ≈ 48.75
                    backgroundImage: const NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F4b71756b2dfdef5d27bf29ac91dee569bdec2870Ellipse%208.png?alt=media&token=00f995f0-fc3c-4a5f-9d66-2c73b8569c7f',
                    ),
                  ),
                  Positioned(
                    right: 120.w, // 0.32 * 375 = 120
                    bottom: 0,
                    child: Container(
                      width: 26.w, // 0.07 * 375 = 26.25
                      height: 26.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.w),
                        gradient: const LinearGradient(
                          colors: [Color(0xCC98E7F9), Color(0xFF00CFFF)],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Image.network(
                          'https://storage.googleapis.com/codeless-app.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fecc80dbf-ce94-4f03-9d5a-4969494e2971.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h), // 0.015 * 812 ≈ 12
              Text(
                user!.fullName.toUpperCase(),
                style: GoogleFonts.poppins(
                  color: const Color(0xCC000000),
                  fontSize: 15.sp, // approx 0.045 * 375 ≈ 17
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 28.h), // 0.035 * 812 ≈ 28
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w, // 0.05 * 375 = 18.75
                    vertical: 20.h, // 0.025 * 812 = 20.3
                  ),
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final iconSize = constraints.maxWidth * 0.18;
                          final fontSize = 13.sp; // 0.035 * 375 = 13.1 approx
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const OrderScreen(),
                                    ),
                                  );
                                },
                                child: _buildTopIcon(
                                  icon:
                                      'https://storage.googleapis.com/codeless-app.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F9a423de5-d019-4861-8e6b-9e8ed22fc2dd.png',
                                  label: 'Orders',
                                  bgColor: const Color(0x4CC5F3FD),
                                  size: iconSize,
                                  fontSize: fontSize,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: _buildTopIcon(
                                  icon:
                                      'https://storage.googleapis.com/codeless-app.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F5ef37c20-e60e-4b0d-8b8c-0802947f694b.png',
                                  label: 'Reviews',
                                  bgColor: const Color(0x19FFDF00),
                                  size: iconSize,
                                  fontSize: fontSize,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return HelpCenterScreen();
                                      },
                                    ),
                                  );
                                },
                                child: _buildTopIcon(
                                  icon:
                                      'https://storage.googleapis.com/codeless-app.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fb326558f-8395-4221-b5a9-7c3b9dba96f9.png',
                                  label: 'Help',
                                  bgColor: const Color(0x0C000000),
                                  size: iconSize,
                                  fontSize: fontSize * 0.95,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      const Divider(color: Color(0xFFE8E8E8), thickness: 1),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EditProfileScreen();
                              },
                            ),
                          );
                        },
                        child: _buildListTile('Edit Your Profile'),
                      ),
                      const Divider(color: Color(0xFFE8E8E8), thickness: 1),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ManageAddressScreen();
                              },
                            ),
                          );
                        },
                        child: _buildListTile('Manage Address'),
                      ),
                      const Divider(color: Color(0xFFE8E8E8), thickness: 1),
                      _buildListTile('Logout'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopIcon({
    required String icon,
    required String label,
    required Color bgColor,
    required double size,
    required double fontSize,
  }) {
    return SizedBox(
      width: size,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(size / 2),
            ),
            child: Center(
              child: Image.network(
                icon,
                width: size * 0.5,
                height: size * 0.5,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xB2000000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 17.sp, // 0.045 * 375 ≈ 17
          fontWeight: FontWeight.w600,
          color: const Color(0xB2000000),
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
    );
  }
}

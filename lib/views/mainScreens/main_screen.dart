import 'package:angkor_shop/views/mainScreens/cart_screen.dart';
import 'package:angkor_shop/views/mainScreens/profile_screen.dart';
import 'package:angkor_shop/views/mainScreens/widgets/all_category_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart'; // import your screens here

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens corresponding to the navigation items
  final List<Widget> _screens = [
    HomeScreen(),
    AllCategoriesScreen(),
    CartScreen(),
    Text('WishList'),
    Profile(),
  ];

  final List<Map<String, String>> _navItems = [
    {'label': 'Home', 'icon': 'assets/icons/home.png'},
    {'label': 'Category', 'icon': 'assets/icons/category.png'},
    {'label': 'Cart', 'icon': 'assets/icons/cart.png'},
    {'label': 'Wishlist', 'icon': 'assets/icons/wishlist.png'},
    {'label': 'Profile', 'icon': 'assets/icons/profile.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: Container(
        height: 87,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 30)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final isSelected = _selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index; // Change the selected index
                });
                // Optionally, you can add any additional logic for page navigation
                // e.g., showing a page transition
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    item['icon']!,
                    width: 24,
                    height: 24,
                    color: isSelected ? Color(0xFF00CFFF) : Colors.grey,
                  ),
                  SizedBox(height: 6),
                  Text(
                    item['label']!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,

                      color: isSelected ? Color(0xFF00CFFF) : Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

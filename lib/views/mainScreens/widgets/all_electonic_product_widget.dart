import 'package:angkor_shop/views/mainScreens/inner_screens/all_mens_fashion_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ElectronicDevicesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {
        'title': 'Suit',
        'image':
            'https://product-images-akorshop-126.s3.amazonaws.com/suit-removebg-preview.png',
      },
      {
        'title': 'T-Shirt',
        'image':
            'https://product-images-akorshop-126.s3.amazonaws.com/mens-tshirt-removebg-preview.png',
      },
      {
        'title': 'Nike',
        'image':
            'https://product-images-akorshop-126.s3.amazonaws.com/shoes-removebg-preview (2).png',
      },
      {
        'title': 'Watch',
        'image':
            'https://product-images-akorshop-126.s3.amazonaws.com/watchs-removebg-preview.png',
      },
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFFFEFDE8),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        // <- Wrap with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "All Men's Fashion ",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AllMensFashionScreen();
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8DB04),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'Shop Now',
                      style: GoogleFonts.poppins(
                        color: Color(0xCC000000),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio:
                    0.8, // Adjusted a bit for better responsive design
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return Column(
                  children: [
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 10),
                        ],
                      ),
                      child: Center(
                        child: Image.network(
                          item['image']!,
                          width: 120,
                          height: 90,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title']!,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xCC000000),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String price;
  final String oldPrice;
  final double rating;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.14,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Product Image
          Positioned(
            top: screenHeight * 0.01,
            left: 0,
            child: Container(
              width: screenWidth * 0.28,
              height: screenHeight * 0.125,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x0C000000)),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          // Category
          Positioned(
            left: screenWidth * 0.32,
            top: screenHeight * 0.02,
            child: Text(
              category,
              style: GoogleFonts.poppins(
                color: const Color(0x3F000000),
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Title
          Positioned(
            left: screenWidth * 0.32,
            top: screenHeight * 0.04,
            child: SizedBox(
              width: screenWidth * 0.45,
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                title,
                style: GoogleFonts.poppins(
                  color: const Color(0xCC000000),
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Rating stars and number
          Positioned(
            left: screenWidth * 0.32,
            top: screenHeight * 0.065,
            child: Row(
              children: [
                ...List.generate(5, (index) {
                  if (index < rating.floor()) {
                    return Icon(
                      Icons.star,
                      size: screenWidth * 0.03,
                      color: Colors.yellow[700],
                    );
                  } else if (index < rating) {
                    return Icon(
                      Icons.star_half,
                      size: screenWidth * 0.03,
                      color: Colors.yellow[700],
                    );
                  } else {
                    return Icon(
                      Icons.star_border,
                      size: screenWidth * 0.03,
                      color: Colors.yellow[700],
                    );
                  }
                }),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  rating.toStringAsFixed(1),
                  style: GoogleFonts.poppins(
                    color: const Color(0x3F000000),
                    fontSize: screenWidth * 0.028,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Price
          Positioned(
            left: screenWidth * 0.32,
            top: screenHeight * 0.09,
            child: Text(
              price,
              style: GoogleFonts.poppins(
                color: const Color(0xFF00CFFF),
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Old Price
          Positioned(
            left: screenWidth * 0.52,
            top: screenHeight * 0.091,
            child: Text(
              oldPrice,
              style: GoogleFonts.poppins(
                color: const Color(0x3F000000),
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          // Heart Icon
          Positioned(
            top: screenHeight * 0.01,
            right: screenWidth * 0.03,
            child: Container(
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              decoration: BoxDecoration(
                color: const Color(0x0A101010),
                borderRadius: BorderRadius.circular(screenWidth * 0.08),
              ),
              child: Center(
                child: IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class CartEmptyScreen extends StatelessWidget {
  const CartEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cart',
              style: GoogleFonts.poppins(
                color: Color(0xCC000000),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 5),
            Text(
              '(0)',
              style: GoogleFonts.poppins(
                color: Color(0x66000000),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: 3 * pi / 180,
                    child: Container(
                      width: 315,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0x7FD9D9D9),
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(158, 24),
                        ),
                      ),
                    ),
                  ),
                  Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F1e3e98682be0eaacf2e26f722b58a68f2e1e0edbimage%2017.png?alt=media&token=f5e20f0b-c0d2-4510-b624-b5291711dc02',
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Your cart is looking lonely',
                style: GoogleFonts.poppins(
                  color: Color(0xCC000000),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add items to keep track of what you love!',
                style: GoogleFonts.poppins(
                  color: Color(0x7F000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

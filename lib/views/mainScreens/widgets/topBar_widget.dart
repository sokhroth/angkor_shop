import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/ANGKORSHOP.png',
          fit: BoxFit.cover,
          width: 120,
          height: 30,
        ),
        Row(
          children: [
            _iconBadge(
              'assets/icons/cart_notification.png',
              'assets/icons/alert1.png',
            ),
            const SizedBox(width: 10),
            _iconBadge('assets/icons/bell.png', 'assets/icons/aler2.png'),
          ],
        ),
      ],
    );
  }
}

Widget _iconBadge(String iconUrl, String badgeUrl) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Image.asset(iconUrl, width: 20, height: 24),
      Positioned(
        right: -3,
        top: -3,
        child: Image.asset(badgeUrl, width: 15, height: 15),
      ),
    ],
  );
}

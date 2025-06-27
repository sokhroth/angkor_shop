import 'package:flutter/material.dart';

class DeviceShowcase extends StatelessWidget {
  final ScrollController scrollController; // Receive the controller

  DeviceShowcase({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              print("Back to Top clicked!"); // Debug log
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 145,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2, color: const Color(0xFF00CFFF)),
                borderRadius: BorderRadius.circular(34),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F00CFFF),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://storage.googleapis.com/codeless-app.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fc17b0965-5ccf-4bcc-8d17-b944a6ac5e3a.png',
                    width: 9,
                    height: 11,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Back to Top',
                    style: TextStyle(
                      color: Color(0xFF00CFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lato',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

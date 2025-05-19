import 'package:angkor_shop/views/authentication/main_auth_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  List<String> images = [
    'assets/icons/intro.png',
    'assets/icons/intro2.png',
    'assets/icons/intro3.png',
  ];

  List<String> titles = [
    'Shop Smarter with Angkor Shop',
    'Fast & Secure Payments',
    'Track Your Orders Easily',
  ];

  List<String> descriptions = [
    "Discover thousands of products across all categories at unbeatable prices. Shop from trusted vendors and enjoy a seamless shopping experience.",
    "Make payments securely and instantly using your preferred method – cards, digital wallets, or cash on delivery. Your security is our priority.",
    "Stay updated with real-time order tracking and delivery updates. Know exactly when your package will arrive at your doorstep.",
  ];

  int currentIndex = 0;
  int pressCounter = 0;

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    Widget indicator(int index) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0.75),
        width: currentIndex == index ? 16 : 4,
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:
              currentIndex == index
                  ? const Color(0xFF00CFFF)
                  : const Color(0xffC4C4C4),
        ),
      );
    }

    Widget header() {
      int index = -1;
      return Container(
        margin: const EdgeInsets.only(top: 55),
        child: Column(
          children: [
            CarouselSlider(
              carouselController: _carouselController,
              items: images.map((image) => Image.asset(image)).toList(),
              options: CarouselOptions(
                initialPage: 0,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 79),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  images.map((e) {
                    index++;
                    return indicator(index);
                  }).toList(),
            ),
          ],
        ),
      );
    }

    Widget title() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
        child: Text(
          titles[currentIndex],
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    Widget content() {
      return Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Text(
          descriptions[currentIndex],
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: const Color(0xff80848A),
            fontSize: 13.5,
          ),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: const EdgeInsets.only(top: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 70),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainAuthScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Color(0xff80848A),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  if (currentIndex == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainAuthScreen(),
                      ),
                    );
                  } else {
                    currentIndex = (currentIndex + 1) % images.length;
                    pressCounter++;
                  }
                });
                _carouselController.nextPage();
              },
              child: Container(
                height: pressCounter == 3 ? 60 : 47.5,
                width: pressCounter == 3 ? 60 : 47.5,
                margin: const EdgeInsets.only(right: 40),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF00CFFF),
                ),
                child: Center(
                  child:
                      currentIndex < 2
                          ? Image.asset(
                            'assets/icons/Right 2.png',
                            height: 17,
                            width: 17,
                            fit: BoxFit.cover,
                          )
                          : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainAuthScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: 142,
                              height: 60,
                              alignment: Alignment.center,
                              child: const Text(
                                "Let's go",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(children: [header(), title(), content(), footer()]),
    );
  }
}

import 'package:angkor_shop/controllers/auth_controller.dart';
import 'package:angkor_shop/views/authentication/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  bool isLoading = false;

  String email = '';
  String fullName = '';
  String password = '';

  registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });
    await _authController.signUpUsers(
      context: context,
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: AnimationLimiter(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder:
                      (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                  children: [
                    Container(
                      height: 150,
                      width: 231,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/ANGKORSHOP.png'),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 19.75, left: 30),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 22.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    inputField(
                      label: 'Email Address',
                      hintText: 'example@gmail.com',
                      onChanged: (value) => email = value,
                    ),
                    inputField(
                      label: 'Full Name',
                      hintText: 'macaulay',
                      onChanged: (value) => fullName = value,
                    ),
                    inputField(
                      label: 'Create a Password',
                      hintText: 'must be 8 characters',
                      obscureText: true,
                      onChanged: (value) => password = value,
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          registerUser();
                        }
                      },
                      child: Container(
                        width: 319,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00CFFF), Color(0xFF00CFFF)],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 278,
                              top: 19,
                              child: Opacity(
                                opacity: 0.5,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 12,
                                      color: Colors.cyan.shade900,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 311,
                              top: 36,
                              child: Opacity(
                                opacity: 0.3,
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 281,
                              top: -10,
                              child: Opacity(
                                opacity: 0.3,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child:
                                  isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text(
                                        'Sign Up',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        line(),
                        const Text(
                          'or',
                          style: TextStyle(
                            color: Color(0xff80848A),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        line(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
                    ),
                    const SizedBox(height: 17.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: GoogleFonts.poppins(
                            color: const Color(0xff80848A),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            // Navigate to sign in page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignInPage();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              color: const Color(0xff000000),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField({
    required String label,
    required String hintText,
    required void Function(String) onChanged,
    bool obscureText = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: const Color(0xff000000),
              fontSize: 14.40,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            obscureText: obscureText,
            validator: (value) => value!.isEmpty ? 'Please enter field' : null,
            onChanged: onChanged,
            cursorColor: const Color(0xFF00CFFF),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xff808080),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF00CFFF)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget line() {
    return Container(
      height: 1,
      width: 140,
      decoration: const BoxDecoration(color: Colors.grey),
    );
  }
}

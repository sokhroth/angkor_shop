import 'package:angkor_shop/controllers/auth_controller.dart';
import 'package:angkor_shop/controllers/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _aUthController = AuthController();
  bool isLoading = false;
  List<String> otpDigits = List.filled(6, '');
  void verifyOtp() async {
    if (otpDigits.contains('')) {
      showSnackBar(context, 'please fill in all OTP fields');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final otp =
        otpDigits.join(); // Combine digits into a single OTP String (453564)

    await _aUthController.verifyOtp(
      context: context,
      email: widget.email,
      confirmationCode: otp,
      ref: ref,
    );
  }

  Widget buildOtpField(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          }
          return null;
        },
        //Handles changes in the text input.
        onChanged: (value) {
          ///check if the input is valid (non-empty) .
          if (value.isNotEmpty && value.length == 1) {
            //save the  digit to  the corresponding index
            otpDigits[index] = value;

            //automatically move focus to the next field  if not the last one.

            if (index < 5) {
              FocusScope.of(context).nextFocus();
            }
          } else {
            //clear the valud if input is remove
            otpDigits[index] = '';
          }
        },

        onFieldSubmitted: (value) {
          //Trigger OTP Verification if on the last field  and if the form is valid

          if (index == 5 && _formKey.currentState!.validate()) {
            verifyOtp();
          }
        },

        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),

        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Verify Your Account',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: const Color(0xFF0d120E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter the OTP sent to ${widget.email}",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF0d120E),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, buildOtpField),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      verifyOtp();
                    },
                    child: Container(
                      width: 319,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFF00CFFF),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Center(
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  'Verify',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:angkor_shop/controllers/provider/user_provider.dart';
import 'package:angkor_shop/controllers/services/global_variables.dart';
import 'package:angkor_shop/controllers/services/manage_http_response.dart';
import 'package:angkor_shop/models/user_model.dart';
import 'package:angkor_shop/views/authentication/opt_screen.dart';
import 'package:angkor_shop/views/authentication/sign_in_screen.dart';
import 'package:angkor_shop/views/mainScreens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future<void> signUpUsers({
    required BuildContext context,
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        fullName: fullName,
        userId: '',
        email: email,
        state: '',
        city: '',
        locality: '',
        password: password,
        token: '',
        phoneNumber: '',
        profileImage: '',
      );

      http.Response response = await http.post(
        Uri.parse(signUpAPIURl),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Account created. Please verify your OTP.');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return OtpScreen(email: email);
              },
            ),
            (route) => false,
          );
        },
      );
      print(response.body);
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }

  Future<void> signInUsers({
    required BuildContext context,
    required WidgetRef ref,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse(signInAPIUrl),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final responseData = jsonDecode(response.body);
          final tokens = responseData['tokens'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'userToken',
            tokens['AccessToken'],
          ); // ✅ Store token
          await prefs.setString('userEmail', email); // Store email

          final userProviderRef = ref.read(userProvider.notifier);
          await userProviderRef.updateUser(
            token: tokens['AccessToken'],
            user: User(
              email: email,
              fullName: responseData['fullName'],
              userId: responseData['userId'],
              state: responseData['state'],
              city: responseData['city'],
              locality: responseData['locality'],
              password: '',
              token: tokens['AccessToken'],
              phoneNumber: '',
              profileImage: ''
            ),
          );

          print('userId is ${responseData["userId"]}');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
          );

          showSnackBar(context, 'Logged in');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String confirmationCode,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse(confirmSignUpAPIUrl),
        body: jsonEncode({
          "email": email,
          'confirmationCode': confirmationCode,
        }),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final decoded = jsonDecode(response.body);
          final userId = decoded['userId']; // 👈 from backend

          // Store in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userId);
          await prefs.setString(
            'userEmail',
            email,
          ); // Save for reuse if not yet

          // Update Riverpod state
          ref
              .read(userProvider.notifier)
              .updateUser(
                user: User(
                  userId: userId,
                  email: email,
                  fullName: '',
                  password: '',
                  state: '',
                  city: '',
                  locality: '',
                  token: '',
                  phoneNumber: '',
                  profileImage: '',
                ),
                token: '',
              );

          showSnackBar(context, 'Account verified. Please log in.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error verifying OTP:  $e');
    }
  }

  Future<void> updateUserLocation({
    required BuildContext context,
    required String state,
    required String city,
    required String locality,
    required WidgetRef ref, // this is the key part!
  }) async {
    try {
      // Retrieve the email from the Riverpod provider or shared preferences
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail');

      print('userEmai ${email}');

      // Prepare the request body
      final requestBody = jsonEncode({
        "email": email,
        "state": state,
        "city": city,
        "locality": locality,
      });

      // Send the update request
      http.Response response = await http.post(
        Uri.parse(
          "https://117jajq1eb.execute-api.ap-southeast-1.amazonaws.com/update-location",
        ),
        body: requestBody,
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      // Handle the response
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          // Update the user's location in the app state (Riverpod)
          ref
              .read(userProvider.notifier)
              .updateUserLocation(state: state, city: city, locality: locality);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
          showSnackBar(context, 'Location updated successfully!');
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error updating location: $e');
    }
  }

  Future<void> checkTokenAndNavigate({
    required BuildContext context,
    required UserState userNotifier, // ✅ pass the correct UserState
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token == null || token.isEmpty) {
      userNotifier.clearUser();
      prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(
        'https://117jajq1eb.execute-api.ap-southeast-1.amazonaws.com/check-token',
      ),
      body: jsonEncode({'accessToken': token}),
      headers: {"Content-Type": 'application/json; charset=UTF-8'},
    );

    if (response.statusCode != 200) {
      userNotifier.clearUser();
      prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    }
  }
}

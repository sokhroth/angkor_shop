import 'package:angkor_shop/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserState extends StateNotifier<User?> {
  UserState() : super(null);

  // Update and persist the user
  Future<void> updateUser({required String token, required User user}) async {
    final updatedUser = user.copyWith(token: token);
    state = updatedUser;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', updatedUser.email);
    await prefs.setString('userFullName', updatedUser.fullName);
    await prefs.setString('userState', updatedUser.state);
    await prefs.setString('userCity', updatedUser.city);
    await prefs.setString('userLocality', updatedUser.locality);
    await prefs.setString('userToken', updatedUser.token);
    await prefs.setString('userId', updatedUser.userId);
    await prefs.setString('userPhoneNumber', updatedUser.phoneNumber); // ✅ New
    await prefs.setString(
      'userProfileImage',
      updatedUser.profileImage,
    ); // ✅ New
  }

  // Load the user from storage when app starts
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    final fullName = prefs.getString('userFullName');
    final stateStr = prefs.getString('userState');
    final city = prefs.getString('userCity');
    final locality = prefs.getString('userLocality');
    final token = prefs.getString('userToken');
    final userId = prefs.getString('userId');
    final phoneNumber = prefs.getString('userPhoneNumber'); // ✅ New
    final profileImage = prefs.getString('userProfileImage'); // ✅ New

    if (email != null && token != null && userId != null) {
      state = User(
        email: email,
        fullName: fullName ?? '',
        userId: userId,
        state: stateStr ?? '',
        city: city ?? '',
        locality: locality ?? '',
        password: '',
        token: token,
        phoneNumber: phoneNumber ?? '',
        profileImage: profileImage ?? '',
      );
    }
  }

  // Clear user from state and storage
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = null;
  }

  // Update user's location and save to storage
  Future<void> updateUserLocation({
    required String state,
    required String city,
    required String locality,
  }) async {
    final updatedUser = this.state?.copyWith(
      state: state,
      city: city,
      locality: locality,
    );
    if (updatedUser != null) {
      this.state = updatedUser;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userState', updatedUser.state);
      await prefs.setString('userCity', updatedUser.city);
      await prefs.setString('userLocality', updatedUser.locality);
    }
  }
}

final userProvider = StateNotifierProvider<UserState, User?>((ref) {
  return UserState();
});
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String fullName;
  final String userId;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;
  final String phoneNumber; // ✅ New field
  final String profileImage; // ✅ New field

  User({
    required this.fullName,
    required this.userId,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
    required this.token,
    required this.phoneNumber, // ✅
    required this.profileImage, // ✅
  });

  User copyWith({
    String? fullName,
    String? userId,
    String? email,
    String? state,
    String? city,
    String? locality,
    String? password,
    String? token,
    String? phoneNumber, // ✅
    String? profileImage, // ✅
  }) {
    return User(
      fullName: fullName ?? this.fullName,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      state: state ?? this.state,
      city: city ?? this.city,
      locality: locality ?? this.locality,
      password: password ?? this.password,
      token: token ?? this.token,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'userId': userId,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'password': password,
      'token': token,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      fullName: map['fullName'] as String? ?? "",
      userId: map['userId'] as String? ?? "",
      email: map['email'] as String? ?? "",
      state: map['state'] as String? ?? "",
      city: map['city'] as String? ?? "",
      locality: map['locality'] as String? ?? "",
      password: map['password'] as String? ?? "",
      token: map['token'] as String? ?? "",
      phoneNumber: map['phoneNumber'] as String? ?? "",
      profileImage: map['profileImage'] as String? ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
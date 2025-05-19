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

  User({
    required this.fullName,
    required this.userId,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
    required this.token,
  });

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
    };
  }

  // Add this 👇
  User copyWith({
    String? fullName,
    String? userId,
    String? email,
    String? state,
    String? city,
    String? locality,
    String? password,
    String? token,
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
    );
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
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}

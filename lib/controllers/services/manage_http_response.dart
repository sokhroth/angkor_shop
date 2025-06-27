import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

String getMessageFromResponse(Map<String, dynamic> body) {
  if (body.containsKey('message') && body['message'] is String) {
    return body['message'];
  } else if (body.containsKey('error') && body['error'] is String) {
    return body['error'];
  } else if (body.containsKey('errors')) {
    // Handles validation error maps or lists
    final errors = body['errors'];
    if (errors is Map) {
      // Combine all messages from a map of errors
      return errors.values
          .map((e) => e is List ? e.join(', ') : e.toString())
          .join('\n');
    } else if (errors is List) {
      // Combine all messages from a list of error strings
      return errors.join('\n');
    }
  }
  return 'Something went wrong. Please try again.';
}

void manageHttpResponse({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  try {
    final Map<String, dynamic> body = json.decode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        onSuccess();
        break;
      case 400:
      case 403:
      case 409:
      case 422:
      case 500:
        showSnackBar(context, getMessageFromResponse(body));
        break;
      default:
        showSnackBar(context, 'Unexpected error: ${response.statusCode}');
    }
  } catch (e) {
    showSnackBar(context, 'Error processing response: $e');
  }
}

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.all(15),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.grey,
      content: Text(title, style: GoogleFonts.montserrat()),
    ),
  );
}

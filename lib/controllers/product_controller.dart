import 'dart:convert';
import 'dart:typed_data';
import 'package:angkor_shop/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductController {
  static const String _baseUrl =
      'https://a46p7zk56k.execute-api.ap-southeast-1.amazonaws.com';
  static const String _uploadEndpoint = '/get-upload-url';

  Future<bool> uploadProductWithImages({
    required List<Map<String, dynamic>>
    images, // Each image has 'fileName', 'fileType', 'bytes'
    required String productName,
    required double productPrice,
    required String description,
    required int quantity,
    required String category,
  }) async {
    try {
      // Step 1: Request presigned upload URLs
      final response = await http.post(
        Uri.parse('$_baseUrl$_uploadEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'images':
              images
                  .map(
                    (image) => {
                      'fileName': image['fileName'],
                      'fileType': image['fileType'],
                    },
                  )
                  .toList(),
          'productName': productName,
          'productPrice': productPrice,
          'description': description,
          'quantity': quantity,
          'category': category,
        }),
      );

      if (response.statusCode != 200) {
        print('Failed to get upload URLs. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }

      final data = jsonDecode(response.body);
      final uploadUrls =
          (data['uploadUrls'] as List).cast<Map<String, dynamic>>();

      // Step 2: Upload images to S3 using the signed URLs
      for (final image in images) {
        final fileName = image['fileName'];

        final uploadUrlData = uploadUrls.firstWhere(
          (u) => u['fileName'] == fileName,
          orElse: () => {},
        );

        if (uploadUrlData.isEmpty) {
          print('No presigned URL found for image: $fileName');
          continue;
        }

        final signedUrl = uploadUrlData['signedUrl'];

        final uploadResponse = await http.put(
          Uri.parse(signedUrl),
          headers: {'Content-Type': image['fileType']},
          body: image['bytes'] as Uint8List,
        );

        if (uploadResponse.statusCode != 200) {
          print('Failed to upload image: $fileName');
          print('Status: ${uploadResponse.statusCode}');
          return false;
        }
      }

      print('✅ Product and all images uploaded successfully!');
      return true;
    } catch (e) {
      print('Upload error: $e');
      return false;
    }
  }

  Future<List<Product>> loadProducts() async {
    try {
      http.Response response = await http.get(
        Uri.parse(
          'https://a46p7zk56k.execute-api.ap-southeast-1.amazonaws.com/approve-products',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.body); // Debugging output

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded =
            json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic> data = decoded['products'] ?? []; // <-- FIX here

        List<Product> products =
            data
                .map(
                  (product) => Product.fromMap(product as Map<String, dynamic>),
                )
                .toList();

        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Error loading product: $e');
    }
  }

  Future<List<Product>> loadWomensWears() async {
    try {
      http.Response response = await http.get(
        Uri.parse(
          'https://a46p7zk56k.execute-api.ap-southeast-1.amazonaws.com/get-women-wears',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.body); // Debugging output

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded =
            json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic> data = decoded['products'] ?? []; // <-- FIX here

        List<Product> products =
            data
                .map(
                  (product) => Product.fromMap(product as Map<String, dynamic>),
                )
                .toList();

        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Error loading product: $e');
    }
  }

  Future<List<Product>> loadMenWears() async {
    try {
      http.Response response = await http.get(
        Uri.parse(
          'https://a46p7zk56k.execute-api.ap-southeast-1.amazonaws.com/getMensWears',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.body); // Debugging output

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded =
            json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic> data = decoded['products'] ?? []; // <-- FIX here

        List<Product> products =
            data
                .map(
                  (product) => Product.fromMap(product as Map<String, dynamic>),
                )
                .toList();

        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Error loading product: $e');
    }
  }

  Future<List<Product>> loadProductsByCategory(String category) async {
    try {
      // Add query parameter separator (?)
      final url = Uri.parse(
        'https://a46p7zk56k.execute-api.ap-southeast-1.amazonaws.com/get-products-by-category?category=$category',
      );

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic> data = decoded['products'] ?? [];

        return data.map((item) => Product.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load category products');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final url = Uri.parse(
        'https://a46p7zk56k.execute-api.ap-southeast-1.amazonaws.com/search-products?q=$query',
      );

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic> data = decoded['results'] ?? [];

        return data.map((item) => Product.fromMap(item)).toList();
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      throw Exception('Search error: $e');
    }
  }

}

// current_product_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:angkor_shop/models/product_model.dart';

final currentProductProvider = StateProvider<Product?>((ref) => null);

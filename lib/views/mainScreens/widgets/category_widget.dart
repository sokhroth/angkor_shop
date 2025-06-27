import 'package:angkor_shop/controllers/provider/category_provider.dart';
import 'package:angkor_shop/views/mainScreens/widgets/all_category_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  Widget _buildShimmerEffect(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth * 0.25; // 25% of screen width
    final spacing = screenWidth * 0.04; // 4% spacing

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: spacing),
      child: Row(
        children: List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(right: spacing),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: itemWidth,
                height:
                    itemWidth *
                    1.2, // keep same aspect ratio as original 100x120
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth * 0.25; // 25% width per item
    final spacing = screenWidth * 0.04; // 4% spacing between items

    if (categories.isEmpty) {
      return _buildShimmerEffect(context);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: spacing),
      child: Row(
        children:
            categories.map((category) {
              return Padding(
                padding: EdgeInsets.only(right: spacing),
                child: CategoryItem(
                  itemWidth: itemWidth,
                  data: CategoryData(
                    imageUrl: category.imageUrl,
                    label: category.categoryName,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

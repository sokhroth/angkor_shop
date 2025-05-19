import 'package:angkor_shop/controllers/category_controller.dart'
    show CategoryController;
import 'package:angkor_shop/controllers/provider/category_provider.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/product_by_category_screen.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/search_product_screen.dart';
import 'package:angkor_shop/views/mainScreens/widgets/deals_of_day_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AllCategoriesScreen extends ConsumerStatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  ConsumerState<AllCategoriesScreen> createState() =>
      _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends ConsumerState<AllCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final CategoryController categoryController = CategoryController();
    try {
      final categories = await categoryController.loadCategories();
      ref.read(categoryProvider.notifier).setCategories(categories);
    } catch (e) {
      // Handle errors if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.025),
              Center(
                child: Text(
                  'All Categories',
                  style: GoogleFonts.poppins(
                    color: const Color(0xCC000000),
                    fontSize: (screenWidth * 0.05) * textScale.clamp(1.0, 1.3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchProductScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: screenWidth * 0.025),
                      Expanded(
                        child: Text(
                          'Search here...',
                          style: GoogleFonts.poppins(
                            color: const Color(0x80000000),
                            fontSize:
                                (screenWidth * 0.035) *
                                textScale.clamp(1.0, 1.3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double maxWidth = constraints.maxWidth;
                  int crossAxisCount = (maxWidth / 120).floor().clamp(2, 6);
                  double spacing = screenWidth * 0.04;
                  double itemWidth =
                      (maxWidth - ((crossAxisCount - 1) * spacing)) /
                      crossAxisCount;

                  return categories.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Wrap(
                        spacing: spacing,
                        runSpacing: screenHeight * 0.03,
                        children:
                            categories
                                .map(
                                  (category) => CategoryItem(
                                    itemWidth: itemWidth,
                                    data: CategoryData(
                                      imageUrl: category.imageUrl,
                                      label: category.categoryName,
                                    ),
                                  ),
                                )
                                .toList(),
                      );
                },
              ),
              SizedBox(height: screenHeight * 0.03),
              const DealOfTheDayWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryData {
  final String imageUrl;
  final String label;

  const CategoryData({required this.imageUrl, required this.label});
}

class CategoryItem extends StatelessWidget {
  final CategoryData data;
  final double itemWidth;

  const CategoryItem({super.key, required this.data, required this.itemWidth});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductByCategoryScreen(categoryName: data.label),
          ),
        );
      },
      child: SizedBox(
        width: itemWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: itemWidth * 0.75,
              height: itemWidth * 0.75,
              decoration: BoxDecoration(
                color: const Color(0x7FC5F3FD),
                borderRadius: BorderRadius.circular(itemWidth * 0.375),
              ),
              child: Padding(
                padding: EdgeInsets.all(itemWidth * 0.06),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(itemWidth * 0.375),
                  child: Image.network(
                    data.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 30,
                          color: Colors.grey,
                        ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: itemWidth * 0.04),
            AutoSizeText(
              data.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: ((itemWidth * 0.10) * textScale).clamp(10.0, 16.0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

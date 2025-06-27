import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:angkor_shop/controllers/provider/user_order_provider.dart';
import 'package:angkor_shop/models/order_model.dart';
import 'package:angkor_shop/views/mainScreens/inner_screens/track_order_details_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  // We'll store tab keys to measure their position & width
  final List<GlobalKey> tabKeys = [GlobalKey(), GlobalKey(), GlobalKey()];

  // Indicator position and width
  double indicatorLeft = 0;
  double indicatorWidth = 0;

  // Animate indicator movement
  late AnimationController _animationController;
  late Animation<double> _leftAnimation;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    // Animation controller for smooth transition of indicator
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setIndicator();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setIndicator() {
    // Get the RenderBox for the selected tab
    final renderBox =
        tabKeys[selectedIndex].currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      final tabBarRenderBox = context.findRenderObject() as RenderBox;
      final tabBarPosition = tabBarRenderBox.localToGlobal(Offset.zero);

      final newLeft = position.dx - tabBarPosition.dx;
      final newWidth = size.width;

      // Animate from old position to new
      _leftAnimation = Tween<double>(
        begin: indicatorLeft,
        end: newLeft,
      ).animate(_animationController);
      _widthAnimation = Tween<double>(
        begin: indicatorWidth,
        end: newWidth,
      ).animate(_animationController);

      _animationController.reset();
      _animationController.forward();

      _animationController.addListener(() {
        setState(() {
          indicatorLeft = _leftAnimation.value;
          indicatorWidth = _widthAnimation.value;
        });
      });
    }
  }

  void _onTabTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    _setIndicator();
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(userOrderProvider);

    List<OrderModel> filteredOrders;
    if (selectedIndex == 0) {
      filteredOrders =
          orders
              .where(
                (order) =>
                    order.orderPlaced &&
                    order.inProgress &&
                    !order.shipped &&
                    !order.delivered,
              )
              .toList();
    } else if (selectedIndex == 1) {
      filteredOrders = orders.where((order) => order.delivered).toList();
    } else {
      filteredOrders =
          orders
              .where(
                (order) =>
                    !order.orderPlaced &&
                    !order.inProgress &&
                    !order.shipped &&
                    !order.delivered,
              )
              .toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Order',
          style: GoogleFonts.poppins(
            color: Color(0xCC000000),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Tab bar with dynamic indicator
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTab('Active', 0),
                    _buildTab('Complete', 1),
                    _buildTab('Cancel', 2),
                  ],
                ),
                Positioned(
                  left: indicatorLeft,
                  bottom: 0,
                  width: indicatorWidth,
                  height: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF00CFFF),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child:
                filteredOrders.isEmpty
                    ? const Center(child: Text('No orders yet'))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              TrackOrderScreen(order: order),
                                    ),
                                  ),
                              child: OrderCard(
                                imageUrl: Icons.image,
                                title: order.productName,
                                category: 'Qty: ${order.quantity}',
                                price: '\$${order.productPrice}',
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      key: tabKeys[index],
      onTap: () => _onTabTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color:
                isSelected ? const Color(0xCC000000) : const Color(0x66000000),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final IconData imageUrl;
  final String title;
  final String category;
  final String price;

  const OrderCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Color(0x3F000000), blurRadius: 3)],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0x4CC5F3FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(imageUrl),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Color(0xCC000000),
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  category,
                  style: GoogleFonts.poppins(
                    color: Color(0x3F000000),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.poppins(
                        color: Color(0xFF00CFFF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x4C00CFFF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Track',
                        style: GoogleFonts.poppins(
                          color: Color(0xFF00CFFF),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

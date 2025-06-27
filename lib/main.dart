import 'package:angkor_shop/controllers/auth_controller.dart';
import 'package:angkor_shop/controllers/provider/user_provider.dart';
import 'package:angkor_shop/views/authentication/splash_screen.dart';
import 'package:angkor_shop/views/mainScreens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // <-- Import ScreenUtil

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return ScreenUtilInit(
      designSize: const Size(375, 812), // Set your design size here
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Consumer(
            builder: (context, ref, _) {
              final userNotifier = ref.read(userProvider.notifier);
              userNotifier.loadUser();

              final user = ref.watch(userProvider);

              if (user != null) {
                Future.microtask(() {
                  AuthController().checkTokenAndNavigate(
                    // ignore: use_build_context_synchronously
                    context: context,
                    userNotifier: userNotifier,
                  );
                });
                return const MainScreen();
              } else {
                return SplashScreen();
              }
            },
          ),
        );
      },
    );
  }
}

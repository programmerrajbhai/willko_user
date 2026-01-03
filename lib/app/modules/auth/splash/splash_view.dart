import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller ইনজেক্ট করা হচ্ছে (Get.put)
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: const Color(0xFF6C63FF), // AppColors.primary
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cleaning_services, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Willko Service",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
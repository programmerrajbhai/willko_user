import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding_controller.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller ইনজেক্ট (Get.put)
    final OnboardingController controller = Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: (index) => controller.selectedPageIndex.value = index,
            itemCount: controller.onBoardingPages.length,
            itemBuilder: (context, index) {
              var item = controller.onBoardingPages[index];
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dummy Icon Placeholder
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _getIcon(item["icon"]!), // Helper function for icon
                        size: 100,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      item["title"]!,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      item["desc"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),

          // Bottom Navigation
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: controller.pageController,
                  count: controller.onBoardingPages.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.deepPurple,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
                FloatingActionButton(
                  onPressed: controller.nextPage,
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // String থেকে IconData পাওয়ার জন্য ছোট হেল্পার
  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'calendar_month': return Icons.calendar_month;
      case 'engineering': return Icons.engineering;
      case 'rocket_launch': return Icons.rocket_launch;
      default: return Icons.star;
    }
  }
}
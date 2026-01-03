
import 'package:get/get.dart';
import '../onboarding/onboarding_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    // সরাসরি পেজ নেভিগেশন (Get.to এর বদলে Get.off যাতে ব্যাকে না আসে)
    Get.off(() => const OnboardingView());
  }
}
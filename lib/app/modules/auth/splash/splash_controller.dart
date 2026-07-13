import 'package:get/get.dart';
import 'package:willko_user/app/data/services/api_service.dart';
import 'package:willko_user/app/modules/home/home_view.dart';
import 'package:willko_user/app/modules/home/service_details/service_details_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      final response = await ApiService.fetchHomeData();

      if (response['status'] == 'success') {
        final data = response['data'];
        final rawCategories = data['categories'];

        final categories = rawCategories is List
            ? rawCategories
            .map((e) => Map<String, dynamic>.from(e))
            .toList()
            : <Map<String, dynamic>>[];

        if (categories.isNotEmpty) {
          final acCategory = categories.firstWhere(
                (cat) {
              final name = (cat['name'] ?? cat['label'] ?? '')
                  .toString()
                  .toLowerCase();

              final slug = (cat['slug'] ?? '')
                  .toString()
                  .toLowerCase();

              return name.contains('ac') ||
                  name.contains('air conditioner') ||
                  name.contains('air conditioning') ||
                  slug.contains('ac') ||
                  slug.contains('air-conditioner') ||
                  slug.contains('air-conditioning');
            },
            orElse: () => categories.first,
          );

          Get.off(
                () => const ServiceDetailsView(),
            arguments: acCategory,
            transition: Transition.cupertino,
          );
          return;
        }
      }
    } catch (e) {
      print("Splash redirect error: $e");
    }

    // fallback: AC category na pele normal HomeView open hobe
    Get.off(() => const HomeView());
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../service_details/service_details_view.dart';
import 'search_controller.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller এর নাম পরিবর্তন করা হয়েছে যাতে বিল্ট-ইন SearchController এর সাথে কনফ্লিক্ট না করে
    final controller = Get.put(SearchServicesController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. Top Search Bar Area ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: Row(
                children: [
                  // Back Button
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                  const SizedBox(width: 15),

                  // Search Input
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        autofocus: true, // পেজ ওপেন হওয়ামাত্র কিবোর্ড আসবে
                        onChanged: (val) => controller.filterServices(val),
                        decoration: InputDecoration(
                          hintText: "Search for services...",
                          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 14),
                          border: InputBorder.none,
                          icon: const Icon(Icons.search, size: 20, color: Colors.grey),
                          // Clear Button (শুধু যখন টেক্সট থাকবে)
                          suffixIcon: Obx(() => controller.searchText.value.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.cancel, size: 18, color: Colors.grey),
                            onPressed: controller.clearSearch,
                          )
                              : const SizedBox()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. Body Content ---
            Expanded(
              child: Obx(() {
                // A. যদি সার্চ বক্স খালি থাকে -> Popular Tags দেখাও
                if (controller.searchText.value.isEmpty) {
                  return _buildPopularTags(controller);
                }

                // B. যদি সার্চ করার পর কিছু না পাওয়া যায় -> Not Found
                if (controller.searchResults.isEmpty) {
                  return _buildNotFound();
                }

                // C. রেজাল্ট পাওয়া গেলে -> List View
                return _buildSearchResults(controller);
              }),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget: Popular Tags ---
  Widget _buildPopularTags(SearchServicesController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Popular Searches",
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: controller.popularTags.map((tag) {
              return ActionChip(
                label: Text(tag, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onPressed: () => controller.onTagClick(tag),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  // --- Widget: Not Found ---
  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            "No services found",
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Text(
            "Try searching with a different keyword",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- Widget: Search Results List ---
  Widget _buildSearchResults(SearchServicesController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        var service = controller.searchResults[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              // Image
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(service['image'], color: Colors.grey.shade600),
              ),
              const SizedBox(width: 15),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'],
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['category'],
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['price'],
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),

              // Add Button
              InkWell(
                onTap: () {
                  // আইডি পাস করে ডিটেইলস পেজে যাওয়া
                  Get.to(() => const ServiceDetailsView(),);
                  Get.snackbar("Service", "Clicked on ${service['name']}", snackPosition: SnackPosition.BOTTOM);
                  // Navigate to Service Details if needed
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "View",
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
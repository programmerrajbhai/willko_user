import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'category_controller.dart';

class CategoryServicesView extends StatelessWidget {
  const CategoryServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          controller.categoryName.value.isEmpty ? "Services" : controller.categoryName.value,
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
        )),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.categoryServices.isEmpty) {
          return Center(
            child: Text("No services found in this category", style: GoogleFonts.poppins()),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.categoryServices.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, thickness: 1, height: 30),
          itemBuilder: (context, index) {
            var service = controller.categoryServices[index];
            return GestureDetector(
              onTap: () => controller.onServiceClick(service['id']),
              child: Container(
                color: Colors.transparent, // ক্লিকের জন্য এরিয়া ঠিক রাখা
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. Service Info (Left Side) ---
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['name'],
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),

                          // Rating & Reviews
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                  service['rating'],
                                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54)
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Price & Time
                          Row(
                            children: [
                              Text(
                                service['price'],
                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                service['time'],
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Features (Bullet points)
                          Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: (service['features'] as List<String>).map((feature) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle_outline, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(feature, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                                  const SizedBox(width: 8),
                                ],
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),

                    // --- 2. Image & Add Button (Right Side) ---
                    const SizedBox(width: 15),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Image Placeholder
                        Container(
                          height: 100,
                          width: 90,
                          margin: const EdgeInsets.only(bottom: 15), // বাটনের জন্য জায়গা
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(service['image'], size: 40, color: Colors.grey.shade400),
                        ),

                        // Add Button (Floating on Image)
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 32,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))
                              ],
                              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Add to cart logic
                                  Get.snackbar("Added", "${service['name']} added to cart",
                                      snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));
                                },
                                borderRadius: BorderRadius.circular(6),
                                child: Center(
                                  child: Text(
                                    "ADD +",
                                    style: GoogleFonts.poppins(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
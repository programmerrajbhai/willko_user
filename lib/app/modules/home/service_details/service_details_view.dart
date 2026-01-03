import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'service_details_controller.dart';

class ServiceDetailsView extends StatelessWidget {
  const ServiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiceDetailsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        var data = controller.service;

        return Stack(
          children: [
            // --- Scrollable Content ---
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Sliver App Bar (Collapsible Image)
                SliverAppBar(
                  expandedHeight: 250.0,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  leading: IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    onPressed: () => Get.back(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(data['image'], size: 80, color: Colors.grey.shade400),
                        // রিয়েল ইমেজের জন্য: Image.network(data['image_url'], fit: BoxFit.cover)
                      ),
                    ),
                  ),
                ),

                // 2. Body Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Price
                        Text(
                          data['name'],
                          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                            const SizedBox(width: 5),
                            Text(
                              "${data['rating']} (${data['reviews_count']} reviews)",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          data['price'],
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 20),

                        const Divider(),
                        const SizedBox(height: 20),

                        // Description
                        Text(
                          "About Service",
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['description'],
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
                        ),
                        const SizedBox(height: 25),

                        // What's Included
                        Text(
                          "What's Included",
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(data['includes'].length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    data['includes'][index],
                                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 20),
                        // What's Excluded
                        Text(
                          "Excludes",
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(data['excludes'].length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.cancel, color: Colors.redAccent, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    data['excludes'][index],
                                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 100), // Bottom space for fixed button
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- 3. Fixed Bottom Bar (Add to Cart) ---
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity Selector
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: controller.decrementQty,
                            icon: const Icon(Icons.remove, size: 18),
                            constraints: const BoxConstraints(minWidth: 35),
                          ),
                          Obx(() => Text(
                            "${controller.quantity.value}",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                          IconButton(
                            onPressed: controller.incrementQty,
                            icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                            constraints: const BoxConstraints(minWidth: 35),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Add Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          "Add to Cart - ${data['price']}",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
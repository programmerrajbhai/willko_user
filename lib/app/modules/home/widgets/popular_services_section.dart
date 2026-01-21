import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_controller.dart';

class PopularServicesSection extends StatelessWidget {
  final HomeController controller;
  const PopularServicesSection({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ ১. লোডিং অবস্থায় Skeleton কার্ড দেখাবে
      if (controller.isLoading.value && controller.popularServices.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _buildSkeletonText(width: 150, height: 24),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: 3, // ৩টি ফেইক কার্ড
                itemBuilder: (context, index) => _buildSkeletonCard(),
              ),
            ),
          ],
        );
      }

      if (controller.popularServices.isEmpty) return const SizedBox();

      // ✅ ২. রিয়েল ডাটা
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text("Most Popular Services", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: controller.popularServices.length,
              itemBuilder: (context, index) {
                final service = controller.popularServices[index];
                return GestureDetector(
                  onTap: () => controller.openServiceDetails(service),
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(service['image_url'] ?? "", width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[100], child: const Icon(Icons.image))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(service['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text("Starts at \$${service['price']}", style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue[700], fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  // 🦴 Skeleton Helpers
  Widget _buildSkeletonText({required double width, required double height}) {
    return Container(width: width, height: height, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)));
  }

  Widget _buildSkeletonCard() {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16, bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        children: [
          Expanded(child: Container(color: Colors.grey.shade100)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 14, color: Colors.grey.shade100),
                const SizedBox(height: 6),
                Container(width: 60, height: 12, color: Colors.grey.shade100),
              ],
            ),
          )
        ],
      ),
    );
  }
}
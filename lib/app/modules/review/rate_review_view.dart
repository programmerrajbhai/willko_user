import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'review_controller.dart';

class RateReviewView extends StatelessWidget {
  const RateReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Rate Service",
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // --- 1. Provider Info ---
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage("assets/images/provider.png"), // ডামি ইমেজ
                  fit: BoxFit.cover,
                ),
              ),
              child: const Icon(Icons.person, size: 40, color: Colors.grey), // ফেইলসেফ আইকন
            ),
            const SizedBox(height: 15),
            Text(
              "How was Karim Uddin?",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "AC Service (Split)",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // --- 2. Star Rating Bar ---
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => controller.setRating(index + 1.0),
                  icon: Icon(
                    index < controller.rating.value ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: Colors.amber,
                    size: 40,
                  ),
                );
              }),
            )),

            const SizedBox(height: 10),
            Obx(() => Text(
              _getRatingLabel(controller.rating.value),
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[700]
              ),
            )),

            const SizedBox(height: 30),

            // --- 3. Quick Tags (Chips) ---
            Text("What went well?", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: controller.feedbackTags.map((tag) {
                bool isSelected = controller.selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text(tag),
                  labelStyle: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 12
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade300)
                  ),
                  onSelected: (val) => controller.toggleTag(tag),
                );
              }).toList(),
            )),

            const SizedBox(height: 30),

            // --- 4. Comment Input ---
            TextField(
              controller: controller.commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write additional comments...",
                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13),
                filled: true,
                fillColor: const Color(0xFFF9F9F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),

            const SizedBox(height: 40),

            // --- 5. Submit Button ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                  "Submit Review",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  // হেল্পার: রেটিং অনুযায়ী টেক্সট
  String _getRatingLabel(double rating) {
    if (rating >= 5) return "Excellent!";
    if (rating >= 4) return "Good";
    if (rating >= 3) return "Average";
    if (rating >= 2) return "Below Average";
    if (rating >= 1) return "Poor";
    return "Tap to Rate";
  }
}
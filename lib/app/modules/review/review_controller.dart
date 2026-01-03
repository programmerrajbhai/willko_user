import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  // ভেরিয়েবল
  var rating = 0.0.obs; // বর্তমানে কত স্টার সিলেক্ট করা আছে
  var selectedTags = <String>[].obs; // ইউজার কি কি ট্যাগ সিলেক্ট করেছে
  var isLoading = false.obs;

  final commentController = TextEditingController();

  // ডামি ট্যাগ লিস্ট (কুইক ফিডব্যাকের জন্য)
  final List<String> feedbackTags = [
    "Punctual",
    "Professional",
    "Good Value",
    "Clean",
    "Expert",
    "Polite"
  ];

  // ১. রেটিং সেট করা
  void setRating(double value) {
    rating.value = value;
  }

  // ২. ট্যাগ টগল করা (সিলেক্ট/আনসিলেক্ট)
  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  // ৩. রিভিউ সাবমিট করা
  void submitReview() async {
    if (rating.value == 0) {
      Get.snackbar("Rating Required", "Please give a star rating first.",
          backgroundColor: Colors.orange, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // ফেক API কল

    // সফল হওয়ার পর
    isLoading.value = false;

    Get.back(); // আগের পেজে ফিরে যাওয়া
    Get.snackbar(
        "Thank You!",
        "Your review has been submitted.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20)
    );
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/app/modules/home/search/search_view.dart';
import '../../../../utils/app_colors.dart';
import '../booking/cart/cart_view.dart';
import '../notifications/notification_view.dart';
import '../order/my_orders_view.dart';
import '../profile/profile_view.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    // স্ক্রিন সাইজ অনুযায়ী রেসপন্সিভ ভ্যালু বের করা
    var size = MediaQuery.of(context).size;
    var isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. Fixed Header (Location & Profile) ---
            _buildHeader(),

            // --- Scrollable Body ---
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 2. Search Bar ---
                    _buildSearchBar(),

                    const SizedBox(height: 20),

                    // --- 3. Safety Banner ---
                    _buildSafetyBanner(size.width),

                    const SizedBox(height: 25),

                    // --- 4. Categories Grid (Responsive) ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          "All Services",
                          style: GoogleFonts.poppins(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                    const SizedBox(height: 15),

                    _buildCategoryGrid(controller, isTablet),

                    const SizedBox(height: 25),

                    // --- 5. Offer Banners Slider ---
                    _buildBannerSlider(controller, size.width),

                    const SizedBox(height: 30),

                    // --- 6. Most Booked Section ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Most Booked",
                              style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 20 : 18,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          Text(
                              "See all",
                              style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600
                              )
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    _buildPopularServicesList(controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets for Clean Code ---

// --- Updated Header (Custom App Bar) ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // --- 1. Left Side: Location / Greeting ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Current Location",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        "Mirpur 10, Dhaka",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 20)
                  ],
                ),
              ],
            ),
          ),

          // --- 2. Right Side: Action Buttons ---
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Orders Icon
              _buildActionButton(
                icon: Icons.receipt_long_rounded,
                onTap: () => Get.to(() => const MyOrdersView()),
              ),
              const SizedBox(width: 10),

              // Cart Icon (With Badge)
              Stack(
                children: [
                  _buildActionButton(
                    icon: Icons.shopping_bag_outlined,
                    onTap: () => Get.to(() => const CartView(), transition: Transition.rightToLeft),
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 10),

              // Notification Icon
              _buildActionButton(
                icon: Icons.notifications_none_rounded,
                onTap: () => Get.to(() => const NotificationView()), // পেজ লিংক
              ),
              const SizedBox(width: 12),

              // --- Profile Avatar ---
              GestureDetector(
                onTap: () => Get.to(() => const ProfileView()),
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/user_avatar.png"), // আপনার ইমেজ না থাকলে নিচে আইকন ফলব্যাক দেখুন
                      fit: BoxFit.cover,
                    ),
                  ),
                  // যদি ইমেজ না থাকে, এই চাইল্ডটি আনকমেন্ট করুন:
                  // child: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Helper Widget for Actions ---
  Widget _buildActionButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade50, // খুব হালকা ব্যাকগ্রাউন্ড
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, color: Colors.black87, size: 22),
      ),
    );
  }
  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        // সার্চ স্ক্রিনে নেভিগেট করা (Smooth Transition সহ)
        Get.to(() => const SearchView(), transition: Transition.fadeIn);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Search for 'AC Repair'",
                style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSafetyBanner(double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, color: Colors.green, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "100% Safe & Hygienic",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)
                ),
                Text(
                    "Professionals wear masks & gloves",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade700)
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(HomeController controller, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // রেসপন্সিভ কলাম সংখ্যা নির্ধারণ (মোবাইলে ৪, ট্যাবলেটে ৬)
        int crossAxisCount = isTablet ? 6 : 4;

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 15,
            mainAxisSpacing: 20,
            childAspectRatio: 0.75, // হাইট ও উইডথ এর রেশিও
          ),
          itemBuilder: (context, index) {
            var cat = controller.categories[index];
            return GestureDetector(
              onTap: () => controller.onCategoryClick(cat['name']),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cat['color'],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(cat['icon'], color: AppColors.textBlack, size: 28),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat['name'],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.2
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBannerSlider(HomeController controller, double screenWidth) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        itemCount: controller.banners.length,
        itemBuilder: (context, index) {
          var banner = controller.banners[index];
          return Container(
            width: screenWidth * 0.75, // স্ক্রিনের ৭৫% জায়গা নিবে
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: banner['color'],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("OFFER", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        banner['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                          banner['subtitle'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: 12)
                      ),
                    ],
                  ),
                ),
                // ডামি ইমেজ/আইকন
                Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.5),
                    child: const Icon(Icons.local_offer_rounded, color: Colors.black45),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularServicesList(HomeController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.popularServices.length,
      itemBuilder: (context, index) {
        var service = controller.popularServices[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Image Placeholder
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(service['image'], size: 40, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 15),

              // Service Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        service['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(service['rating'], style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      service['price'],
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),

              // Add Button
              InkWell(
                onTap: () {}, // Add to Cart logic
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)],
                  ),
                  child: Text(
                      "Add",
                      style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      )
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
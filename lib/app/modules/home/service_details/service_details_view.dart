import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'service_details_controller.dart';

// ==========================================
// MAIN VIEW
// ==========================================
class ServiceDetailsView extends StatelessWidget {
  const ServiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceArg = (Get.arguments as Map<String, dynamic>?);
    
    // সেফটি চেক: যদি আর্গুমেন্ট না থাকে
    if (serviceArg == null) {
      return const Scaffold(body: Center(child: Text("No service data found")));
    }

    // কন্ট্রোলার ইনিশিয়ালাইজেশন (শুধুমাত্র একবার)
    final c = Get.put(ServiceDetailsController(service: serviceArg));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            const _Navbar(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // রেস্পন্সিভ লেআউট লজিক
                  if (constraints.maxWidth > 900) {
                    return _DesktopLayout(c: c);
                  } else {
                    return _MobileLayout(c: c);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      // মোবাইল ডিভাইসের জন্য ফিক্সড বটম কার্ট বার
      bottomNavigationBar: MediaQuery.of(context).size.width <= 900 
          ? _MobileBottomCart(c: c) 
          : null,
    );
  }
}

// ==========================================
// 1. DESKTOP LAYOUT
// ==========================================
class _DesktopLayout extends StatelessWidget {
  final ServiceDetailsController c;
  const _DesktopLayout({required this.c});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // বাম পাশের সাইডবার
              SizedBox(width: 300, child: _LeftSidebar(c: c)),
              const SizedBox(width: 24),

              // মাঝখানের কন্টেন্ট
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DynamicHeroBanner(c: c, isMobile: false),
                        const SizedBox(height: 24),
                        _MainContentList(c: c),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // ডান পাশের সাইডবার (Cart Summary & Promise)
              SizedBox(width: 320, child: _RightSidebar(c: c)),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. MOBILE LAYOUT
// ==========================================
class _MobileLayout extends StatelessWidget {
  final ServiceDetailsController c;
  const _MobileLayout({required this.c});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DynamicHeroBanner(c: c, isMobile: true),
          const SizedBox(height: 20),

          // ক্যাটাগরি সিলেক্টর
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select a service",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textBlack),
                ),
                const SizedBox(height: 12),
                _MobileCategorySelector(c: c),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // মেইন লিস্ট
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _MainContentList(c: c),
          ),

          const SizedBox(height: 30),
          
          // গ্যারান্টি সেকশন
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _RightSidebarContentOnly(),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. DYNAMIC HERO BANNER
// ==========================================
class _DynamicHeroBanner extends StatelessWidget {
  final ServiceDetailsController c;
  final bool isMobile;
  const _DynamicHeroBanner({required this.c, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = c.currentBannerData;
      // ডাটা না থাকলে ডিফল্ট কালার ও আইকন সেট করা
      final bgColor = (data['color'] as Color?) ?? AppColors.primary;
      final bullets = (data['bullets'] as List<String>?) ?? [];
      final icon = (data['icon'] as IconData?) ?? Icons.cleaning_services;

      return Container(
        width: double.infinity,
        height: isMobile ? null : 250,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: isMobile ? const BorderRadius.vertical(bottom: Radius.circular(24)) : BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: bgColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (data['title'] ?? "").toString(),
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 22 : 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...bullets.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                          child: const Icon(Icons.check, color: Colors.white, size: 12),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            b,
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: Icon(icon, color: Colors.white38, size: 80)),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

// ==========================================
// 4. MAIN CONTENT LIST (Packages)
// ==========================================
class _MainContentList extends StatelessWidget {
  final ServiceDetailsController c;
  const _MainContentList({required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = c.packages;
      final idx = c.selectedItemIndex.value;
      // বর্তমানে সিলেক্ট করা ক্যাটাগরির টাইটেল
      final currentTitle = (c.items.isNotEmpty && idx < c.items.length) 
          ? c.items[idx]["title"].toString() 
          : "Services";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentTitle,
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textBlack),
          ),
          const SizedBox(height: 16),

          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text("No services available.", style: GoogleFonts.poppins(color: AppColors.textGrey)),
            ),

          ...list.map((p) => _ProductRow(p: p, c: c)),
        ],
      );
    });
  }
}

// ==========================================
// 5. PRODUCT ROW (Single Service Card)
// ==========================================
class _ProductRow extends StatelessWidget {
  final Map<String, dynamic> p;
  final ServiceDetailsController c;
  const _ProductRow({required this.p, required this.c});

  @override
  Widget build(BuildContext context) {
    final shortDetails = (p["shortDetails"] as List?) ?? [];

    return InkWell(
      onTap: () => c.openProductDetailsSheet(context, p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Details Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag (e.g. Bestseller)
                  if ((p["tag"] ?? "").toString().isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (p["tag"] ?? "").toString(),
                        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange[800]),
                      ),
                    ),

                  Text(
                    (p["title"] ?? "").toString(),
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textBlack),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        "${p["rating"]} (${p["reviews"]})",
                        style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Text(
                    (p["priceStr"] ?? "").toString(),
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),

                  ...shortDetails.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 4, color: AppColors.textLight),
                        const SizedBox(width: 8),
                        Text(d.toString(), style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGrey)),
                      ],
                    ),
                  )),
                  
                  const SizedBox(height: 8),
                  Text("View Details", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Image & Add Button
            Column(
              children: [
                Container(
                  height: 90, width: 90,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: BorderRadius.circular(12),
                    // ডিফল্ট ইমেজ বা প্লেসহোল্ডার
                    image: const DecorationImage(
                      image: AssetImage("assets/images/service_man.jpg"), 
                      fit: BoxFit.cover,
                    ),
                  ),
                  // ইমেজ না থাকলে আইকন দেখাবে
                  child: const Icon(Icons.image_not_supported, color: Colors.transparent), 
                ),
                const SizedBox(height: 10),

                // Add Button
                InkWell(
                  onTap: () => c.quickAdd(p),
                  child: Container(
                    width: 90,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.inputBorder),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "ADD +",
                        style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
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
  }
}

// ==========================================
// 6. LEFT SIDEBAR (Desktop Only)
// ==========================================
class _LeftSidebar extends StatelessWidget {
  final ServiceDetailsController c;
  const _LeftSidebar({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            c.title,
            style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textBlack),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 18, color: AppColors.secondary),
              const SizedBox(width: 6),
              Text(
                "${c.rating.toStringAsFixed(1)} (${c.bookings} Bookings)",
                style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGrey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          Text("Categories", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
          const SizedBox(height: 12),

          Obx(() {
            final idx = c.selectedItemIndex.value;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(c.items.length, (i) {
                final it = c.items[i];
                final selected = idx == i;

                return InkWell(
                  onTap: () => c.selectItem(i),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? AppColors.primary : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected ? Icons.radio_button_checked : Icons.radio_button_off,
                          size: 16,
                          color: selected ? AppColors.primary : AppColors.textLight,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          (it["title"] ?? "").toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 13, 
                            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                            color: selected ? AppColors.primary : AppColors.textBlack
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

// ==========================================
// 7. MOBILE CATEGORY SELECTOR
// ==========================================
class _MobileCategorySelector extends StatelessWidget {
  final ServiceDetailsController c;
  const _MobileCategorySelector({required this.c});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() {
        final idx = c.selectedItemIndex.value;
        return Row(
          children: List.generate(c.items.length, (i) {
            final item = c.items[i];
            final isSelected = idx == i;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () => c.selectItem(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.inputBorder),
                  ),
                  child: Text(
                    (item["title"] ?? "").toString(),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isSelected ? Colors.white : AppColors.textBlack,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

// ==========================================
// 8. RIGHT SIDEBAR (Cart Summary & Promise)
// ==========================================
class _RightSidebar extends StatelessWidget {
  final ServiceDetailsController c;
  const _RightSidebar({required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cart Summary Button
        Obx(() {
          final total = c.totalCartPrice;
          return Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))
              ],
            ),
            child: ElevatedButton(
              onPressed: () => c.openCartSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Row(
                children: [
                  Text(
                    "SAR $total",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Spacer(),
                  Text("View Cart", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 20),

        // Promise Box
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 22),
                  const SizedBox(width: 10),
                  Text("Our Promise", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              _p("Verified Professionals"),
              _p("Hassle Free Booking"),
              _p("Transparent Pricing"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _p(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        const Icon(Icons.check_circle, size: 16, color: AppColors.secondary),
        const SizedBox(width: 12),
        Text(t, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textBlack)),
      ],
    ),
  );
}

// ==========================================
// 9. RIGHT SIDEBAR CONTENT (Mobile Only)
// ==========================================
class _RightSidebarContentOnly extends StatelessWidget {
  const _RightSidebarContentOnly();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Service Guarantee", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _p("Verified Professionals"),
          _p("Hassle Free Booking"),
          _p("Transparent Pricing"),
        ],
      ),
    );
  }

  Widget _p(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        const Icon(Icons.check_circle, size: 18, color: AppColors.secondary),
        const SizedBox(width: 10),
        Text(t, style: GoogleFonts.poppins(fontSize: 13)),
      ],
    ),
  );
}

// ==========================================
// 10. MOBILE BOTTOM CART
// ==========================================
class _MobileBottomCart extends StatelessWidget {
  final ServiceDetailsController c;
  const _MobileBottomCart({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => c.openCartSheet(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      "SAR ${c.totalCartPrice}",
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textBlack),
                    )),
                    Text("View Cart", style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => c.openCartSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Proceed", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 11. CART BOTTOM SHEET
// ==========================================
class CartBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  const CartBottomSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ServiceDetailsController>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                const Icon(Icons.shopping_bag, color: AppColors.primary),
                const SizedBox(width: 10),
                Text("Your Cart", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
              ],
            ),
          ),
          const Divider(),
          
          Expanded(
            child: Obx(() {
              if (c.cartItems.isEmpty) return const Center(child: Text("Cart is empty"));
              final keys = c.cartItems.keys.toList();
              return ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: keys.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) => _CartItemRow(itemKey: keys[index], item: c.cartItems[keys[index]]!, c: c),
              );
            }),
          ),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total"),
                      Obx(() => Text("SAR ${c.totalCartPrice}", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: c.checkout,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: const Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final String itemKey;
  final Map<String, dynamic> item;
  final ServiceDetailsController c;
  const _CartItemRow({required this.itemKey, required this.item, required this.c});

  @override
  Widget build(BuildContext context) {
    final title = (item['title'] ?? '').toString();
    final price = (item['priceInt'] ?? 0) as int;
    final qty = (item['quantity'] ?? 0) as int;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("SAR $price", style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: () => c.updateCartQty(itemKey, qty - 1), icon: const Icon(Icons.remove_circle_outline, color: AppColors.textGrey)),
              Text("$qty", style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => c.updateCartQty(itemKey, qty + 1), icon: const Icon(Icons.add_circle, color: AppColors.primary)),
            ],
          )
        ],
      ),
    );
  }
}

// ==========================================
// 12. PRODUCT DETAIL SHEET
// ==========================================
class ProductDetailSheet extends StatelessWidget {
  final ScrollController scrollController;
  const ProductDetailSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ServiceDetailsController>();
    return Obx(() {
      final prod = c.selectedProductForSheet.value;
      if (prod == null) return const SizedBox.shrink();
      
      final currentQty = c.sheetTempQty.value;
      final price = (prod["priceInt"] ?? 0) as int;

      return Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          children: [
            Align(alignment: Alignment.centerRight, child: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close))),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((prod["title"] ?? "").toString(), style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text((prod["description"] ?? "").toString(), style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Qty
                  Row(
                    children: [
                      IconButton(onPressed: c.decrementSheetQty, icon: const Icon(Icons.remove)),
                      Text("$currentQty", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: c.incrementSheetQty, icon: const Icon(Icons.add)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: c.confirmSheetSelection,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: Text(currentQty == 0 ? "Remove" : "Add (SAR ${price * currentQty})", style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

// ==========================================
// 13. NAVBAR
// ==========================================
class _Navbar extends StatelessWidget {
  const _Navbar();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
      color: Colors.white,
      child: Row(
        children: [
          if (isMobile) IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
          Text("Willko Service", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          const Icon(Icons.search),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'service_details_controller.dart';

// --- Theme Colors ---
const kUcPurple = Color(0xFF6C45E5);
const kUcGreen = Color(0xFF0F9D58);
const kUcTextBlack = Color(0xFF212121);
const kUcTextGrey = Color(0xFF757575);

class ServiceDetailsView extends StatelessWidget {
  const ServiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceArg = (Get.arguments as Map<String, dynamic>?);
    if (serviceArg == null) {
      return const Scaffold(body: Center(child: Text("No data")));
    }

    // Initialize Controller
    final c = Get.put(ServiceDetailsController(service: serviceArg));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _Navbar(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive Breakpoint
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
      bottomNavigationBar: MediaQuery.of(context).size.width <= 900
          ? _MobileBottomCart(c: c)
          : null,
    );
  }
}

// ==========================================
// DESKTOP LAYOUT
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
              // Left: Selector
              SizedBox(width: 300, child: _LeftSidebar(c: c)),
              const SizedBox(width: 24),

              // Middle: Dynamic Content
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Single Dynamic Banner
                        _DynamicHeroBanner(c: c, isMobile: false),
                        const SizedBox(height: 24),
                        // ✅ Products List
                        _MainContentList(c: c),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Right: Cart
              const SizedBox(width: 320, child: _RightSidebar()),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// MOBILE LAYOUT
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
          // ✅ Mobile Banner
          _DynamicHeroBanner(c: c, isMobile: true),

          const SizedBox(height: 16),

          // Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select a service",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _MobileCategorySelector(c: c),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Products
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _MainContentList(c: c),
          ),

          const SizedBox(height: 30),
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
// ✅ DYNAMIC SINGLE BANNER (NO SLIDER)
// ==========================================
class _DynamicHeroBanner extends StatelessWidget {
  final ServiceDetailsController c;
  final bool isMobile;
  const _DynamicHeroBanner({required this.c, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = c.currentBannerData;
      final bgColor = data['color'] as Color;
      final bullets = data['bullets'] as List<String>;
      final icon = data['icon'] as IconData;

      return Container(
        width: double.infinity,
        height: isMobile ? null : 250,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: isMobile
              ? BorderRadius.zero
              : BorderRadius.circular(16),
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
                    data['title'],
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 22 : 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...bullets.map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              b,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                  child: Center(
                    child: Icon(icon, color: Colors.white38, size: 80),
                  ),
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
// PRODUCT LIST
// ==========================================
class _MainContentList extends StatelessWidget {
  final ServiceDetailsController c;
  const _MainContentList({required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = c.packages;
      // Get current category title
      final currentTitle = c.items[c.selectedItemIndex.value]["title"];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentTitle,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: kUcTextBlack,
            ),
          ),
          const SizedBox(height: 16),

          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "No services available for this category",
                style: GoogleFonts.poppins(color: kUcTextGrey),
              ),
            ),

          ...list.map((p) => _ProductRow(p: p, c: c)).toList(),
        ],
      );
    });
  }
}

// ==========================================
// PRODUCT ROW ITEM
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
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((p["tag"] ?? "").toString().isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: kUcGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (p["tag"] ?? "").toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: kUcGreen,
                        ),
                      ),
                    ),

                  Text(
                    (p["title"] ?? "").toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: kUcTextBlack,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          size: 8,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${p["rating"]} (${p["reviews"]})",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: kUcTextGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    (p["priceStr"] ?? "").toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kUcTextBlack,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ...shortDetails.map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        "• ${d.toString()}",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: kUcTextGrey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    "View details",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: kUcPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Image + Add Button
            Column(
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.image, color: Colors.black12),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "Add",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: kUcPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                if ((p["optionsText"] ?? "").toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    p["optionsText"],
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// DESKTOP LEFT SIDEBAR
// ==========================================
class _LeftSidebar extends StatelessWidget {
  final ServiceDetailsController c;
  const _LeftSidebar({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            c.title,
            style: GoogleFonts.poppins(
              fontSize: 28,
              height: 1.05,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: kUcPurple),
              const SizedBox(width: 6),
              Text(
                "${c.rating.toStringAsFixed(2)} (${c.bookings})",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: kUcTextGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 14),
          Text(
            "Select a service",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kUcTextGrey,
            ),
          ),
          const SizedBox(height: 12),

          Obx(() {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(c.items.length, (i) {
                final it = c.items[i];
                final selected = c.selectedItemIndex.value == i;
                return InkWell(
                  onTap: () => c.selectItem(i),
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected
                          ? kUcPurple.withOpacity(0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? kUcPurple : Colors.grey.shade200,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 16,
                            color: Colors.black26,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          it["title"],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: kUcTextBlack,
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
// MOBILE CATEGORY SELECTOR
// ==========================================
class _MobileCategorySelector extends StatelessWidget {
  final ServiceDetailsController c;
  const _MobileCategorySelector({required this.c});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: List.generate(c.items.length, (i) {
            final item = c.items[i];
            final isSelected = c.selectedItemIndex.value == i;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () => c.selectItem(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? kUcPurple : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? kUcPurple : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        item["title"],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isSelected ? Colors.white : kUcTextBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ==========================================
// RIGHT SIDEBAR (Desktop)
// ==========================================
class _RightSidebar extends StatelessWidget {
  const _RightSidebar();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: Colors.black26,
              ),
              const SizedBox(height: 10),
              Text(
                "No items in your cart",
                style: GoogleFonts.poppins(
                  color: kUcTextGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _RightSidebarContentOnly(),
      ],
    );
  }
}

class _RightSidebarContentOnly extends StatelessWidget {
  const _RightSidebarContentOnly();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "UC Promise",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
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
        const Icon(Icons.check, size: 16, color: kUcTextBlack),
        const SizedBox(width: 10),
        Text(t, style: GoogleFonts.poppins(fontSize: 13)),
      ],
    ),
  );
}

// ==========================================
// ==========================================
// ✅ FIXED MOBILE BOTTOM CART
// ==========================================
class _MobileBottomCart extends StatelessWidget {
  final ServiceDetailsController c;
  const _MobileBottomCart({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ FIX: Used 'totalCartItems' instead of 'sheetQuantity'
                Obx(
                      () => Text(
                    "${c.totalCartItems} Items",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "View Cart",
                  style: GoogleFonts.poppins(
                    color: kUcPurple,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kUcPurple,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Proceed",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ==========================================
// PRODUCT DETAILS SHEET (Reused)
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

      final priceInt = (prod["priceInt"] ?? 0) as int;
      final currentQty = c.sheetTempQty.value;
      final totalPrice = priceInt * (currentQty == 0 ? 1 : currentQty); // Show base price if 0

      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // --- 1. Header (Close Button) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                      ),
                      child: const Icon(Icons.close, size: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. Scrollable Content ---
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      (prod["title"] ?? "").toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: kUcTextBlack,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: kUcTextBlack),
                          const SizedBox(width: 6),
                          Text(
                            "${prod["rating"]} (${prod["reviews"]})",
                            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(thickness: 8, color: Color(0xFFF5F5F7)), // Thick Divider
                    const SizedBox(height: 24),

                    // Description
                    _sheetTitle("About the service"),
                    Text(
                      (prod["description"] ?? "No description available.").toString(),
                      style: GoogleFonts.poppins(fontSize: 14, color: kUcTextGrey, height: 1.6),
                    ),
                    const SizedBox(height: 32),

                    // ✅ How it works Section
                    if (prod["howItWorks"] != null) ...[
                      _sheetTitle("How it works"),
                      _HowItWorksTimeline(steps: prod["howItWorks"]),
                      const SizedBox(height: 32),
                    ],

                    // ✅ Reviews Section
                    if (prod["ratingBreakdown"] != null) ...[
                      _sheetTitle("Reviews and Ratings"),
                      _RatingBreakdown(data: prod["ratingBreakdown"]),
                    ],

                    const SizedBox(height: 100), // Bottom padding for footer
                  ],
                ),
              ),
            ),

            // --- 3. Sticky Footer (Add/Quantity Logic) ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
              ),
              child: Row(
                children: [
                  // Quantity Selector
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        _qtyBtn(Icons.remove, () => c.decrementSheetQty(), currentQty > 0 ? kUcPurple : Colors.grey),
                        SizedBox(
                          width: 40,
                          child: Center(
                            child: Text(
                              "$currentQty",
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: kUcPurple),
                            ),
                          ),
                        ),
                        _qtyBtn(Icons.add, () => c.incrementSheetQty(), kUcPurple),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Done Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: currentQty > 0 ? () => c.confirmSheetSelection() : null, // Disable if 0
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kUcPurple,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Done",
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                            if (currentQty > 0)
                              Text(
                                "SAR $totalPrice",
                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _sheetTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: kUcTextBlack),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 45,
        height: double.infinity,
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}

class _HowItWorksTimeline extends StatelessWidget {
  final List<dynamic> steps;
  const _HowItWorksTimeline({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline graphics
              Column(
                children: [
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EFFF), // Light purple bg
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 14, color: kUcPurple),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Text Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (step['title'] ?? "").toString(),
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: kUcTextBlack),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        (step['desc'] ?? "").toString(),
                        style: GoogleFonts.poppins(color: kUcTextGrey, fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _RatingBreakdown extends StatelessWidget {
  final Map<String, dynamic> data;
  const _RatingBreakdown({required this.data});

  @override
  Widget build(BuildContext context) {
    final counts = (data['counts'] as List).cast<int>();
    final total = counts.fold(0, (sum, item) => sum + item);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Header
        Row(
          children: [
            const Icon(Icons.star, size: 32, color: kUcTextBlack),
            const SizedBox(width: 8),
            Text(
              (data['average'] ?? "").toString(),
              style: GoogleFonts.poppins(fontSize: 42, fontWeight: FontWeight.w700, color: kUcTextBlack, height: 1),
            ),
          ],
        ),
        Text(
          "${data['total']} reviews",
          style: GoogleFonts.poppins(fontSize: 14, color: kUcTextGrey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),

        // Progress Bars (5 to 1)
        ...List.generate(5, (index) {
          final star = 5 - index;
          final count = counts[index];
          final percentage = total == 0 ? 0.0 : count / total;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                  child: Text("$star", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.star, size: 12, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: Colors.grey.shade100,
                      color: kUcTextBlack, // UC typically uses black/dark grey for bars
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 40,
                  child: Text(
                    "$count",
                    textAlign: TextAlign.end,
                    style: GoogleFonts.poppins(fontSize: 12, color: kUcTextGrey),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _Navbar extends StatelessWidget {
  const _Navbar();
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (isMobile) ...[
            InkWell(
                onTap: () => Get.back(),
                child: const Icon(Icons.arrow_back, color: Colors.black)
            ),
            const SizedBox(width: 12),
          ],

          // Brand Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              "WS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 10),

          if (!isMobile)
            Text(
              "Willko\nService",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1.1,
                color: kUcTextBlack,
              ),
            ),

          const Spacer(),

          // Right Icons
          if (isMobile)
            const Icon(Icons.search, color: Colors.black87)
          else ...[
            Container(
              width: 240,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text("Search services...", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(width: 24),
            const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
          ],
        ],
      ),
    );
  }
}
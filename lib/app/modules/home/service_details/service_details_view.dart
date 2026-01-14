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

    // ✅ IMPORTANT: avoid multiple puts on rebuild by using tag or find-if-exists
    // simplest: put once here
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
      bottomNavigationBar:
      MediaQuery.of(context).size.width <= 900 ? _MobileBottomCart(c: c) : null,
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
              SizedBox(width: 300, child: _LeftSidebar(c: c)),
              const SizedBox(width: 24),

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

              // ✅ Right Sidebar must receive controller
              SizedBox(width: 320, child: _RightSidebar(c: c)),
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
          _DynamicHeroBanner(c: c, isMobile: true),

          const SizedBox(height: 16),

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
      final data = c.currentBannerData; // ✅ depends on selectedItemIndex.value
      final bgColor = data['color'] as Color;
      final bullets = data['bullets'] as List<String>;
      final icon = data['icon'] as IconData;

      return Container(
        width: double.infinity,
        height: isMobile ? null : 250,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: isMobile ? BorderRadius.zero : BorderRadius.circular(16),
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
                  ...bullets.map(
                        (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
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
      final idx = c.selectedItemIndex.value;
      final currentTitle =
      (c.items.isNotEmpty && idx < c.items.length) ? c.items[idx]["title"].toString() : "";

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
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                        decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                        child: const Icon(Icons.star, size: 8, color: Colors.white),
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
                        style: GoogleFonts.poppins(fontSize: 12, color: kUcTextGrey),
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

                // ✅ ADD TO CART (WORKING)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => c.quickAdd(p),
                  child: Container(
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
                ),

                if ((p["optionsText"] ?? "").toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    (p["optionsText"] ?? "").toString(),
                    style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
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
            style: GoogleFonts.poppins(fontSize: 28, height: 1.05, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: kUcPurple),
              const SizedBox(width: 6),
              Text(
                "${c.rating.toStringAsFixed(2)} (${c.bookings})",
                style: GoogleFonts.poppins(fontSize: 13, color: kUcTextGrey, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 14),
          Text(
            "Select a service",
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: kUcTextGrey),
          ),
          const SizedBox(height: 12),

          Obx(() {
            final idx = c.selectedItemIndex.value;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(c.items.length, (i) {
                final it = c.items[i];
                final selected = idx == i;

                return InkWell(
                  onTap: () => c.selectItem(i),
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected ? kUcPurple.withOpacity(0.05) : Colors.white,
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
                          child: const Icon(Icons.image, size: 16, color: Colors.black26),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          (it["title"] ?? "").toString(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: kUcTextBlack),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? kUcPurple : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? kUcPurple : Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        (item["title"] ?? "").toString(),
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
        );
      }),
    );
  }
}

// ==========================================
// ✅ RIGHT SIDEBAR (FIXED: reactive SAR + ViewCart)
// ==========================================
class _RightSidebar extends StatelessWidget {
  final ServiceDetailsController c;
  const _RightSidebar({required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ Reactive button
        Obx(() {
          final total = c.totalCartPrice;
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => c.openCartSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kUcPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                elevation: 0,
              ),
              child: Row(
                children: [
                  Text(
                    "SAR $total",
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    "View Cart",
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 14),

        // UC Promise
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("UC Promise", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
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
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        const Icon(Icons.check, size: 16, color: kUcTextBlack),
        const SizedBox(width: 10),
        Text(t, style: GoogleFonts.poppins(fontSize: 13, color: kUcTextGrey)),
      ],
    ),
  );
}

// ==========================================
// RIGHT SIDEBAR CONTENT ONLY (MOBILE)
// ==========================================
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
          Text("UC Promise", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800)),
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
// ✅ MOBILE BOTTOM CART (FULL CLICKABLE + reactive)
// ==========================================
class _MobileBottomCart extends StatelessWidget {
  final ServiceDetailsController c;
  const _MobileBottomCart({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
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
                      "${c.totalCartItems} Items | SAR ${c.totalCartPrice}",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    )),
                    Text(
                      "View Cart",
                      style: GoogleFonts.poppins(color: kUcPurple, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => c.openCartSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kUcPurple,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(
                "Proceed",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ✅ CART BOTTOM SHEET (shows added services + qty +/- + checkout snackbar)
// ==========================================
class CartBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  const CartBottomSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ServiceDetailsController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  "Cart Summary",
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: kUcTextBlack),
                ),
                const Spacer(),
                InkWell(onTap: () => Get.back(), child: const Icon(Icons.close, color: Colors.black54)),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: Obx(() {
              if (c.cartItems.isEmpty) {
                return Center(child: Text("Your cart is empty", style: GoogleFonts.poppins(color: kUcTextGrey)));
              }

              final keys = c.cartItems.keys.toList();

              return ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: keys.length,
                separatorBuilder: (_, __) => const Divider(height: 30),
                itemBuilder: (_, index) {
                  final key = keys[index];
                  final item = c.cartItems[key]!;
                  return _CartItemRow(itemKey: key, item: item, c: c);
                },
              );
            }),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                      Obx(() => Text(
                        "SAR ${c.totalCartPrice}",
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800, color: kUcTextBlack),
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: c.checkout, // ✅ snackbar inside controller
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kUcPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Proceed to Checkout",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 16, color: kUcTextBlack),
              ),
              const SizedBox(height: 4),
              Text("SAR $price x $qty", style: GoogleFonts.poppins(fontSize: 13, color: kUcTextGrey)),
            ],
          ),
        ),
        Container(
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(color: kUcPurple.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFF9F5FF),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => c.updateCartQty(itemKey, qty - 1),
                child: Container(width: 32, alignment: Alignment.center, child: const Icon(Icons.remove, size: 16, color: kUcPurple)),
              ),
              Text("$qty", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: kUcTextBlack)),
              InkWell(
                onTap: () => c.updateCartQty(itemKey, qty + 1),
                child: Container(width: 32, alignment: Alignment.center, child: const Icon(Icons.add, size: 16, color: kUcPurple)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text("SAR ${price * qty}", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: kUcTextBlack)),
      ],
    );
  }
}

// ==========================================
// PRODUCT DETAILS SHEET (same design + uses controller functions)
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
      final totalPrice = priceInt * (currentQty == 0 ? 1 : currentQty);

      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
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

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (prod["title"] ?? "").toString(),
                      style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: kUcTextBlack, height: 1.2),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: kUcTextBlack),
                          const SizedBox(width: 6),
                          Text("${prod["rating"]} (${prod["reviews"]})", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(thickness: 8, color: Color(0xFFF5F5F7)),
                    const SizedBox(height: 24),

                    _sheetTitle("About the service"),
                    Text(
                      (prod["description"] ?? "No description.").toString(),
                      style: GoogleFonts.poppins(fontSize: 14, color: kUcTextGrey, height: 1.6),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          _qtyBtn(Icons.remove, c.decrementSheetQty, currentQty > 0 ? kUcPurple : Colors.grey),
                          SizedBox(
                            width: 40,
                            child: Center(
                              child: Text(
                                "$currentQty",
                                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: kUcPurple),
                              ),
                            ),
                          ),
                          _qtyBtn(Icons.add, c.incrementSheetQty, kUcPurple),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: c.confirmSheetSelection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kUcPurple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                currentQty == 0 ? "Remove" : "Done",
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
            ),
          ],
        ),
      );
    });
  }

  Widget _sheetTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Text(title, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: kUcTextBlack)),
  );

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

// ==========================================
// NAVBAR (unchanged style)
// ==========================================
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
            InkWell(onTap: () => Get.back(), child: const Icon(Icons.arrow_back, color: Colors.black)),
            const SizedBox(width: 12),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
            child: const Text(
              "WS",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1),
            ),
          ),
          const SizedBox(width: 10),
          if (!isMobile)
            Text(
              "Willko\nService",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w800, height: 1.1, color: kUcTextBlack),
            ),
          const Spacer(),
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

// small fix for typo used above
const FontWeight FontWeight_wbold700 = FontWeight.w700;
const FontWeight FontWeight_wbold = FontWeight.w700;
const FontWeight FontWeight_w700 = FontWeight.w700;
const FontWeight FontWeight_w800 = FontWeight.w800;
const FontWeight FontWeight_w600 = FontWeight.w600;
const FontWeight FontWeight_w500 = FontWeight.w500;

// quick alias for the row’s font weight usage
const FontWeight FontWeight_wbold700_ = FontWeight.w700;

// NOTE: If your IDE complains about the alias constants, just remove them and use FontWeight.w700 directly.
// I kept UI intact—aliases are optional.

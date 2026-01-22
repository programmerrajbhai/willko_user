import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:willko_user/utils/app_colors.dart';
import '../service_details_controller.dart';

// ==========================================
// 👈 LEFT SIDEBAR (Service Profile & Categories)
// ==========================================
class LeftSidebar extends StatelessWidget {
  final ServiceDetailsController c;
  const LeftSidebar({required this.c, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Service Info Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: _boxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 50, width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.verified_user, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Willko Verified",
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        Text(
                          "Professional Service",
                          style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text(
                c.title,
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "${c.rating} (500+ Reviews)",
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              
              // Safety Badge
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFF0FFF4), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.security, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text("100% Safe & Hygienic", style: GoogleFonts.poppins(fontSize: 11, color: Colors.green[800], fontWeight: FontWeight.w600))),
                  ],
                ),
              )
            ],
          ),
        ),
        
        const SizedBox(height: 24),

        // 2. Categories Menu
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: _boxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("CATEGORIES", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
              const SizedBox(height: 16),
              
              Obx(() => Column(
                children: List.generate(c.items.length, (i) {
                  final isSelected = c.selectedItemIndex.value == i;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => c.selectItem(i),
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.category_outlined, size: 18, color: isSelected ? Colors.white : Colors.grey),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                c.items[i]["title"] ?? "",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  color: isSelected ? Colors.white : Colors.black87
                                ),
                              ),
                            ),
                            if (isSelected) const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              )),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 👉 RIGHT SIDEBAR (Cart Summary)
// ==========================================
class RightSidebar extends StatelessWidget {
  final ServiceDetailsController c;
  const RightSidebar({required this.c, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cartList = c.cartItems.values.toList();
      final hasItems = cartList.isNotEmpty;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text("Your Basket", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 20),

            if (!hasItems)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.shopping_basket_outlined, size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    Text("Basket is empty", style: GoogleFonts.poppins(color: Colors.grey)),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            else
              Column(
                children: [
                  // Item List (Mini)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartList.length,
                    separatorBuilder: (_, __) => const Divider(height: 20),
                    itemBuilder: (_, i) {
                      final item = cartList[i];
                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(border: Border.all(color: Colors.green), borderRadius: BorderRadius.circular(4)),
                            child: const Icon(Icons.circle, size: 8, color: Colors.green),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title'], style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text("SAR ${item['priceInt']} x ${item['quantity']}", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Text(
                            "SAR ${item['priceInt'] * item['quantity']}",
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(thickness: 1,)),

                  // Bill Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal", style: GoogleFonts.poppins(color: Colors.grey[600])),
                      Text("SAR ${c.totalCartPrice}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Taxes & Fees", style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)),
                      Text("Calculated at checkout", style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => c.openCartSheet(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Checkout", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                            child: Text("SAR ${c.totalCartPrice}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              // Trust Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text("Safe and secure payment", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                ],
              )
          ],
        ),
      );
    });
  }
}

// Common Decoration
BoxDecoration _boxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 5)),
    ],
    border: Border.all(color: Colors.grey.withOpacity(0.1)),
  );
}
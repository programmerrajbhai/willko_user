import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CheckoutController>()) {
      Get.put(CheckoutController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: Text("Checkout", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. Order Items List
            _SlideInAnimation(delay: 100, child: _buildServiceItemsList()),
            const SizedBox(height: 24),

            // 2. Contact & Location (Login Logic Added)
            _SlideInAnimation(delay: 200, child: _buildContactAndLocationCard()),
            const SizedBox(height: 24),

            // 3. Schedule
            _SlideInAnimation(delay: 300, child: _buildScheduleCard(context)),
            const SizedBox(height: 24),

            // 4. Payment
            _SlideInAnimation(delay: 400, child: _buildPaymentSection()),
            const SizedBox(height: 24),

            // 5. Bill Summary
            _SlideInAnimation(delay: 500, child: _buildBillSummary()),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _SlideInAnimation(delay: 600, child: _buildBottomBar()),
    );
  }

  // --- 1. Service Items List ---
  Widget _buildServiceItemsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header("ORDER ITEMS"),
        Obx(() => Column(
          children: List.generate(controller.cartItems.length, (index) {
            final item = controller.cartItems[index];
            final raw = item['raw'] ?? {};
            final imageUrl = raw['image_url'] ?? "";

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 60, width: 60,
                      color: Colors.grey.shade100,
                      child: imageUrl.isNotEmpty 
                        ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.image_not_supported, color: Colors.grey))
                        : const Icon(Icons.cleaning_services, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? "Service",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "SAR ${item['priceInt']}",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: Row(
                      children: [
                        _counterBtn(Icons.remove, () => controller.decrementQty(index)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text("${item['quantity']}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                        _counterBtn(Icons.add, () => controller.incrementQty(index)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        )),
      ],
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.all(6), child: Icon(icon, size: 16, color: Colors.black87)),
    );
  }

  // --- 2. Contact & Location Card (Updated for Login Check) ---
  Widget _buildContactAndLocationCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header("CONTACT & LOCATION"),
        Obx(() {
          // 🛑 Case 1: Not Logged In
          if (!controller.isLoggedIn.value) {
            return InkWell(
              onTap: controller.handlePlaceOrder, // Clicking triggers Login Dialog
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Login Required", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.orange[900])),
                          Text("Please login to place your order.", style: GoogleFonts.poppins(fontSize: 12, color: Colors.orange[800])),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
                      child: Text("LOGIN", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
                    )
                  ],
                ),
              ),
            );
          }

          final addr = controller.selectedAddress.value;

          // 🛑 Case 2: Logged In but No Address
          if (addr == null) {
            return InkWell(
              onTap: controller.pickAddress,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.add_location_alt_rounded, color: AppColors.primary, size: 28),
                    const SizedBox(height: 8),
                    Text("Add Delivery Address", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ],
                ),
              ),
            );
          }

          // ✅ Case 3: Logged In & Address Selected (Show User Info)
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
            ),
            child: Column(
              children: [
                // User Info from SharedPrefs
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: controller.userImage.value.isNotEmpty ? NetworkImage(controller.userImage.value) : null,
                      child: controller.userImage.value.isEmpty ? const Icon(Icons.person, size: 20, color: Colors.black) : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.userName.value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(controller.userPhone.value, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
                const Divider(height: 24),
                // Address Info
                InkWell(
                  onTap: controller.pickAddress,
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(addr.addressLine, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                      TextButton(
                        onPressed: controller.pickAddress,
                        child: Text("Change", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // --- 3. Schedule Card ---
  Widget _buildScheduleCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header("SCHEDULE"),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => controller.chooseDate(context),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Date", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                    Obx(() => Text(controller.formattedDate, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14))),
                  ]),
                ),
              ),
              Container(height: 30, width: 1, color: Colors.grey.shade300),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => controller.chooseTime(context),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Time", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                    Obx(() => Text(controller.formattedTime, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14))),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 4. Payment Section ---
  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header("PAYMENT"),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _payOption("Cash on Delivery", Icons.money),
              const Divider(height: 1, indent: 50),
              _payOption("Digital Payment", Icons.credit_card),
            ],
          ),
        ),
      ],
    );
  }

  Widget _payOption(String title, IconData icon) {
    return Obx(() {
      final isSel = controller.selectedPayment.value == title;
      return InkWell(
        onTap: () => controller.selectPaymentMethod(title),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: isSel ? AppColors.primary : Colors.grey),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14))),
              if(isSel) Icon(Icons.check_circle, color: AppColors.primary, size: 20)
            ],
          ),
        ),
      );
    });
  }

  // --- 5. Bill Summary ---
  Widget _buildBillSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header("BILL SUMMARY"),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Obx(() => Column(
            children: [
              _row("Item Total", controller.itemTotal),
              _row("Tax (5%)", controller.taxAndFees),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Payable", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  Text("SAR ${controller.grandTotal.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                ],
              ),
            ],
          )),
        ),
      ],
    );
  }

  Widget _row(String label, double val, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13)),
        Text("SAR ${val.abs().toStringAsFixed(0)}", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: color ?? Colors.black87)),
      ]),
    );
  }

  // --- Bottom Bar ---
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                Obx(() => Text("SAR ${controller.grandTotal.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold))),
              ],
            ),
            const Spacer(),
            Obx(() => ElevatedButton(
              // ✅ Check Login before placing order
              onPressed: controller.isLoading.value ? null : controller.handlePlaceOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: controller.isLoading.value 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text("Place Order", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            )),
          ],
        ),
      ),
    );
  }

  Widget _header(String title) => Padding(padding: const EdgeInsets.only(bottom: 8, left: 4), child: Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1)));
}

// Animation Widget
class _SlideInAnimation extends StatefulWidget {
  final Widget child; final int delay;
  const _SlideInAnimation({required this.child, required this.delay});
  @override State<_SlideInAnimation> createState() => _SState();
}
class _SState extends State<_SlideInAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _c; late Animation<Offset> _o; late Animation<double> _f;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600)); _o = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut)); _f = Tween<double>(begin: 0, end: 1).animate(_c); Future.delayed(Duration(milliseconds: widget.delay), () { if(mounted) _c.forward(); }); }
  @override Widget build(BuildContext context) => FadeTransition(opacity: _f, child: SlideTransition(position: _o, child: widget.child));
  @override void dispose() { _c.dispose(); super.dispose(); }
}
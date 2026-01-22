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
      backgroundColor: const Color(0xFFF8F9FA), // Soft luxurious background
      appBar: AppBar(
        title: Text("Checkout", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Delivery Address
            _SectionHeader(title: "DELIVERY LOCATION"),
            _SlideInAnimation(delay: 100, child: _buildAddressCard()),
            
            const SizedBox(height: 24),

            // 2. Schedule
            _SectionHeader(title: "PREOFERED SLOT"),
            _SlideInAnimation(delay: 200, child: _buildScheduleCard(context)),

            const SizedBox(height: 24),

            // 3. Items
            _SectionHeader(title: "ORDER SUMMARY"),
            _SlideInAnimation(delay: 300, child: _buildOrderItemsList()),

            const SizedBox(height: 24),

            // 4. Payment
            _SectionHeader(title: "PAYMENT METHOD"),
            _SlideInAnimation(delay: 400, child: _buildPaymentSection()),

            const SizedBox(height: 24),

            // 5. Bill Details
            _SectionHeader(title: "BILL DETAILS"),
            _SlideInAnimation(delay: 500, child: _buildBillSummary()),

            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: _SlideInAnimation(delay: 600, child: _buildBottomBar()),
    );
  }

  // --- 1. Address Card (Pro Style) ---
  Widget _buildAddressCard() {
    return Obx(() {
      final addr = controller.selectedAddress.value;
      
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: _proBoxDecoration(),
        child: InkWell(
          onTap: controller.pickAddress,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Box
              Container(
                height: 45, width: 45,
                decoration: BoxDecoration(
                  color: Colors.black, // Active Black
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 16),
              
              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          addr == null ? "Select Address" : "Home", // Label (Home/Work)
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          "CHANGE",
                          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      addr == null ? "Tap to add your delivery location" : addr.addressLine,
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // --- 2. Schedule Card (Split View) ---
  Widget _buildScheduleCard(BuildContext context) {
    return Row(
      children: [
        // Date Picker
        Expanded(
          child: InkWell(
            onTap: () => controller.chooseDate(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: _proBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.calendar_today_rounded, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text("Date", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  ]),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    controller.formattedDate, 
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)
                  )),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Time Picker
        Expanded(
          child: InkWell(
            onTap: () => controller.chooseTime(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: _proBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.access_time_rounded, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text("Time", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  ]),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    controller.formattedTime, 
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)
                  )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- 3. Order Items List ---
  Widget _buildOrderItemsList() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: _proBoxDecoration(),
      child: Obx(() => Column(
        children: List.generate(controller.cartItems.length, (index) {
          final item = controller.cartItems[index];
          final raw = item['raw'] ?? {};
          final isLast = index == controller.cartItems.length - 1;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Image Box
                    Container(
                      height: 55, width: 55,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        image: (raw['image_url'] != null) ? DecorationImage(
                          image: NetworkImage(raw['image_url']), fit: BoxFit.cover
                        ) : null,
                      ),
                      child: (raw['image_url'] == null) 
                        ? const Icon(Icons.category, color: Colors.grey) 
                        : null,
                    ),
                    const SizedBox(width: 16),
                    
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] ?? "Service",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "SAR ${item['priceInt']}",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    // Minimal Counter
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          _iconBtn(Icons.remove, () => controller.decrementQty(index)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("${item['quantity']}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                          _iconBtn(Icons.add, () => controller.incrementQty(index)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (!isLast) Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),
            ],
          );
        }),
      )),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Icon(icon, size: 16, color: Colors.black),
      ),
    );
  }

  // --- 4. Payment Section ---
  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _proBoxDecoration(),
      child: Column(
        children: [
          _buildPaymentOption("Cash on Delivery", Icons.wallet_rounded),
          Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),
          _buildPaymentOption("Digital Payment", Icons.credit_card_rounded),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    return Obx(() {
      final isSelected = controller.selectedPayment.value == title;
      return InkWell(
        onTap: () => controller.selectPaymentMethod(title),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? Colors.black : Colors.grey, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14, 
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.black : Colors.grey.shade700
                  ),
                ),
              ),
              // Custom Radio Circle
              Container(
                height: 20, width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: 2),
                ),
                child: isSelected 
                  ? Center(child: Container(height: 10, width: 10, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)))
                  : null,
              )
            ],
          ),
        ),
      );
    });
  }

  // --- 5. Bill Summary ---
 // --- 5. Bill Summary (Updated: No Taxes) ---
  Widget _buildBillSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _proBoxDecoration(),
      child: Obx(() => Column(
        children: [
          // শুধুমাত্র সাবটোটাল দেখানো হচ্ছে, কারণ কোনো ট্যাক্স নেই
          _billRow("Subtotal", "SAR ${controller.itemTotal.toStringAsFixed(0)}"),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: DottedLineSeparator(),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Amount", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              Text("SAR ${controller.grandTotal.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ],
      )),
    );
  }
  Widget _billRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
        Text(amount, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }

  // --- Bottom Bar ---
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TOTAL", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                Obx(() => Text("SAR ${controller.grandTotal.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black))),
              ],
            ),
            const Spacer(),
            Obx(() => SizedBox(
              height: 52,
              width: 180,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.handlePlaceOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Pro Black Button
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: controller.isLoading.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Place Order", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18)
                      ],
                    ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// --- Reusable Components & Styles ---

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title, 
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 1.2)
      ),
    );
  }
}

BoxDecoration _proBoxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4)),
    ],
    border: Border.all(color: Colors.grey.withOpacity(0.1)),
  );
}

class DottedLineSeparator extends StatelessWidget {
  const DottedLineSeparator({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey.shade300)),
            );
          }),
        );
      },
    );
  }
}

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
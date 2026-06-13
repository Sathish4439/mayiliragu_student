import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/book_store_controller.dart';
import '../models/book_model.dart';

class BookCheckoutView extends StatefulWidget {
  final BookModel book;
  final String format;
  final int quantity;

  const BookCheckoutView({
    super.key,
    required this.book,
    required this.format,
    required this.quantity,
  });

  @override
  State<BookCheckoutView> createState() => _BookCheckoutViewState();
}

class _BookCheckoutViewState extends State<BookCheckoutView> {
  final controller = Get.find<BookStoreController>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController(text: "Tamil Nadu");
  final _pinController = TextEditingController();
  final _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.removeCoupon();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  double get subTotal {
    final price = widget.format == 'HARD_COPY'
        ? (widget.book.priceHardCopy ?? 0.0)
        : (widget.book.priceSoftCopy ?? 0.0);
    return price * widget.quantity;
  }

  double get shippingCharge => widget.format == 'HARD_COPY' ? 50.0 : 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Checkout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product details card
              _buildProductSummary(),
              const SizedBox(height: 20),

              // Shipping Address Form (Only for Hard Copy)
              if (widget.format == 'HARD_COPY') ...[
                const Text("Delivery Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                _buildAddressForm(),
                const SizedBox(height: 20),
              ],

              // Coupons field
              const Text("Offers & Coupons", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 10),
              _buildCouponSection(),
              const SizedBox(height: 20),

              // Order Total details
              const Text("Payment Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 10),
              _buildPaymentSummary(),
              const SizedBox(height: 24),

              // COD note & Place Order Button
              _buildCheckoutActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(
            widget.format == 'HARD_COPY' ? Icons.menu_book : Icons.picture_as_pdf,
            color: AppColors.brandPurple,
            size: 36,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Format: ${widget.format == 'HARD_COPY' ? 'Physical Hard Copy' : 'Digital PDF Soft Copy'}",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  "Quantity: ${widget.quantity}",
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            "₹$subTotal",
            style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandPurple, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildInput(controller: _nameController, hint: "Full Name (e.g. John Doe)"),
          const SizedBox(height: 12),
          _buildInput(controller: _phoneController, hint: "Mobile Number", keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          _buildInput(controller: _streetController, hint: "Flat, House no., Street address"),
          const SizedBox(height: 12),
          _buildInput(controller: _landmarkController, hint: "Landmark (optional)", isRequired: false),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildInput(controller: _cityController, hint: "Town/City")),
              const SizedBox(width: 12),
              Expanded(child: _buildInput(controller: _pinController, hint: "Pincode", keyboardType: TextInputType.number)),
            ],
          ),
          const SizedBox(height: 12),
          _buildInput(controller: _stateController, hint: "State"),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (val) {
        if (isRequired && (val == null || val.trim().isEmpty)) {
          return "$hint is required";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFFAF9FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      style: const TextStyle(fontSize: 13),
    );
  }

  Widget _buildCouponSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Obx(() {
        final couponApplied = controller.appliedCoupon.value != null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    enabled: !couponApplied,
                    decoration: const InputDecoration(
                      hintText: "Enter Coupon Code",
                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(() => TextButton(
                      onPressed: controller.isCouponValidating.value
                          ? null
                          : () {
                              if (couponApplied) {
                                controller.removeCoupon();
                                _couponController.clear();
                              } else {
                                if (_couponController.text.trim().isNotEmpty) {
                                  controller.validateCoupon(_couponController.text.trim(), subTotal);
                                }
                              }
                            },
                      child: Text(
                        couponApplied ? "Remove" : "Apply",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.brandPurple),
                      ),
                    )),
              ],
            ),
            if (controller.couponError.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  controller.couponError.value,
                  style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            if (couponApplied)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  "Coupon ${controller.appliedCoupon.value!.code} applied successfully! Discount: ₹${controller.discountAmount.value}",
                  style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Obx(() {
        final discount = controller.discountAmount.value;
        final total = subTotal + shippingCharge - discount;

        return Column(
          children: [
            _buildSummaryRow("Items Subtotal", "₹$subTotal"),
            if (widget.format == 'HARD_COPY') ...[
              const SizedBox(height: 10),
              _buildSummaryRow("Shipping Fee (Flat)", "₹$shippingCharge"),
            ],
            if (discount > 0) ...[
              const SizedBox(height: 10),
              _buildSummaryRow("Coupon Discount", "-₹$discount", isDiscount: true),
            ],
            const Divider(height: 20),
            _buildSummaryRow("Payable Amount", "₹$total", isTotal: true),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryRow(String label, String val, {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 12,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.normal,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          val,
          style: TextStyle(
            fontSize: isTotal ? 14 : 12,
            fontWeight: FontWeight.bold,
            color: isDiscount
                ? Colors.green
                : isTotal
                    ? AppColors.brandPurple
                    : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brandPurple.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.brandPurple.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.delivery_dining, color: AppColors.brandPurple, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.format == 'HARD_COPY'
                      ? "Payment Mode: Cash on Delivery (COD)"
                      : "Pay offline at center to unlock soft copy",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isPlacingOrder.value
                      ? null
                      : () async {
                          if (widget.format == 'HARD_COPY' && !_formKey.currentState!.validate()) {
                            return;
                          }

                          final address = widget.format == 'HARD_COPY'
                              ? "${_streetController.text.trim()}, Landmark: ${_landmarkController.text.trim()}, ${_cityController.text.trim()}, ${_stateController.text.trim()} - ${_pinController.text.trim()}"
                              : null;

                          final order = await controller.placeOrder(
                            bookId: widget.book.id,
                            format: widget.format,
                            quantity: widget.quantity,
                            couponCode: controller.appliedCoupon.value?.code,
                            shippingName: widget.format == 'HARD_COPY' ? _nameController.text.trim() : null,
                            shippingPhone: widget.format == 'HARD_COPY' ? _phoneController.text.trim() : null,
                            shippingAddress: address,
                          );

                          if (order != null) {
                            Get.defaultDialog(
                              title: "Order Placed!",
                              middleText: widget.format == 'HARD_COPY'
                                  ? "Your order has been placed successfully via Cash on Delivery."
                                  : "Order created. Please pay at center to unlock this soft copy in 'My Books'.",
                              onConfirm: () {
                                Get.back(); // close dialog
                                Get.back(); // close checkout
                                Get.back(); // close detail
                              },
                              textConfirm: "OK",
                              confirmTextColor: Colors.white,
                              buttonColor: AppColors.brandPurple,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: controller.isPlacingOrder.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Place Order",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ),
              )),
        ],
      ),
    );
  }
}

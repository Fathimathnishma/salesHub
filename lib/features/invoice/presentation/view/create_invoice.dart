import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saleshub/core/utils/app_colors.dart';
import 'package:saleshub/features/auth/presentation/provider/auth_provider.dart';
import 'package:saleshub/features/customer/data/models/customer_model.dart';
import 'package:saleshub/features/product/presentation/view/product_screen.dart';
import 'package:saleshub/features/product/presentation/provider/product_provider.dart';
import 'package:saleshub/features/invoice/presentation/provider/invoice_provider.dart';

class CreateInvoiceScreen extends StatelessWidget {
  final CustomerModel customer;

  const CreateInvoiceScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Consumer2<InvoiceProvider, ProductProvider>(
      builder: (context, state, productProvider, _) {
        final auth = context.read<AuthProvider>();
        final cart = productProvider.cart;

        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            backgroundColor: AppColors.card,
            title: Text(
              "Create Invoice",
              style: TextStyle(color: AppColors.textPrimary),
            ),
            iconTheme: IconThemeData(color: AppColors.textPrimary),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Customer",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        customer.name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ADD PRODUCTS (NO RESULT HANDLING)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProductScreen()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "+ Add Products",
                        style: TextStyle(
                          color: AppColors.card,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // CART
                Expanded(
                  child: cart.isEmpty
                      ? Center(
                          child: Text(
                            "No Products Added",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          itemCount: cart.length,
                          itemBuilder: (context, index) {
                            final item = cart[index];

                            return _card(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        productProvider.removeItem(item["id"]),
                                    child: Icon(
                                      Icons.close,
                                      color: AppColors.error,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item["name"],
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "₹ ${item["price"]}",
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            productProvider.updateQuantity(
                                              item["id"],
                                              productProvider.getQuantity(
                                                    item["id"],
                                                  ) -
                                                  1,
                                            ),
                                        icon: Icon(
                                          Icons.remove,
                                          color: AppColors.error,
                                        ),
                                      ),

                                      Text(
                                        "${productProvider.getQuantity(item["id"])}",
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),

                                      IconButton(
                                        onPressed: () =>
                                            productProvider.updateQuantity(
                                              item["id"],
                                              productProvider.getQuantity(
                                                    item["id"],
                                                  ) +
                                                  1,
                                            ),
                                        icon: Icon(
                                          Icons.add,
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    "₹ ${(item["price"] * item["quantity"]).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 10),

                _card(
                  child: Column(
                    children: [
                      _row("Subtotal", productProvider.subTotal),
                      _row("Tax", productProvider.tax),
                      const Divider(),
                      _row(
                        "Grand Total",
                        productProvider.grandTotal,
                        isBold: true,
                        isSuccess: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: cart.isEmpty || state.isLoading
                        ? null
                        : () async {
                            if (auth.storeId == null || auth.userId == null) {
                              return;
                            }

                            final success = await state.createInvoice(
                              customerId: customer.id,
                              storeId: auth.storeId!,
                              userId: auth.userId!,
                            );

                            if (success && context.mounted) {
                              productProvider.clearCart();
                              Navigator.pop(context);
                            }
                          },
                    child: state.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Create Invoice"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

  Widget _row(
    String title,
    double value, {
    bool isBold = false,
    bool isSuccess = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "₹ ${value.toStringAsFixed(2)}",
            style: TextStyle(
              color: isSuccess ? AppColors.success : AppColors.textSecondary,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

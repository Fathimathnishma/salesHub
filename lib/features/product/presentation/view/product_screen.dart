import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saleshub/core/utils/app_colors.dart';
import 'package:saleshub/features/auth/presentation/provider/auth_provider.dart';
import 'package:saleshub/features/product/data/models/product_model.dart';
import 'package:saleshub/features/product/presentation/provider/product_provider.dart';
import 'product_detail_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();

    final storeId = context.read<AuthProvider>().storeId;

    if (storeId != null) {
      Future.microtask(() {
        context.read<ProductProvider>().fetchProducts(storeId);
      });
    }
  }

  void openDetails(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text("Products", style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.card,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: provider.cart.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              onPressed: () {
                Navigator.pop(context, provider.cart);
              },
              label: Text(
                "Add to Invoice (${provider.cart.length})",
                style: TextStyle(color: AppColors.card),
              ),
              icon: Icon(Icons.receipt_long, color: AppColors.card),
            )
          : null,
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.products.isEmpty
          ? Center(
              child: Text(
                "No Products Found",
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];

                final selected = provider.isSelected(product.id);
                final qty = provider.getQuantity(product.id);
                final unit = provider.getSelectedUnit(product);

                return GestureDetector(
                  onTap: () => openDetails(product),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                      ),
                    ),

                    child: Row(
                      children: [
                        // ================= CHECKBOX =================
                        GestureDetector(
                          onTap: () {
                            provider.toggleProduct(product);
                          },
                          child: Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              color: selected
                                  ? AppColors.primary
                                  : Colors.transparent,
                            ),
                            child: selected
                                ? Icon(
                                    Icons.check,
                                    size: 14,
                                    color: AppColors.card,
                                  )
                                : null,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // ================= IMAGE =================
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              (product.image != null &&
                                  product.image!.isNotEmpty)
                              ? Image.network(
                                  product.image!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.image,
                                        color: AppColors.textSecondary,
                                      ),
                                )
                              : Icon(
                                  Icons.image,
                                  color: AppColors.textSecondary,
                                ),
                        ),

                        const SizedBox(width: 12),

                        // ================= DETAILS =================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "₹ ${product.price}",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // ================= UNIT =================
                              if (selected)
                                DropdownButton<dynamic>(
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                  value: unit,
                                  dropdownColor: AppColors.card,
                                  items: product.units.map((u) {
                                    return DropdownMenuItem(
                                      value: u,
                                      child: Text(u.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      provider.updateUnit(product.id, value);
                                    }
                                  },
                                ),

                              if (selected)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        provider.updateQuantity(
                                          product.id,
                                          qty - 1,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),

                                    Text(
                                      qty.toString(),
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        provider.updateQuantity(
                                          product.id,
                                          qty + 1,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saleshub/core/utils/app_colors.dart';
import 'package:saleshub/features/auth/presentation/provider/auth_provider.dart';
import 'package:saleshub/features/invoice/presentation/provider/invoice_provider.dart';
import 'package:saleshub/features/invoice/presentation/view/invoice_detail_screen.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  @override
  @override
  void initState() {
    super.initState();

    final auth = context.read<AuthProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvoiceProvider>().fetchInvoiceList(
        userId: auth.userId ?? 0,
        storeId: auth.storeId ?? 0,
        vanId: 0, // 🔥 FORCE THIS
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvoiceProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,

      body: provider.isListLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.invoiceList.isEmpty
          ? Center(
              child: Text(
                "No Invoices Found",
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              itemCount: provider.invoiceList.length,
              itemBuilder: (context, index) {
                final invoice = provider.invoiceList[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InvoiceDetailScreen(invoice: invoice),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        // ICON
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Invoice #${invoice["invoice_no"] ?? invoice["id"]}",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Total: ₹ ${invoice["grand_total"] ?? 0}",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ARROW
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

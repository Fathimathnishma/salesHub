import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saleshub/core/utils/app_colors.dart';
import 'package:saleshub/features/auth/presentation/provider/auth_provider.dart';
import 'package:saleshub/features/customer/presentation/provider/customer_provider.dart';
import 'package:saleshub/features/product/presentation/view/product_screen.dart';
import 'package:saleshub/features/invoice/presentation/view/create_invoice.dart';

class CustomerTab extends StatefulWidget {
  const CustomerTab({super.key});

  @override
  State<CustomerTab> createState() => _CustomerTabState();
}

class _CustomerTabState extends State<CustomerTab> {
  @override
  void initState() {
    super.initState();

    final storeId = context.read<AuthProvider>().storeId;

    if (storeId != null) {
      Future.microtask(() {
        context.read<CustomerProvider>().fetchCustomers(storeId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, state, _) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.customers.isEmpty) {
          return const Center(child: Text("No Customers"));
        }

        return ListView.builder(
          itemCount: state.customers.length,
          itemBuilder: (context, index) {
            final customer = state.customers[index];

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  customer.name ?? "",
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  customer.id.toString() ?? "",
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateInvoiceScreen(customer: customer),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:saleshub/core/utils/app_colors.dart';
import 'package:saleshub/features/customer/presentation/view/customer_screen.dart';
import 'package:saleshub/features/invoice/presentation/view/invoice_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          backgroundColor: AppColors.card,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Dashboard",
            style: TextStyle(color: AppColors.textPrimary),
          ),

          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            tabs: const [
              Tab(text: "Customers"),
              Tab(text: "Invoices"),
            ],
          ),
        ),

        body: const TabBarView(children: [CustomerTab(), InvoiceListScreen()]),
      ),
    );
  }
}

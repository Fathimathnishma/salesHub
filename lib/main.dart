import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saleshub/features/customer/presentation/provider/customer_provider.dart';
import 'package:saleshub/features/auth/presentation/provider/auth_provider.dart';
import 'package:saleshub/features/product/presentation/provider/product_provider.dart';
import 'package:saleshub/features/product/presentation/view/product_screen.dart';
import 'package:saleshub/features/invoice/presentation/provider/invoice_provider.dart';
import 'package:saleshub/features/splash/presentation/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => InvoiceProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: SplashScreens(),
      ),
    );
  }
}

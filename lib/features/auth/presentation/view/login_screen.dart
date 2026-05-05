import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saleshub/core/utils/app_colors.dart';
import 'package:saleshub/core/widgets/custom_textform.dart';
import 'package:saleshub/core/widgets/loading_button.dart';
import 'package:saleshub/features/auth/presentation/provider/auth_provider.dart';
import 'package:saleshub/features/dashboard/presentation/view/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Consumer<AuthProvider>(
        builder: (context, state, child) => SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    /// TITLE
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Login to continue",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),

                    const SizedBox(height: 40),

                    /// EMAIL
                    CustomTextFormField(
                      controller: state.emailController,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    /// PASSWORD
                    CustomTextFormField(
                      controller: state.passwordController,
                      hintText: "Password",
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 6) {
                          return "Minimum 6 characters required";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    /// LOGIN BUTTON
                    LoadingButton(
                      label: "Login",

                      isLoading: state.isLoading,
                      onPressed: () async {
                        if (!state.isLoading) {
                          if (_formKey.currentState!.validate()) {
                            final success = await state.login(
                              state.emailController.text,
                              state.passwordController.text,
                            );

                            if (!mounted) return;

                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DashboardScreen(),
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    /// SIGN UP
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

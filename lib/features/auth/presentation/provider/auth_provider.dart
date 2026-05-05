import 'package:flutter/material.dart';
import 'package:saleshub/core/networks/api_errors.dart';
import 'package:saleshub/core/widgets/custom_fluttertoast.dart';
import 'package:saleshub/features/auth/data/services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Map<String, dynamic>? user;
  dynamic userDetail;

  int? userId;
  int? storeId;
  int? routeId;
  int? vanId;

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _authService.loginWithDetails(
        email: email,
        password: password,
      );

      if (response["user"] == null) {
        throw Exception("User data missing");
      }

      user = response["user"];
      userDetail = response["userDetail"];

      if (userDetail is List && userDetail.isNotEmpty) {
        final detail = userDetail.first;

        userId = detail["user_id"];
        storeId = detail["store_id"];
        routeId = detail["route_id"];
        vanId = detail["van_id"];
      } else if (userDetail is Map) {
        userId = userDetail["user_id"];
        storeId = userDetail["store_id"];
        routeId = userDetail["route_id"];
        vanId = userDetail["van_id"];
      } else {
        throw Exception("Invalid user detail format");
      }

      debugPrint("USER: $user");
      debugPrint("DETAIL: $userDetail");
      debugPrint("STORE ID: $storeId");

      return true;
    } catch (e) {
      final appError = AppError.handle(e);
      AppToast.show(message: appError.message);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

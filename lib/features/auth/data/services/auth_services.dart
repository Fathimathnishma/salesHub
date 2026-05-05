import 'package:saleshub/core/networks/api_clients.dart';
import 'package:saleshub/core/networks/api_endpoint.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> loginWithDetails({
    required String email,
    required String password,
  }) async {
    try {
      // 1. LOGIN API
      final loginResponse = await _apiClient.post(ApiEndpoints.login, {
        "email": email,
        "password": password,
      });

      print("LOGIN RESPONSE: $loginResponse");

      // safer validation
      if (loginResponse == null || loginResponse["status"] != "success") {
        throw Exception("Login failed");
      }

      final user = loginResponse["user"];

      if (user == null || user["id"] == null) {
        throw Exception("Invalid login response: user missing");
      }

      final userId = user["id"].toString();

      // 2. GET USER DETAIL API
      final userDetailResponse = await _apiClient.get(
        ApiEndpoints.userDetail,
        queryParameters: {"user_id": userId},
      );

      print("USER DETAIL RESPONSE: $userDetailResponse");

      if (userDetailResponse == null || userDetailResponse["success"] != true) {
        throw Exception("Failed to fetch user details");
      }

      final userDetail = userDetailResponse["data"];

      if (userDetail == null) {
        throw Exception("User detail is empty");
      }

      // return combined data
      return {"user": user, "userDetail": userDetail};
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

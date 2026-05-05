import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saleshub/core/networks/api_endpoint.dart';

class ApiClient {
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("${ApiEndpoints.baseUrl}$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body), // ✅ FIXED
    );

    return _handleResponse(response);
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(
      "${ApiEndpoints.baseUrl}$endpoint",
    ).replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {"Accept": "application/json", ...?headers},
    );

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    print("RAW RESPONSE: ${response.body}"); // 🔥 debug

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }
}

import 'package:saleshub/core/networks/api_clients.dart';
import 'package:saleshub/core/networks/api_endpoint.dart';

class InvoiceService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> createInvoice(Map<String, dynamic> body) async {
    final response = await _apiClient.post(ApiEndpoints.createSale, body);

    if (response is! Map<String, dynamic>) {
      throw Exception("Invalid invoice response format");
    }

    if (response["success"] != true) {
      throw Exception(
        response["message"]?.toString() ?? "Invoice creation failed",
      );
    }

    return response;
  }

  Future<Map<String, dynamic>> getInvoiceList({
    required int userId,
    required int storeId,
    required int vanId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.saleList,
      queryParameters: {
        "user_id": userId.toString(),
        "store_id": storeId.toString(),
        "van_id": vanId.toString(),
      },
    );

    if (response is! Map<String, dynamic>) {
      throw Exception("Invalid response format");
    }

    if (response["success"] != true) {
      throw Exception(
        response["message"]?.toString() ?? "Failed to fetch invoices",
      );
    }

    // ✅ return full structured response
    return response;
  }
}

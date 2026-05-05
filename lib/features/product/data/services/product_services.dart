import 'package:saleshub/core/networks/api_clients.dart';
import 'package:saleshub/core/networks/api_endpoint.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getProducts(int storeId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.products,
        queryParameters: {"store_id": storeId.toString()},
      );

      if (response == null || response["success"] != true) {
        throw Exception(response?["message"] ?? "Failed to fetch products");
      }

      final data = response["data"];

      if (data is Map<String, dynamic> && data["data"] is List) {
        return data["data"];
      }

      if (data is List) {
        return data;
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}

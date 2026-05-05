import 'package:saleshub/core/networks/api_clients.dart';
import 'package:saleshub/core/networks/api_endpoint.dart';

class CustomerService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> getCustomers({required int storeId}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.customers,
        queryParameters: {"route_id": "84", "store_id": storeId.toString()},
      );

      if (response is! Map<String, dynamic>) {
        throw Exception("Invalid customer response format");
      }

      if (response["success"] != true) {
        throw Exception(response["message"]?.toString() ?? "Failed to fetch customers");
      }

      return response["data"] is List ? response["data"] : [];
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      throw Exception(errorMsg);
    }
  }
}

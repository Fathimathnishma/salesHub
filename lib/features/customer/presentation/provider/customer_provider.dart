import 'package:flutter/material.dart';
import 'package:saleshub/core/networks/api_errors.dart';
import 'package:saleshub/core/widgets/custom_fluttertoast.dart';
import 'package:saleshub/features/customer/data/models/customer_model.dart';
import 'package:saleshub/features/customer/data/services/customer_services.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerService _service = CustomerService();

  bool isLoading = false;
  List<CustomerModel> customers = [];

  Future<void> fetchCustomers(int storeId) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _service.getCustomers(storeId: storeId);

      // 👇 convert JSON → Model
      customers = data.map((e) => CustomerModel.fromJson(e)).toList();
    } catch (e) {
      final error = AppError.handle(e);
      AppToast.show(message: error.message);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

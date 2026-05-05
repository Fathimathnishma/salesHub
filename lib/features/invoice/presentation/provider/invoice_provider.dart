import 'package:flutter/material.dart';
import 'package:saleshub/core/networks/api_errors.dart';
import 'package:saleshub/core/widgets/custom_fluttertoast.dart';
import 'package:saleshub/features/invoice/data/models/sales_model.dart';
import 'package:saleshub/features/invoice/data/services/invoice_services.dart';

class InvoiceProvider extends ChangeNotifier {
  final InvoiceService _service = InvoiceService();

  bool isLoading = false;
  bool isListLoading = false;

  List<Map<String, dynamic>> cartItems = [];
  List<dynamic> invoiceList = [];

  void addOrUpdateProduct({
    required int id,
    required String name,
    required double price,
    required int qty,
    required dynamic unit,
    required double tax,
    int productType = 1,
  }) {
    final index = cartItems.indexWhere((e) => e["id"] == id);

    if (index != -1) {
      cartItems[index]["qty"] = qty;
    } else {
      cartItems.add({
        "id": id,
        "name": name,
        "price": price,
        "qty": qty,
        "tax": tax,
        "product_type": productType,
        "selected_unit": unit,
      });
    }

    notifyListeners();
  }

  void removeProduct(int id) {
    cartItems.removeWhere((e) => (e["id"] ?? 0) == id);
    notifyListeners();
  }

  void increaseQty(int id) {
    final index = cartItems.indexWhere((e) => e["id"] == id);

    if (index != -1) {
      cartItems[index]["qty"] = (cartItems[index]["qty"] ?? 0) + 1;
      notifyListeners();
    }
  }

  void decreaseQty(int id) {
    final index = cartItems.indexWhere((e) => e["id"] == id);

    if (index != -1) {
      final qty = (cartItems[index]["qty"] ?? 0);

      if (qty > 1) {
        cartItems[index]["qty"] = qty - 1;
      } else {
        cartItems.removeAt(index);
      }

      notifyListeners();
    }
  }

  double get subTotal => cartItems.fold(0.0, (sum, e) {
    final price = (e["price"] ?? 0).toDouble();
    final qty = (e["qty"] ?? 0);
    return sum + (price * qty);
  });

  double get tax => cartItems.fold(0.0, (sum, e) {
    final price = (e["price"] ?? 0).toDouble();
    final qty = (e["qty"] ?? 0);
    final tax = (e["tax"] ?? 0).toDouble();
    return sum + ((price * qty) * tax / 100);
  });

  double get grandTotal => subTotal + tax;

  double get discount => 0;
  double get roundOff => 0;

  Future<bool> createInvoice({
    required int customerId,
    required int storeId,
    required int userId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final model = SalesRequestModel(
        customerId: customerId,
        storeId: storeId,
        userId: userId,
        total: subTotal,
        totalTax: tax,
        grandTotal: grandTotal,
        itemId: cartItems
            .map<int>((e) => int.parse(e["id"].toString()))
            .toList(),
        quantity: cartItems
            .map<int>((e) => int.parse(e["qty"].toString()))
            .toList(),
        mrp: cartItems
            .map<double>((e) => (e["price"] ?? 0).toDouble())
            .toList(),
        productType: cartItems
            .map<int>((e) => int.parse(e["product_type"].toString()))
            .toList(),
        unit: cartItems.map<int>((e) {
          final unit = e["selected_unit"];
          return unit != null ? (unit.id as num).toInt() : 0;
        }).toList(),
      );

      await _service.createInvoice(model.toJson());
      await fetchInvoiceList(userId: userId, storeId: storeId, vanId: 0);

      clearCart();
      return true;
    } catch (e) {
      final error = AppError.handle(e);
      AppToast.show(message: error.message);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // 📦 INVOICE LIST (MISSING PART FIXED)
  // =========================
  Future<void> fetchInvoiceList({
    required int userId,
    required int storeId,
    required int vanId,
  }) async {
    try {
      isListLoading = true;
      notifyListeners();

      final result = await _service.getInvoiceList(
        userId: userId,
        storeId: storeId,
        vanId: vanId,
      );

      final responseData = result['data'];

      if (responseData is List) {
        invoiceList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        invoiceList = responseData['data'];
      } else {
        invoiceList = [];
      }
    } catch (e) {
      final error = AppError.handle(e);
      AppToast.show(message: error.message);
    } finally {
      isListLoading = false;
      notifyListeners();
    }
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }
}

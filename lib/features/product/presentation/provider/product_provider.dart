import 'package:flutter/material.dart';
import 'package:saleshub/core/networks/api_errors.dart';
import 'package:saleshub/core/widgets/custom_fluttertoast.dart';
import 'package:saleshub/features/product/data/models/product_model.dart';
import 'package:saleshub/features/product/data/services/product_services.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  bool isLoading = false;

  List<ProductModel> products = [];
  List<Map<String, dynamic>> cart = [];

  Future<void> fetchProducts(int storeId) async {
    try {
      isLoading = true;
      notifyListeners();

      final list = await _service.getProducts(storeId);

      products = list.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      final error = AppError.handle(e);
      AppToast.show(message: error.message);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isSelected(int productId) {
    return cart.any((item) => item["id"] == productId);
  }

  void toggleProduct(ProductModel product) {
    final index = cart.indexWhere((item) => item["id"] == product.id);

    if (index != -1) {
      cart.removeAt(index);
    } else {
      final defaultUnit = product.units.isNotEmpty ? product.units.first : null;

      cart.add({
        "id": product.id,
        "name": product.name,
        "price": product.price,
        "tax": product.taxPercentage,
        "quantity": 1,
        "units": product.units,
        "selected_unit": defaultUnit,
      });
    }

    notifyListeners();
  }

  void updateQuantity(int productId, int qty) {
    final index = cart.indexWhere((item) => item["id"] == productId);

    if (index != -1) {
      cart[index]["quantity"] = qty < 1 ? 1 : qty;
      notifyListeners();
    }
  }

  int getQuantity(int productId) {
    final index = cart.indexWhere((e) => e["id"] == productId);
    if (index == -1) return 1;
    return (cart[index]["quantity"] ?? 1) as int;
  }

  void updateUnit(int productId, UnitModel unit) {
    final index = cart.indexWhere((item) => item["id"] == productId);

    if (index != -1) {
      cart[index]["selected_unit"] = unit;
      cart[index]["price"] = unit.price;
      notifyListeners();
    }
  }

  UnitModel? getSelectedUnit(ProductModel product) {
    final index = cart.indexWhere((e) => e["id"] == product.id);

    if (index == -1) {
      return product.units.isNotEmpty ? product.units.first : null;
    }

    final unit = cart[index]["selected_unit"];

    return unit is UnitModel
        ? unit
        : (product.units.isNotEmpty ? product.units.first : null);
  }

  void removeItem(int productId) {
    cart.removeWhere((item) => item["id"] == productId);
    notifyListeners();
  }

  double get subTotal {
    return cart.fold(0.0, (sum, item) {
      final price = (item["price"] as num?)?.toDouble() ?? 0.0;
      final qty = (item["quantity"] as num?)?.toDouble() ?? 0.0;
      return sum + (price * qty);
    });
  }

  double get tax {
    return cart.fold(0.0, (sum, item) {
      final price = (item["price"] as num?)?.toDouble() ?? 0.0;
      final qty = (item["quantity"] as num?)?.toDouble() ?? 0.0;
      final taxPercent = (item["tax"] as num?)?.toDouble() ?? 0.0;

      return sum + ((price * qty) * taxPercent / 100);
    });
  }

  double get grandTotal => subTotal + tax;

  void clearCart() {
    cart.clear();
    notifyListeners();
  }
}

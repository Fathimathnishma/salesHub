class SalesRequestModel {
  final int customerId;
  final int storeId;
  final int userId;
  final int vanId;
  final String saveMode;
  final int orderType;
  final double discount;
  final double total;
  final double totalTax;
  final double grandTotal;
  final double roundOff;
  final int ifVat;
  final String remarks;

  final List<int> itemId;
  final List<int> quantity;
  final List<double> mrp;
  final List<int> productType;
  final List<int> unit;

  SalesRequestModel({
    required this.customerId,
    required this.storeId,
    required this.userId,
    this.vanId = 0,
    this.saveMode = "normal",
    this.orderType = 1,
    this.discount = 0,
    required this.total,
    required this.totalTax,
    required this.grandTotal,
    this.roundOff = 0,
    this.ifVat = 1,
    this.remarks = "",
    required this.itemId,
    required this.quantity,
    required this.mrp,
    required this.productType,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {
      "customer_id": customerId,
      "store_id": storeId,
      "user_id": userId,
      "van_id": vanId,
      "save_mode": saveMode,
      "order_type": orderType,
      "discount": discount,
      "total": total,
      "total_tax": totalTax,
      "grand_total": grandTotal,
      "round_off": roundOff,
      "if_vat": ifVat,
      "remarks": remarks,
      "item_id": itemId,
      "quantity": quantity,
      "mrp": mrp,
      "product_type": productType,
      "unit": unit,
    };
  }
}

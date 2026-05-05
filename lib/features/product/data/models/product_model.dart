class ProductModel {
  final int id;
  final String name;
  final String? image;
  final double price;
  final double taxPercentage;
  final List<UnitModel> units;

  ProductModel({
    required this.id,
    required this.name,
    this.image,
    required this.price,
    required this.taxPercentage,
    required this.units,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.tryParse(json["id"]?.toString() ?? "0") ?? 0,
      name: json["name"] ?? "",
      image: json["pro_image"]?.toString(),

      price: double.tryParse(json["price"]?.toString() ?? "0") ?? 0,
      taxPercentage:
          double.tryParse(json["tax_percentage"]?.toString() ?? "0") ?? 0,

      units: (json["units"] is List)
          ? (json["units"] as List).map((e) => UnitModel.fromJson(e)).toList()
          : [],
    );
  }
}

class UnitModel {
  final int id;
  final int unit;
  final String name;
  final double price;

  UnitModel({
    required this.id,
    required this.unit,
    required this.name,
    required this.price,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      // 🔥 FIX: sometimes comes as String → convert
      id: int.tryParse(json["id"].toString()) ?? 0,

      // 🔥 THIS is where your error came from
      unit: int.tryParse(json["unit"].toString()) ?? 0,

      name: json["name"] ?? "",

      price: double.tryParse(json["price"].toString()) ?? 0,
    );
  }
}

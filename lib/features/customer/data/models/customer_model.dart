class CustomerModel {
  final int id;
  final String name;
  final String? contactNumber;
  final int storeId;
  final int routeId;

  CustomerModel({
    required this.id,
    required this.name,
    this.contactNumber,
    required this.storeId,
    required this.routeId,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      contactNumber: json["contact_number"]?.toString(),
      storeId: json["store_id"] ?? 0,
      routeId: json["route_id"] ?? 0,
    );
  }
}

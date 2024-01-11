class PurchaseHistory {
  PurchaseHistory({
    this.purchase,
  });

  List<Purchase>? purchase;

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) => PurchaseHistory(
    purchase: json["purchase"] == null ? null : List<Purchase>.from(json["purchase"].map((x) => Purchase.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "purchase": purchase == null ? null : List<dynamic>.from(purchase!.map((x) => x.toJson())),
  };
}

class Purchase {
  Purchase({
    this.purchaseDate,
    this.quantity,
    this.storeId,
    this.purchaseType,
    this.qrFileNameUrl,
  });

  String? purchaseDate;
  int? quantity;
  int? storeId;
  int? purchaseType;
  String? qrFileNameUrl;

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
    purchaseDate: json["purchase_date"] == null ? null : json["purchase_date"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    storeId: json["store_id"] == null ? null : json["store_id"],
    purchaseType: json["purchase_type"] == null ? null : json["purchase_type"],
    qrFileNameUrl: json["qr_file_name_url"] == null ? null : json["qr_file_name_url"],
  );

  Map<String, dynamic> toJson() => {
    "purchase_date": purchaseDate == null ? null : purchaseDate,
    "quantity": quantity == null ? null : quantity,
    "store_id": storeId == null ? null : storeId,
    "purchase_type": purchaseType == null ? null : purchaseType,
    "qr_file_name_url": qrFileNameUrl == null ? null : qrFileNameUrl,
  };
}

class Purchase {
  Purchase({
    this.userId,
    this.name,
    this.userSecret,
    this.purchaseStatus,
    this.purchaseType,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.qrFileNameUrl,
  });

  int? userId;
  String? name;
  int? userSecret;
  int? purchaseStatus;
  int? purchaseType;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  String? qrFileNameUrl;

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
    userId: json["user_id"] == null ? null : json["user_id"],
    name: json["name"] == null ? null : json["name"],
    userSecret: json["user_secret"] == null ? null : json["user_secret"],
    purchaseStatus: json["purchase_status"] == null ? null : json["purchase_status"],
    purchaseType: json["purchase_type"] == null ? null : json["purchase_type"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"] == null ? null : json["id"],
    qrFileNameUrl: json["qr_file_name_url"] == null ? null : json["qr_file_name_url"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId == null ? null : userId,
    "name": name == null ? null : name,
    "user_secret": userSecret == null ? null : userSecret,
    "purchase_status": purchaseStatus == null ? null : purchaseStatus,
    "purchase_type": purchaseType == null ? null : purchaseType,
    "updated_at": updatedAt == null ? null : updatedAt,
    "created_at": createdAt == null ? null : createdAt,
    "id": id == null ? null : id,
    "qr_file_name_url": qrFileNameUrl == null ? null : qrFileNameUrl,
  };
}

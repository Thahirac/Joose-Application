class User {
  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.userType,
    this.emailVerifiedAt,
    this.dob,
    this.gender,
    this.city,
    this.storeId,
    this.socialId,
    this.profilePicture,
    this.profilepictureurl,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  String? userType;
  dynamic emailVerifiedAt;
  DateTime? dob;
  dynamic gender;
  dynamic city;
  dynamic storeId;
  dynamic socialId;
  String? profilePicture;
  String? profilepictureurl;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    userType: json["user_type"] == null ? null : json["user_type"],
    emailVerifiedAt: json["email_verified_at"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    gender: json["gender"],
    city: json["city"],
    storeId: json["store_id"],
    socialId: json["social_id"],
    profilePicture: json["profile_picture"] == null ? null : json["profile_picture"],
    profilepictureurl: json["profile_picture_url"] == null ? null : json["profile_picture_url"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
    "user_type": userType == null ? null : userType,
    "email_verified_at": emailVerifiedAt,
    "dob": dob == null ? null : "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "city": city,
    "store_id": storeId,
    "social_id": socialId,
    "profile_picture": profilePicture == null ? null : profilePicture,
    "profile_picture_url": profilepictureurl==null? null: profilepictureurl,
    "status": status,
    "created_at": createdAt == null ? null : createdAt,
    "updated_at": updatedAt == null ? null : updatedAt,
    "deleted_at": deletedAt,
  };
}

class UserSession {
  String? token;

  UserSession(
      {this.token,});

  UserSession.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}
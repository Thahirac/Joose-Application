
// ignore_for_file: file_names

class Data {
  Data({
    this.notifications,
    this.notificationCount,
    this.notification
  });

  List<MyNotification>? notifications;
  int? notificationCount;
  SingleNotification? notification;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    notifications: json["notifications"] == null ? null : List<MyNotification>.from(json["notifications"].map((x) => MyNotification.fromJson(x))),
    notificationCount: json["notification_count"] == null ? null : json["notification_count"],
    notification: json["notification"] == null ? null : SingleNotification.fromJson(json["notification"]),
  );

  Map<String, dynamic> toJson() => {
    "notifications": notifications == null ? null : List<dynamic>.from(notifications!.map((x) => x.toJson())),
    "notification_count": notificationCount == null ? null : notificationCount,
    "notification": notification == null ? null : notification!.toJson(),
  };
}

class MyNotification {
  MyNotification({
    this.id,
    this.time,
    this.title,
    this.description,
  });

  String? id;
  String? time;
  String? title;
  String? description;

  factory MyNotification.fromJson(Map<String, dynamic> json) => MyNotification(
    id: json["id"] == null ? null : json["id"],
    time: json["time"] == null ? null : json["time"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "time": time == null ? null : time,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
  };
}

class SingleNotification {
  SingleNotification({
    this.id,
    this.time,
    this.title,
    this.description,
  });

  String? id;
  String? time;
  String? title;
  String? description;

  factory SingleNotification.fromJson(Map<String, dynamic> json) => SingleNotification(
    id: json["id"] == null ? null : json["id"],
    time: json["time"] == null ? null : json["time"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "time": time == null ? null : time,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
  };
}











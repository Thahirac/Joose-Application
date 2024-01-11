
class DataClass {
  DataClass({
    this.messages,
    this.message,
    this.messageCount
  });

  List<Message>? messages;
  SingleMessage? message;
  int? messageCount;

  factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
    messages: json["messages"] == null ? null : List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
    message:  json["message"] == null ? null : SingleMessage.fromJson(json["message"]),
    messageCount: json["messages_count"] == null ? null : json["messages_count"],
  );

  Map<String, dynamic> toJson() => {
    "messages": messages == null ? null : List<dynamic>.from(messages!.map((x) => x.toJson())),
    "message": message == null ? null : message!.toJson(),
    "messages_count": messageCount ==null ? null : messageCount,
  };
}

class Message {
  Message({
    this.id,
    this.time,
    this.readAt,
    this.title,
    this.description,
  });

  String? id;
  String? time;
  String? readAt;
  String? title;
  String? description;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"] == null ? null : json["id"],
    time: json["time"] == null ? null : json["time"],
    readAt: json["read_at"] == null ? null : json["read_at"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "time": time == null ? null : time,
    "read_at": readAt == null ? null : readAt,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
  };
}

class SingleMessage {
  SingleMessage({
    this.id,
    this.time,
    this.title,
    this.description,
  });

  String? id;
  String? time;
  String? title;
  String? description;

  factory SingleMessage.fromJson(Map<String, dynamic> json) => SingleMessage(
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
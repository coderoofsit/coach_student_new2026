class NotificationCoachModel {
  NotificationCoachModel({
    required this.notification,
  });

  final List<Notification> notification;

  NotificationCoachModel copyWith({
    List<Notification>? notification,
  }) {
    return NotificationCoachModel(
      notification: notification ?? this.notification,
    );
  }

  factory NotificationCoachModel.fromJson(Map<String, dynamic> json) {
    return NotificationCoachModel(
      notification: json["notification"] == null
          ? []
          : List<Notification>.from(
              json["notification"]!.map((x) => Notification.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "notification": notification.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$notification, ";
  }
}

class Notification {
  Notification({
    required this.id,
    required this.to,
    required this.userType,
    required this.notificationWith,
    required this.fromRefType,
    required this.body,
    required this.type,
    required this.subType,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final To? to;
  final String userType;
  final With? notificationWith;
  final String fromRefType;
  final String body;
  final String type;
  final String subType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num v;

  Notification copyWith({
    String? id,
    To? to,
    String? userType,
    With? notificationWith,
    String? fromRefType,
    String? body,
    String? type,
    String? subType,
    DateTime? createdAt,
    DateTime? updatedAt,
    num? v,
  }) {
    return Notification(
      id: id ?? this.id,
      to: to ?? this.to,
      userType: userType ?? this.userType,
      notificationWith: notificationWith ?? this.notificationWith,
      fromRefType: fromRefType ?? this.fromRefType,
      body: body ?? this.body,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json["_id"] ?? "",
      to: json["to"] == null ? null : To.fromJson(json["to"]),
      userType: json["userType"] ?? "",
      notificationWith:
          json["with"] == null ? null : With.fromJson(json["with"]),
      fromRefType: json["fromRefType"] ?? "",
      body: json["body"] ?? "",
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "")?.toLocal(),
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "to": to?.toJson(),
        "userType": userType,
        "with": notificationWith?.toJson(),
        "fromRefType": fromRefType,
        "body": body,
        "type": type,
        "subType": subType,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };

  @override
  String toString() {
    return "$id, $to, $userType, $notificationWith, $fromRefType, $body, $type, $subType, $createdAt, $updatedAt, $v, ";
  }
}

class With {
  With({
    required this.image,
    required this.id,
  });

  final Image? image;
  final String id;

  With copyWith({
    Image? image,
    String? id,
  }) {
    return With(
      image: image ?? this.image,
      id: id ?? this.id,
    );
  }

  factory With.fromJson(Map<String, dynamic> json) {
    return With(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "image": image?.toJson(),
        "_id": id,
      };

  @override
  String toString() {
    return "$image, $id, ";
  }
}

class Image {
  Image({
    required this.publicId,
    required this.url,
  });

  final String publicId;
  final String url;

  Image copyWith({
    String? publicId,
    String? url,
  }) {
    return Image(
      publicId: publicId ?? this.publicId,
      url: url ?? this.url,
    );
  }

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      publicId: json["public_id"] ?? "",
      url: json["url"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "public_id": publicId,
        "url": url,
      };

  @override
  String toString() {
    return "$publicId, $url, ";
  }
}

class To {
  To({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  final String id;
  final String name;
  final String email;
  final num token;

  To copyWith({
    String? id,
    String? name,
    String? email,
    num? token,
  }) {
    return To(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  factory To.fromJson(Map<String, dynamic> json) {
    return To(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      token: json["token"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "token": token,
      };

  @override
  String toString() {
    return "$id, $name, $email, $token, ";
  }
}

/*
{
	"notification": [
		{
			"_id": "65e0490b8ae3aceb45aec3c1",
			"to": {
				"_id": "65d449b0afc22b4f184e65b3",
				"name": "Chandan",
				"email": "kumarchandandbg2@gmail.com",
				"token": 352
			},
			"userType": "coach",
			"with": {
				"image": {
					"public_id": "coach/guv3hcigix4jzvreqqa2",
					"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1709116512/coach/guv3hcigix4jzvreqqa2.jpg"
				},
				"_id": "65d449b0afc22b4f184e65b3"
			},
			"fromRefType": "coach",
			"body": "Your class has been scheduled",
			"type": "class-scheduled",
			"subType": "class-scheduled",
			"createdAt": "2024-02-29T09:06:19.300Z",
			"updatedAt": "2024-02-29T09:06:19.300Z",
			"__v": 0
		}
	]
}*/
class NotificationClassModel {
  NotificationClassModel({
    required this.id,
    required this.to,
    required this.userType,
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
  final String body;
  final String type;
  final String subType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  factory NotificationClassModel.fromJson(Map<String, dynamic> json){
    return NotificationClassModel(
      id: json["_id"] ?? "",
      to: json["to"] == null ? null : To.fromJson(json["to"]),
      userType: json["userType"] ?? "",
      body: json["body"] ?? "",
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "to": to?.toJson(),
    "userType": userType,
    "body": body,
    "type": type,
    "subType": subType,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };

  @override
  String toString(){
    return "$id, $to, $userType, $body, $type, $subType, $createdAt, $updatedAt, $v, ";
  }

}

class To {
  To({
    required this.image,
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.token,
  });

  final Image? image;
  final String id;
  final String name;
  final String email;
  final int age;
  final int token;

  factory To.fromJson(Map<String, dynamic> json){
    return To(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      age: json["age"] ?? 0,
      token: json["token"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "image": image?.toJson(),
    "_id": id,
    "name": name,
    "email": email,
    "age": age,
    "token": token,
  };

  @override
  String toString(){
    return "$image, $id, $name, $email, $age, $token, ";
  }

}

class Image {
  Image({
    required this.publicId,
    required this.url,
  });

  final String publicId;
  final String url;

  factory Image.fromJson(Map<String, dynamic> json){
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
  String toString(){
    return "$publicId, $url, ";
  }

}

/*
{
	"_id": "65dc88fdf04861cbb4ed8d5d",
	"to": {
		"image": {
			"public_id": "coach/od26dpmi6mnhqpkghuln",
			"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1708946236/coach/od26dpmi6mnhqpkghuln.jpg"
		},
		"_id": "65d863676236d8d64e682924",
		"name": "Pradeep",
		"email": "lebaso8614@molyg.com",
		"age": 20,
		"token": 35
	},
	"userType": "student",
	"body": "Abhishek C Scheduled a class",
	"type": "class-scheduled",
	"subType": "class-scheduled",
	"createdAt": "2024-02-26T12:50:05.911Z",
	"updatedAt": "2024-02-26T12:50:05.911Z",
	"__v": 0
}*/
class StudentListClientModel {
  StudentListClientModel({
    required this.clients,
  });

  final List<Client> clients;

  StudentListClientModel copyWith({
    List<Client>? clients,
  }) {
    return StudentListClientModel(
      clients: clients ?? this.clients,
    );
  }

  factory StudentListClientModel.fromJson(Map<String, dynamic> json) {
    // Handle both "clients" and "participants" keys
    List<dynamic>? clientList = json["clients"] ?? json["participants"];
    return StudentListClientModel(
      clients: clientList == null
          ? []
          : List<Client>.from(clientList.map((x) => Client.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "clients": clients.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$clients, ";
  }
}

class Client {
  Client(
      {required this.image,
      required this.id,
      required this.name,
      this.email,
      required this.age,
      required this.gender,
      required this.token,
      this.credits = 0,
      this.isSelected = false,
      this.parent,
      this.type,
      this.role,
      this.studentType,
      this.children});

  final Image? image;
  final String id;
  final String name;
  final String? email;
  final num age;
  final String gender;
  final num token;
  final num credits;
  bool isSelected = false;
  final String? parent;
  final String? type;
  final String? role;
  final String? studentType;
  final List<Child>? children;

  Client copyWith({
    Image? image,
    String? id,
    String? name,
    String? email,
    num? age,
    String? gender,
    num? token,
    num? credits,
    bool? isSelected,
    String? parent,
    String? type,
    String? role,
    String? studentType,
    List<Child>? children,
  }) {
    return Client(
      image: image ?? this.image,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      token: token ?? this.token,
      credits: credits ?? this.credits,
      isSelected: isSelected ?? this.isSelected,
      parent: parent ?? this.parent,
      type: type ?? this.type,
      role: role ?? this.role,
      studentType: studentType ?? this.studentType,
      children: children ?? this.children,
    );
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"],
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
      token: json["token"] ?? 0,
      credits: json["credits"] ?? 0,
      isSelected: json["isSelected"] ?? false,
      parent: json["parent"],
      type: json["type"],
      role: json["role"],
      studentType: json["studentType"],
      children: json["children"] == null
          ? null
          : List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "image": image?.toJson(),
        "_id": id,
        "id": id,
        "name": name,
        "email": email,
        "age": age,
        "gender": gender,
        "token": token,
        "credits": credits,
        "isSelected": isSelected,
        "parent": parent,
        "type": type,
        "role": role,
        "studentType": studentType,
        "children": children?.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$image, $id, $name, $email, $age, $gender, $token, $isSelected, $parent, $type, $role, $studentType, $children, ";
  }
}

class Child {
  Child({
    required this.image,
    required this.id,
    required this.parent,
    required this.name,
    required this.age,
    required this.gender,
    this.createdAt,
    this.v,
  });

  final Image? image;
  final String id;
  final String parent;
  final String name;
  final num age;
  final String gender;
  final DateTime? createdAt;
  final int? v;

  Child copyWith({
    Image? image,
    String? id,
    String? parent,
    String? name,
    num? age,
    String? gender,
    DateTime? createdAt,
    int? v,
  }) {
    return Child(
      image: image ?? this.image,
      id: id ?? this.id,
      parent: parent ?? this.parent,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      v: v ?? this.v,
    );
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? json["id"] ?? "",
      parent: json["parent"] ?? "",
      name: json["name"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
      createdAt: json["createdAt"] == null
          ? null
          : DateTime.tryParse(json["createdAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "image": image?.toJson(),
        "_id": id,
        "id": id,
        "parent": parent,
        "name": name,
        "age": age,
        "gender": gender,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
      };

  @override
  String toString() {
    return "$image, $id, $parent, $name, $age, $gender, $createdAt, $v, ";
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

/*
{
	"clients": [
		{
			"image": {
				"public_id": "coach/tjor6lhp8rwtkhcuombr",
				"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1708608597/coach/tjor6lhp8rwtkhcuombr.jpg"
			},
			"_id": "65d449a1afc22b4f184e65ad",
			"name": "jeet",
			"email": "daber22576@molyg.com",
			"age": 20,
			"gender": "male",
			"token": 180,
			"isSelected": false
		}
	]
}*/
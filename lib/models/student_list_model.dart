class StudentListModel {
  StudentListModel({
    required this.users,
  });

  final List<User> users;

  factory StudentListModel.fromJson(Map<String, dynamic> json) {
    return StudentListModel(
      users: json["users"] != null
          ? List<User>.from(json["users"]
              .map((x) => User.fromJson(x as Map<String, dynamic>)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "users": users.map((user) => user.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return "$users, ";
  }
}

class User {
  User({
    this.image,
    this.id,
    this.name,
    this.email,
     this.password,
     this.age,
     this.gender,
     this.token,
     this.createdAt,
     this.v,
  });

  final Image? image;
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final num? age;
  final String? gender;
  final num? token;
  final DateTime? createdAt;
  final num? v;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
      token: json["token"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image?.toJson(),
      "_id": id,
      "name": name,
      "email": email,
      "password": password,
      "age": age,
      "gender": gender,
      "token": token,
      "createdAt": createdAt?.toIso8601String(),
      "__v": v,
    };
  }

  @override
  String toString() {
    return "$image, $id, $name, $email, $password, $age, $gender, $token, $createdAt, $v, ";
  }
}

class Image {
  Image({
    required this.url,
    required this.publicId,
  });

  final String url;
  final String publicId;

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      url: json["url"] ?? "",
      publicId: json["public_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "public_id": publicId,
    };
  }

  @override
  String toString() {
    return "$url, $publicId, ";
  }
}

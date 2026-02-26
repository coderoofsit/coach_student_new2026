class PaymentsHistoryStudent {
  PaymentsHistoryStudent({
    required this.payments,
  });

  final List<Payment> payments;

  PaymentsHistoryStudent copyWith({
    List<Payment>? payments,
  }) {
    return PaymentsHistoryStudent(
      payments: payments ?? this.payments,
    );
  }

  factory PaymentsHistoryStudent.fromJson(Map<String, dynamic> json) {
    return PaymentsHistoryStudent(
      payments: json["payments"] == null
          ? []
          : List<Payment>.from(
              json["payments"]!.map((x) => Payment.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "payments": payments.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$payments, ";
  }
}

class Payment {
  Payment({
    required this.id,
    required this.user,
    required this.messaage,
    required this.token,
    required this.createdAt,
    required this.v,
  });

  final String id;
  final User? user;
  final String messaage;
  final num token;
  final DateTime? createdAt;
  final num v;

  Payment copyWith({
    String? id,
    User? user,
    String? messaage,
    num? token,
    DateTime? createdAt,
    num? v,
  }) {
    return Payment(
      id: id ?? this.id,
      user: user ?? this.user,
      messaage: messaage ?? this.messaage,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      v: v ?? this.v,
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json["_id"] ?? "",
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      messaage: json["messaage"] ?? "",
      token: json["token"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user?.toJson(),
        "messaage": messaage,
        "token": token,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
      };

  @override
  String toString() {
    return "$id, $user, $messaage, $token, $createdAt, $v, ";
  }
}

class User {
  User({
    required this.image,
    required this.id,
    required this.name,
    required this.email,
  });

  final Image? image;
  final String id;
  final String name;
  final String email;

  User copyWith({
    Image? image,
    String? id,
    String? name,
    String? email,
  }) {
    return User(
      image: image ?? this.image,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "image": image?.toJson(),
        "_id": id,
        "name": name,
        "email": email,
      };

  @override
  String toString() {
    return "$image, $id, $name, $email, ";
  }
}

class Image {
  Image({
    required this.url,
    required this.publicId,
  });

  final String url;
  final String publicId;

  Image copyWith({
    String? url,
    String? publicId,
  }) {
    return Image(
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
    );
  }

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      url: json["url"] ?? "",
      publicId: json["public_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "public_id": publicId,
      };

  @override
  String toString() {
    return "$url, $publicId, ";
  }
}

/*
{
	"payments": [
		{
			"_id": "660d37a329877e029a09f275",
			"user": {
				"image": {
					"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1710864703/coach/x9ubyv9gsz66klqlfbof.jpg",
					"public_id": "coach/x9ubyv9gsz66klqlfbof"
				},
				"_id": "65f9b94159e4f7a3f670d32f",
				"name": "Chandan Kumar",
				"email": "kumarchandandbg2@gmail.com"
			},
			"messaage": "You've successfully purchased 50 tokens!",
			"token": 50,
			"createdAt": "2024-04-03T11:04:03.000Z",
			"__v": 0
		},
		{
			"_id": "660d37595505e81249382295",
			"user": {
				"image": {
					"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1710864703/coach/x9ubyv9gsz66klqlfbof.jpg",
					"public_id": "coach/x9ubyv9gsz66klqlfbof"
				},
				"_id": "65f9b94159e4f7a3f670d32f",
				"name": "Chandan Kumar",
				"email": "kumarchandandbg2@gmail.com"
			},
			"messaage": "You've successfully purchased 50 tokens!",
			"token": 50,
			"createdAt": "2024-04-03T11:02:49.000Z",
			"__v": 0
		},
		{
			"_id": "660d373a5505e81249382288",
			"user": {
				"image": {
					"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1710864703/coach/x9ubyv9gsz66klqlfbof.jpg",
					"public_id": "coach/x9ubyv9gsz66klqlfbof"
				},
				"_id": "65f9b94159e4f7a3f670d32f",
				"name": "Chandan Kumar",
				"email": "kumarchandandbg2@gmail.com"
			},
			"messaage": "You've successfully purchased 20 tokens!",
			"token": 20,
			"createdAt": "2024-04-03T11:02:18.000Z",
			"__v": 0
		},
		{
			"_id": "660d35573ad3bc4a90aabc4c",
			"user": {
				"image": {
					"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1710864703/coach/x9ubyv9gsz66klqlfbof.jpg",
					"public_id": "coach/x9ubyv9gsz66klqlfbof"
				},
				"_id": "65f9b94159e4f7a3f670d32f",
				"name": "Chandan Kumar",
				"email": "kumarchandandbg2@gmail.com"
			},
			"messaage": "You've successfully purchased 20 tokens!",
			"token": 20,
			"createdAt": "2024-04-03T10:54:15.000Z",
			"__v": 0
		},
		{
			"_id": "660d34018c49df18e79d8205",
			"user": {
				"image": {
					"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1710864703/coach/x9ubyv9gsz66klqlfbof.jpg",
					"public_id": "coach/x9ubyv9gsz66klqlfbof"
				},
				"_id": "65f9b94159e4f7a3f670d32f",
				"name": "Chandan Kumar",
				"email": "kumarchandandbg2@gmail.com"
			},
			"messaage": "You've successfully purchased 20 tokens!",
			"token": 20,
			"createdAt": "2024-04-03T10:48:33.000Z",
			"__v": 0
		},
		{
			"_id": "660d335e59216aef1b938884",
			"user": {
				"image": {
					"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1710864703/coach/x9ubyv9gsz66klqlfbof.jpg",
					"public_id": "coach/x9ubyv9gsz66klqlfbof"
				},
				"_id": "65f9b94159e4f7a3f670d32f",
				"name": "Chandan Kumar",
				"email": "kumarchandandbg2@gmail.com"
			},
			"messaage": "You've successfully purchased 20 tokens!",
			"token": 20,
			"createdAt": "2024-04-03T10:45:50.000Z",
			"__v": 0
		},
		{
			"_id": "660d333e04b87cb42015f923",
			"user": {
				"image": {
					"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1710864703/coach/x9ubyv9gsz66klqlfbof.jpg",
					"public_id": "coach/x9ubyv9gsz66klqlfbof"
				},
				"_id": "65f9b94159e4f7a3f670d32f",
				"name": "Chandan Kumar",
				"email": "kumarchandandbg2@gmail.com"
			},
			"messaage": "Notification: You've successfully purchased 20 tokens!",
			"token": 20,
			"createdAt": "2024-04-03T10:45:18.000Z",
			"__v": 0
		}
	]
}*/
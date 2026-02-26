class StudentProfileIdClinetCoachModel {
  StudentProfileIdClinetCoachModel({
     this.image,
     this.id,
     this.name,
     this.email,
     this.age,
     this.gender,
     this.isOnline,
     this.token,
     this.role,
     this.referralCode,
     this.longitude,
     this.latitude,
     this.radius,
     this.address,
     this.phoneNumber,
     this.verified,
     this.coaches,
     this.createdAt,
  });

  final Image? image;
  final String? id;
  final String? name;
  final String? email;
  final num? age;
  final String? gender;
  final bool? isOnline;
  final num? token;
  final String? role;
  final String? referralCode;
  final num? longitude;
  final num? latitude;
  final num? radius;
  final String? address;
  final num? phoneNumber;
  final bool? verified;
  final List<String>? coaches;
  final DateTime? createdAt;

  factory StudentProfileIdClinetCoachModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileIdClinetCoachModel(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
      isOnline: json["isOnline"] ?? false,
      token: json["token"] ?? 0,
      role: json["role"] ?? "",
      referralCode: json["referralCode"] ?? "",
      longitude: json["longitude"] ?? 0,
      latitude: json["latitude"] ?? 0,
      radius: json["radius"] ?? 0,
      address: json["address"] ?? "",
      phoneNumber: json["phoneNumber"] ?? 0,
      verified: json["verified"] ?? false,
      coaches: json["coaches"] == null
          ? []
          : List<String>.from(json["coaches"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }

  @override
  String toString() {
    return "$image, $id, $name, $email, $age, $gender, $isOnline, $token, $role, $referralCode, $longitude, $latitude, $radius, $address, $phoneNumber, $verified, $coaches, $createdAt, ";
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
	"image": {
		"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1708680037/coach/pvhblghbknkkrlguw4sw.jpg",
		"public_id": "coach/pvhblghbknkkrlguw4sw"
	},
	"_id": "65d863676236d8d64e682924",
	"name": "Abhishek",
	"email": "lebaso8614@molyg.com",
	"age": 20,
	"gender": "male",
	"isOnline": false,
	"token": 45,
	"role": "parent",
	"referralCode": "2GXK45Q74PZT",
	"longitude": 77.18017569999999,
	"latitude": 28.6746196,
	"radius": 6.848357791754017,
	"address": "Shastri Nagar, Delhi, India",
	"phoneNumber": 7974988355,
	"verified": true,
	"coaches": [
		"65d449b0afc22b4f184e65b3"
	],
	"createdAt": "2024-02-23T09:20:39.423Z"
}*/
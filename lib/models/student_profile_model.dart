class StudentProfileModel {
  StudentProfileModel({
     this.image,
     this.id,
     this.name,
     this.email,
     this.password,
     this.age,
     this.gender,
     this.isOnline,
     this.token = 0,
     this.credits = 0,
     this.creditBalance = const [],
     this.role,
     this.referralCode,
     this.longitude,
     this.latitude,
     this.radius,
     this.address,
     this.phoneNumber,
     this.verified,
     this.createdAt,
     this.v,
  });

  final ProfileImage? image;
  final String ?id;
  final String ?name;
  final String ?email;
  final String ?password;
  final int ?age;
  final String? gender;
  final bool ?isOnline;
  final int token;
  final int credits;
  final List<CoachCreditBalance> creditBalance;
  final String? role;
  final String? referralCode;
  final double? longitude;
  final double? latitude;
  final double? radius;
  final String ?address;
  final int? phoneNumber;
  final bool? verified;
  final DateTime? createdAt;
  final int? v;
  // final num token;

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    List<CoachCreditBalance> creditBalanceList = [];
    if (json["creditBalance"] != null && json["creditBalance"] is List) {
      try {
        creditBalanceList = (json["creditBalance"] as List)
            .map((item) {
              // Ensure item is a Map before parsing
              if (item is Map<String, dynamic>) {
                return CoachCreditBalance.fromJson(item);
              } else {
                // Fallback for invalid format
                return CoachCreditBalance(
                  coachId: CoachInfo(id: "", name: "Unknown Coach", image: null),
                  credit: 0,
                );
              }
            })
            .toList();
      } catch (e) {
        // If parsing fails, use empty list - credits field will still work
        print("Error parsing creditBalance: $e");
        creditBalanceList = [];
      }
    }
    
    return StudentProfileModel(
      image: json["image"] == null ? null : ProfileImage.fromJson(json["image"]),
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
      isOnline: json["isOnline"] ?? false,
      token: json["token"] ?? 0,
      credits: json["credits"] ?? 0,
      creditBalance: creditBalanceList,
      role: json["role"] ?? "",
      referralCode: json["referralCode"] ?? "",
      longitude: json["longitude"] ?? 0.0,
      latitude: json["latitude"] ?? 0.0,
      radius: json["radius"] ?? 0.0,
      address: json["address"] ?? "",
      phoneNumber: json["phoneNumber"] ?? 0,
      verified: json["verified"] ?? false,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "image": image?.toJson(),
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "age": age,
        "gender": gender,
        "isOnline": isOnline,
        "token": token,
      "credits": credits,
        "role": role,
        "referralCode": referralCode,
        "longitude": longitude,
        "latitude": latitude,
        "radius": radius,
        "address": address,
        "phoneNumber": phoneNumber,
        "verified": verified,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
      };

  @override
  String toString() {
    return "$image, $id, $name, $email, $password, $age, $gender, $isOnline, $token, $role, $referralCode, $longitude, $latitude, $radius, $address, $phoneNumber, $verified, $createdAt, $v, ";
  }
}

class ProfileImage {
  ProfileImage({
    required this.url,
    required this.publicId,
  });

  final String url;
  final String publicId;

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
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

class CoachCreditBalance {
  CoachCreditBalance({
    required this.coachId,
    required this.credit,
  });

  final CoachInfo coachId;
  final num credit;

  factory CoachCreditBalance.fromJson(Map<String, dynamic> json) {
    // Handle both cases: coachId as string/ObjectId or as object
    dynamic coachIdData = json["coachId"];
    
    // If coachId is a string/ObjectId (during login), create a minimal CoachInfo
    if (coachIdData is String) {
      return CoachCreditBalance(
        coachId: CoachInfo(
          id: coachIdData,
          name: "Unknown Coach",
          image: null,
        ),
        credit: json["credit"] is num ? json["credit"] as num : (int.tryParse(json["credit"]?.toString() ?? "0") ?? 0),
      );
    }
    
    // If coachId is an object (from getProfile endpoint), parse it normally
    if (coachIdData is Map<String, dynamic>) {
      return CoachCreditBalance(
        coachId: CoachInfo.fromJson(coachIdData),
        credit: json["credit"] is num ? json["credit"] as num : (int.tryParse(json["credit"]?.toString() ?? "0") ?? 0),
      );
    }
    
    // Fallback: treat as empty object
    return CoachCreditBalance(
      coachId: CoachInfo.fromJson({}),
      credit: json["credit"] is num ? json["credit"] as num : (int.tryParse(json["credit"]?.toString() ?? "0") ?? 0),
    );
  }

  Map<String, dynamic> toJson() => {
        "coachId": coachId.toJson(),
        "credit": credit,
      };

  @override
  String toString() {
    return "CoachCreditBalance(coachId: $coachId, credit: $credit)";
  }
}

class CoachInfo {
  CoachInfo({
    required this.id,
    required this.name,
    this.image,
  });

  final String id;
  final String name;
  final ProfileImage? image;

  factory CoachInfo.fromJson(Map<String, dynamic> json) {
    // Handle empty map case (when coachId is just a string during login)
    if (json.isEmpty) {
      return CoachInfo(
        id: "",
        name: "Unknown Coach",
        image: null,
      );
    }
    
    return CoachInfo(
      id: json["_id"]?.toString() ?? json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "Unknown Coach",
      image: json["image"] != null && json["image"] is Map<String, dynamic> 
          ? ProfileImage.fromJson(json["image"] as Map<String, dynamic>) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image?.toJson(),
      };

  @override
  String toString() {
    return "CoachInfo(id: $id, name: $name, image: $image)";
  }
}

/*
{
	"image": {
		"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1705387702/coach/nqrveqs9zxzvgiwu0upa.jpg",
		"public_id": "coach/nqrveqs9zxzvgiwu0upa"
	},
	"_id": "65a626b95e1c51a2f368f1a4",
	"name": "Abhishek",
	"email": "jikoc26173@wuzak.com",
	"password": "$2a$10$/5Y9S7iE0QZSKQ8U1zHXD.Fdh8vNc.gjf9dheQPgc1oU3EKpLKlX2",
	"age": 25,
	"gender": "male",
	"isOnline": false,
	"token": 100,
	"role": "student",
	"referralCode": "JXJR432FZERQ",
	"longitude": 79.9338798,
	"latitude": 23.1685786,
	"radius": 30.581761006289316,
	"address": "Jabalpur, Madhya Pradesh, India",
	"phoneNumber": 1236549870,
	"verified": true,
	"createdAt": "2024-01-16T06:48:25.926Z",
	"__v": 0
}*/
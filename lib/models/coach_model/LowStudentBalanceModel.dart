class LowBalanceStudent {
  LowBalanceStudent({
     this.message,
     this.student,
  });

  final String? message;
  final List<StudentElement>? student;

  factory LowBalanceStudent.fromJson(Map<String, dynamic> json){
    return LowBalanceStudent(
      message: json["message"] ?? "",
      student: json["student"] == null ? [] : List<StudentElement>.from(json["student"]!.map((x) => StudentElement.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "student": student?.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$message, $student, ";
  }

}

class StudentElement {
  StudentElement({
    required this.id,
    required this.student,
    required this.children,
    required this.coach,
    required this.classScheduled,
    required this.v,
  });

  final String id;
  final StudentStudent? student;
  final Children? children;
  final String coach;
  final ClassScheduled? classScheduled;
  final int v;

  factory StudentElement.fromJson(Map<String, dynamic> json){
    return StudentElement(
      id: json["_id"] ?? "",
      student: json["student"] == null ? null : StudentStudent.fromJson(json["student"]),
      children: json["children"] == null ? null : Children.fromJson(json["children"]),
      coach: json["coach"] ?? "",
      classScheduled: json["classScheduled"] == null ? null : ClassScheduled.fromJson(json["classScheduled"]),
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "student": student?.toJson(),
    "children": children?.toJson(),
    "coach": coach,
    "classScheduled": classScheduled?.toJson(),
    "__v": v,
  };

  @override
  String toString(){
    return "$id, $student, $children, $coach, $classScheduled, $v, ";
  }

}

class Children {
  Children({
    required this.image,
    required this.id,
    required this.parent,
    required this.name,
    required this.age,
    required this.gender,
    required this.createdAt,
    required this.v,
  });

  final Image? image;
  final String id;
  final String parent;
  final String name;
  final int age;
  final String gender;
  final DateTime? createdAt;
  final int v;

  factory Children.fromJson(Map<String, dynamic> json){
    return Children(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? "",
      parent: json["parent"] ?? "",
      name: json["name"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "image": image?.toJson(),
    "_id": id,
    "parent": parent,
    "name": name,
    "age": age,
    "gender": gender,
    "createdAt": createdAt?.toIso8601String(),
    "__v": v,
  };

  @override
  String toString(){
    return "$image, $id, $parent, $name, $age, $gender, $createdAt, $v, ";
  }

}

class Image {
  Image({
    required this.url,
    required this.publicId,
  });

  final String url;
  final String publicId;

  factory Image.fromJson(Map<String, dynamic> json){
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
  String toString(){
    return "$url, $publicId, ";
  }

}

class ClassScheduled {
  ClassScheduled({
    required this.id,
    required this.classFess,
    this.typeOfClass,
    this.classDescription,
  });

  final String id;
  final int classFess;
  final String? typeOfClass;
  final String? classDescription;

  factory ClassScheduled.fromJson(Map<String, dynamic> json){
    return ClassScheduled(
      id: json["_id"] ?? "",
      classFess: json["classFess"] ?? 0,
      typeOfClass: json["typeOfClass"],
      classDescription: json["class_description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "classFess": classFess,
    "typeOfClass": typeOfClass,
    "class_description": classDescription,
  };

  @override
  String toString(){
    return "$id, $classFess, $typeOfClass, $classDescription, ";
  }

}

class StudentStudent {
  StudentStudent({
    required this.image,
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.token,
    this.credits = 0, // Default to 0, can be num (int or double)
    required this.role,
    required this.phoneNumber,
    required this.verified,
    required this.fcmToken,
    required this.coaches,
    required this.createdAt,
    required this.v,
  });

  final Image? image;
  final String id;
  final String name;
  final String email;
  final int age;
  final String gender;
  final num token; // Changed to num to handle double values from division
  final num credits; // Changed to num to handle double values from division
  final String role;
  final int phoneNumber;
  final bool verified;
  final String fcmToken;
  final List<String> coaches;
  final DateTime? createdAt;
  final int v;

  factory StudentStudent.fromJson(Map<String, dynamic> json){
    // Handle token - can be int, double, or null (from division, we might get double)
    num tokenValue = 0;
    if (json["token"] != null) {
      if (json["token"] is num) {
        tokenValue = json["token"] as num;
      } else if (json["token"] is String) {
        tokenValue = double.tryParse(json["token"]) ?? 0;
      } else {
        tokenValue = (json["token"] as num?) ?? 0;
      }
    }
    
    // Handle credits - can be int, double, or null (from division, we might get double)
    num creditsValue = 0;
    if (json["credits"] != null) {
      if (json["credits"] is num) {
        creditsValue = json["credits"] as num;
      } else if (json["credits"] is String) {
        creditsValue = double.tryParse(json["credits"]) ?? 0;
      } else {
        creditsValue = (json["credits"] as num?) ?? 0;
      }
    }
    
    return StudentStudent(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
      token: tokenValue,
      credits: creditsValue, // Parse credits from JSON, handling double/int
      role: json["role"] ?? "",
      phoneNumber: json["phoneNumber"] ?? 0,
      verified: json["verified"] ?? false,
      fcmToken: json["fcmToken"] ?? "",
      coaches: json["coaches"] == null ? [] : List<String>.from(json["coaches"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "image": image?.toJson(),
    "_id": id,
    "name": name,
    "email": email,
    "age": age,
    "gender": gender,
    "token": token,
    "credits": credits, // Include credits in JSON
    "role": role,
    "phoneNumber": phoneNumber,
    "verified": verified,
    "fcmToken": fcmToken,
    "coaches": coaches.map((x) => x).toList(),
    "createdAt": createdAt?.toIso8601String(),
    "__v": v,
  };

  @override
  String toString(){
    return "$image, $id, $name, $email, $age, $gender, $token, $credits, $role, $phoneNumber, $verified, $fcmToken, $coaches, $createdAt, $v, ";
  }

}

/*
{
	"message": "list of students",
	"student": [
		{
			"_id": "665d5ad9e7f0eba23a5a6b98",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d45c68fe874410f7a4d91",
				"name": "Jeet Chatterjee",
				"email": "sexec29119@avastu.com",
				"age": 20,
				"gender": "male",
				"token": 0,
				"role": "student",
				"phoneNumber": 6662431506,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T04:25:42.861Z",
				"__v": 1
			},
			"children": null,
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		},
		{
			"_id": "665d5adbe7f0eba23a5a6b9c",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4c0d86fd8464de6bbd7c",
				"name": "Abhi",
				"email": "yakig95135@avastu.com",
				"age": 25,
				"gender": "male",
				"token": 0,
				"role": "student",
				"phoneNumber": 7846454545,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T04:52:29.826Z",
				"__v": 1
			},
			"children": null,
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		},
		{
			"_id": "665d5adbe7f0eba23a5a6ba0",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4df186fd8464de6bbdc5",
				"name": "Abhishek",
				"email": "gonipay209@jahsec.com",
				"age": 55,
				"gender": "male",
				"token": 0,
				"role": "parent",
				"phoneNumber": 4646464646,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T05:00:33.401Z",
				"__v": 1
			},
			"children": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4e2286fd8464de6bbdd0",
				"parent": "665d4df186fd8464de6bbdc5",
				"name": "Shek",
				"age": 25,
				"gender": "male",
				"createdAt": "2024-06-03T05:01:22.969Z",
				"__v": 0
			},
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		},
		{
			"_id": "665d5adce7f0eba23a5a6ba4",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4df186fd8464de6bbdc5",
				"name": "Abhishek",
				"email": "gonipay209@jahsec.com",
				"age": 55,
				"gender": "male",
				"token": 0,
				"role": "parent",
				"phoneNumber": 4646464646,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T05:00:33.401Z",
				"__v": 1
			},
			"children": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4e2286fd8464de6bbdd2",
				"parent": "665d4df186fd8464de6bbdc5",
				"name": "Abhi",
				"age": 25,
				"gender": "male",
				"createdAt": "2024-06-03T05:01:22.974Z",
				"__v": 0
			},
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		},
		{
			"_id": "665da158af22333a35a22f66",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d45c68fe874410f7a4d91",
				"name": "Jeet Chatterjee",
				"email": "sexec29119@avastu.com",
				"age": 20,
				"gender": "male",
				"token": 0,
				"role": "student",
				"phoneNumber": 6662431506,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T04:25:42.861Z",
				"__v": 1
			},
			"children": null,
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		},
		{
			"_id": "665da159af22333a35a22f6a",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4c0d86fd8464de6bbd7c",
				"name": "Abhi",
				"email": "yakig95135@avastu.com",
				"age": 25,
				"gender": "male",
				"token": 0,
				"role": "student",
				"phoneNumber": 7846454545,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T04:52:29.826Z",
				"__v": 1
			},
			"children": null,
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		},
		{
			"_id": "665da159af22333a35a22f6e",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4df186fd8464de6bbdc5",
				"name": "Abhishek",
				"email": "gonipay209@jahsec.com",
				"age": 55,
				"gender": "male",
				"token": 0,
				"role": "parent",
				"phoneNumber": 4646464646,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T05:00:33.401Z",
				"__v": 1
			},
			"children": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4e2286fd8464de6bbdd0",
				"parent": "665d4df186fd8464de6bbdc5",
				"name": "Shek",
				"age": 25,
				"gender": "male",
				"createdAt": "2024-06-03T05:01:22.969Z",
				"__v": 0
			},
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		},
		{
			"_id": "665da159af22333a35a22f72",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4df186fd8464de6bbdc5",
				"name": "Abhishek",
				"email": "gonipay209@jahsec.com",
				"age": 55,
				"gender": "male",
				"token": 0,
				"role": "parent",
				"phoneNumber": 4646464646,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T05:00:33.401Z",
				"__v": 1
			},
			"children": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4e2286fd8464de6bbdd2",
				"parent": "665d4df186fd8464de6bbdc5",
				"name": "Abhi",
				"age": 25,
				"gender": "male",
				"createdAt": "2024-06-03T05:01:22.974Z",
				"__v": 0
			},
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		},
		{
			"_id": "665da1bfaf22333a35a22f8e",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d45c68fe874410f7a4d91",
				"name": "Jeet Chatterjee",
				"email": "sexec29119@avastu.com",
				"age": 20,
				"gender": "male",
				"token": 0,
				"role": "student",
				"phoneNumber": 6662431506,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T04:25:42.861Z",
				"__v": 1
			},
			"children": null,
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		},
		{
			"_id": "665da1c0af22333a35a22f92",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4c0d86fd8464de6bbd7c",
				"name": "Abhi",
				"email": "yakig95135@avastu.com",
				"age": 25,
				"gender": "male",
				"token": 0,
				"role": "student",
				"phoneNumber": 7846454545,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T04:52:29.826Z",
				"__v": 1
			},
			"children": null,
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		},
		{
			"_id": "665da1c0af22333a35a22f96",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4df186fd8464de6bbdc5",
				"name": "Abhishek",
				"email": "gonipay209@jahsec.com",
				"age": 55,
				"gender": "male",
				"token": 0,
				"role": "parent",
				"phoneNumber": 4646464646,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T05:00:33.401Z",
				"__v": 1
			},
			"children": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4e2286fd8464de6bbdd0",
				"parent": "665d4df186fd8464de6bbdc5",
				"name": "Shek",
				"age": 25,
				"gender": "male",
				"createdAt": "2024-06-03T05:01:22.969Z",
				"__v": 0
			},
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		},
		{
			"_id": "665da1c0af22333a35a22f9a",
			"student": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4df186fd8464de6bbdc5",
				"name": "Abhishek",
				"email": "gonipay209@jahsec.com",
				"age": 55,
				"gender": "male",
				"token": 0,
				"role": "parent",
				"phoneNumber": 4646464646,
				"verified": true,
				"fcmToken": "ckhSifufQHqm0HlsqMROGo:APA91bEfBCKWZltp-NZ9dctfwwMDUJ_HBDpa0JIW4fsndBayBjU1NWAoFdhTTEDI3wnbxW_o0fGNWnygiORCgNZkYoMQT-rTN6wXyfM1QW5CXXkHR1X1Wb4YU-g50xEl79HmwXT7GrkN",
				"coaches": [
					"665d44c38fe874410f7a4d84"
				],
				"createdAt": "2024-06-03T05:00:33.401Z",
				"__v": 1
			},
			"children": {
				"image": {
					"url": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
					"public_id": "coach/yfdnyfyywijcxsbvbabi"
				},
				"_id": "665d4e2286fd8464de6bbdd2",
				"parent": "665d4df186fd8464de6bbdc5",
				"name": "Abhi",
				"age": 25,
				"gender": "male",
				"createdAt": "2024-06-03T05:01:22.974Z",
				"__v": 0
			},
			"coach": "665d44c38fe874410f7a4d84",
			"classScheduled": {
				"_id": "665d537886fd8464de6bbe44",
				"classFess": 30
			},
			"__v": 0
		}
	]
}*/
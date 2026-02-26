class ClassDetailsCoachModel {
  ClassDetailsCoachModel({
    required this.upcomingSchedules,
    required this.pastSchedules,
    required this.pendingSchedules,
  });

  final List<Schedule> upcomingSchedules;
  final List<Schedule> pastSchedules;
  final List<Schedule> pendingSchedules;

  ClassDetailsCoachModel copyWith({
    List<Schedule>? upcomingSchedules,
    List<Schedule>? pastSchedules,
    List<Schedule>? pendingSchedules,
  }) {
    return ClassDetailsCoachModel(
      upcomingSchedules: upcomingSchedules ?? this.upcomingSchedules,
      pastSchedules: pastSchedules ?? this.pastSchedules,
      pendingSchedules: pendingSchedules ?? this.pendingSchedules,
    );
  }

  factory ClassDetailsCoachModel.fromJson(Map<String, dynamic> json) {
    return ClassDetailsCoachModel(
      upcomingSchedules: json["upcomingSchedules"] == null
          ? []
          : List<Schedule>.from(
              json["upcomingSchedules"]!.map((x) => Schedule.fromJson(x))),
      pastSchedules: json["pastSchedules"] == null
          ? []
          : List<Schedule>.from(
              json["pastSchedules"]!.map((x) => Schedule.fromJson(x))),
      pendingSchedules: json["pendingSchedules"] == null
          ? []
          : List<Schedule>.from(
              json["pendingSchedules"]!.map((x) => Schedule.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "upcomingSchedules": upcomingSchedules.map((x) => x.toJson()).toList(),
        "pastSchedules": pastSchedules.map((x) => x.toJson()).toList(),
        "pendingSchedules": pendingSchedules.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$upcomingSchedules, $pastSchedules, $pendingSchedules, ";
  }
}

class Schedule {
  Schedule({
    required this.id,
    required this.coach,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.location,
    required this.maxStudent,
    required this.availableSlots,
    required this.createdAt,
    required this.typeOfClass,
    required this.classFess,
    required this.longitude,
    required this.latitude,
    required this.participants,
    required this.isInSchedule,
    required this.v,
    required this.enrolled,
  });

  final String id;
  final String coach;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? day;
  final String location;
  final num maxStudent;
  final num availableSlots;
  final DateTime? createdAt;
  final String typeOfClass;
  final num classFess;
  final num longitude;
  final num latitude;
  final List<Participant> participants;
  final bool isInSchedule;
  final num v;
  final num enrolled;

  Schedule copyWith({
    String? id,
    String? coach,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? day,
    String? location,
    num? maxStudent,
    num? availableSlots,
    DateTime? createdAt,
    String? typeOfClass,
    num? classFess,
    num? longitude,
    num? latitude,
    List<Participant>? participants,
    bool? isInSchedule,
    num? v,
    num? enrolled,
  }) {
    return Schedule(
      id: id ?? this.id,
      coach: coach ?? this.coach,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      day: day ?? this.day,
      location: location ?? this.location,
      maxStudent: maxStudent ?? this.maxStudent,
      availableSlots: availableSlots ?? this.availableSlots,
      createdAt: createdAt ?? this.createdAt,
      typeOfClass: typeOfClass ?? this.typeOfClass,
      classFess: classFess ?? this.classFess,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      participants: participants ?? this.participants,
      isInSchedule: isInSchedule ?? this.isInSchedule,
      v: v ?? this.v,
      enrolled: enrolled ?? this.enrolled,
    );
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json["_id"] ?? "",
      coach: json["coach"] ?? "",
      startTime: DateTime.tryParse(json["startTime"] ?? "")?.toLocal(),
      endTime: DateTime.tryParse(json["endTime"] ?? "")?.toLocal(),
      day: DateTime.tryParse(json["day"] ?? ""),
      location: json["location"] ?? "",
      maxStudent: json["maxStudent"] ?? 0,
      availableSlots: json["availableSlots"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      typeOfClass: json["typeOfClass"] ?? "",
      classFess: json["classFess"] ?? 0,
      longitude: json["longitude"] ?? 0,
      latitude: json["latitude"] ?? 0,
      participants: json["participants"] == null
          ? []
          : List<Participant>.from(
              json["participants"]!.map((x) => Participant.fromJson(x))),
      isInSchedule: json["isInSchedule"] ?? false,
      v: json["__v"] ?? 0,
      enrolled: json["enrolled"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "coach": coach,
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
        "day": day?.toIso8601String(),
        "location": location,
        "maxStudent": maxStudent,
        "availableSlots": availableSlots,
        "createdAt": createdAt?.toIso8601String(),
        "typeOfClass": typeOfClass,
        "classFess": classFess,
        "longitude": longitude,
        "latitude": latitude,
        "participants": participants.map((x) => x.toJson()).toList(),
        "isInSchedule": isInSchedule,
        "__v": v,
        "enrolled": enrolled,
      };

  @override
  String toString() {
    return "$id, $coach, $startTime, $endTime, $day, $location, $maxStudent, $availableSlots, $createdAt, $typeOfClass, $classFess, $longitude, $latitude, $participants, $isInSchedule, $v, $enrolled, ";
  }
}

class Participant {
  Participant({
    required this.image,
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.token,
    required this.role,
    required this.phoneNumber,
  });

  final Image? image;
  final String id;
  final String name;
  final String email;
  final num age;
  final String gender;
  final num token;
  final String role;
  final num phoneNumber;

  Participant copyWith({
    Image? image,
    String? id,
    String? name,
    String? email,
    num? age,
    String? gender,
    num? token,
    String? role,
    num? phoneNumber,
  }) {
    return Participant(
      image: image ?? this.image,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      token: token ?? this.token,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
      token: json["token"] ?? 0,
      role: json["role"] ?? "",
      phoneNumber: json["phoneNumber"] ?? 0,
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
        "role": role,
        "phoneNumber": phoneNumber,
      };

  @override
  String toString() {
    return "$image, $id, $name, $email, $age, $gender, $token, $role, $phoneNumber, ";
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
	"upcomingSchedules": [
		{
			"_id": "65def27fc029f1304b2ac4bf",
			"coach": "65d449b0afc22b4f184e65b3",
			"startTime": "2024-02-29T11:01:00.000Z",
			"endTime": "2024-02-29T12:00:00.000Z",
			"day": "2024-02-28T18:30:00.000Z",
			"location": "location",
			"maxStudent": 24,
			"availableSlots": 24,
			"createdAt": "2024-02-28T08:43:23.410Z",
			"typeOfClass": "cricket",
			"classFess": 20,
			"longitude": 2323,
			"latitude": 2323,
			"participants": [],
			"isInSchedule": true,
			"__v": 0
		},
		{
			"_id": "65def373703869cdbf63361a",
			"coach": "65d449b0afc22b4f184e65b3",
			"startTime": "2024-02-29T12:01:00.000Z",
			"endTime": "2024-02-29T13:00:00.000Z",
			"day": "2024-02-28T18:30:00.000Z",
			"location": "location",
			"maxStudent": 24,
			"availableSlots": 24,
			"createdAt": "2024-02-28T08:48:28.239Z",
			"typeOfClass": "cricket",
			"classFess": 20,
			"longitude": 2323,
			"latitude": 2323,
			"participants": [],
			"isInSchedule": true,
			"__v": 0
		}
	],
	"pastSchedules": [
		{
			"_id": "65d83b352e3ce531a26b26ed",
			"coach": "65d449b0afc22b4f184e65b3",
			"startTime": "2024-02-25T03:01:00.000Z",
			"endTime": "2024-02-25T04:00:00.000Z",
			"day": "2024-02-24T18:30:00.000Z",
			"location": "location",
			"maxStudent": 24,
			"availableSlots": 24,
			"createdAt": "2024-02-23T06:26:30.776Z",
			"typeOfClass": "cricket",
			"classFess": 20,
			"longitude": 2323,
			"latitude": 2323,
			"participants": [
				{
					"image": {
						"public_id": "coach/od26dpmi6mnhqpkghuln",
						"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1708946236/coach/od26dpmi6mnhqpkghuln.jpg"
					},
					"_id": "65d863676236d8d64e682924",
					"name": "Pradeep",
					"email": "lebaso8614@molyg.com",
					"age": 20,
					"gender": "male",
					"token": 35,
					"role": "parent",
					"phoneNumber": 7974988355
				}
			],
			"isInSchedule": true,
			"__v": 2,
			"enrolled": 1
		},
		{
			"_id": "65dc21a70af89faab51a05e5",
			"coach": "65d449b0afc22b4f184e65b3",
			"startTime": "2024-02-26T10:00:00.000Z",
			"endTime": "2024-02-26T14:00:00.000Z",
			"day": "2024-02-26T00:00:00.000Z",
			"location": "Mohali, Punjab, India",
			"maxStudent": 15,
			"availableSlots": 15,
			"createdAt": "2024-02-26T04:50:42.275Z",
			"typeOfClass": "PhySci",
			"classFess": 35,
			"longitude": 76.71787259999999,
			"latitude": 30.7046486,
			"participants": [
				{
					"image": {
						"public_id": "coach/od26dpmi6mnhqpkghuln",
						"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1708946236/coach/od26dpmi6mnhqpkghuln.jpg"
					},
					"_id": "65d863676236d8d64e682924",
					"name": "Pradeep",
					"email": "lebaso8614@molyg.com",
					"age": 20,
					"gender": "male",
					"token": 35,
					"role": "parent",
					"phoneNumber": 7974988355
				}
			],
			"isInSchedule": true,
			"__v": 1,
			"enrolled": 1
		},
		{
			"_id": "65dec49740b3c2d5930f04e6",
			"coach": "65d449b0afc22b4f184e65b3",
			"startTime": "2024-02-28T11:00:00.000Z",
			"endTime": "2024-02-28T13:00:00.000Z",
			"day": "2024-02-28T00:00:00.000Z",
			"location": "Mohali, Punjab, India",
			"maxStudent": 15,
			"availableSlots": 15,
			"createdAt": "2024-02-28T05:26:39.769Z",
			"typeOfClass": "Music class ",
			"classFess": 50,
			"longitude": 76.71787259999999,
			"latitude": 30.7046486,
			"participants": [
				{
					"image": {
						"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1708931350/coach/mqethq6hjm2idhp8sbsz.jpg",
						"public_id": "coach/mqethq6hjm2idhp8sbsz"
					},
					"_id": "65dc391692969cf5bd380d70",
					"name": "abhishek",
					"email": "giweg99663@lendfash.com",
					"age": 22,
					"gender": "male",
					"token": 50,
					"role": "student",
					"phoneNumber": 785478543
				}
			],
			"isInSchedule": true,
			"__v": 1,
			"enrolled": 1
		}
	],
	"pendingSchedules": [
		{
			"_id": "65d9774b93a774135f721db7",
			"coach": "65d449b0afc22b4f184e65b3",
			"startTime": "2024-02-24T10:26:00.000Z",
			"endTime": "2024-02-24T10:30:00.000Z",
			"day": "2024-02-24T00:00:00.000Z",
			"location": "Mohali, Punjab, India",
			"maxStudent": 30,
			"availableSlots": 30,
			"createdAt": "2024-02-24T04:52:02.881Z",
			"typeOfClass": "had",
			"classFess": 55,
			"longitude": 76.71787259999999,
			"latitude": 30.7046486,
			"participants": [],
			"isInSchedule": true,
			"__v": 2,
			"enrolled": 0
		},
		{
			"_id": "65d9d3e6b683594bb9955f92",
			"coach": "65d449b0afc22b4f184e65b3",
			"startTime": "2024-02-24T15:00:00.000Z",
			"endTime": "2024-02-24T15:03:00.000Z",
			"day": "2024-02-24T00:00:00.000Z",
			"location": "Mohali, Punjab, India",
			"maxStudent": 35,
			"availableSlots": 35,
			"createdAt": "2024-02-24T11:23:27.676Z",
			"typeOfClass": "kkk",
			"classFess": 90,
			"longitude": 76.71787259999999,
			"latitude": 30.7046486,
			"participants": [],
			"isInSchedule": true,
			"__v": 0,
			"enrolled": 0
		}
	]
}*/
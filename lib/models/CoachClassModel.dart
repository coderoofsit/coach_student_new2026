class CoachClassesModel {
  CoachClassesModel({
    this.id,
    this.coach,
    this.startTime,
    this.endTime,
    this.day,
    this.location,
    this.maxStudent,
    this.availableSlots,
    this.createdAt,
    this.typeOfClass,
    this.classFess,
    this.longitude,
    this.latitude,
    this.participants,
    this.isInSchedule,
    this.v,
    this.enrolled,
  });

  final String? id;
  final Coach? coach;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? day;
  final String? location;
  final int? maxStudent;
  final int? availableSlots;
  final DateTime? createdAt;
  final String? typeOfClass;
  final int? classFess;
  final String? longitude;
  final String? latitude;
  final List<String>? participants;
  final bool? isInSchedule;
  final int? v;
  final int? enrolled;

  factory CoachClassesModel.fromJson(Map<String, dynamic> json) {
    return CoachClassesModel(
      id: json["_id"] ?? "",
      coach: json["coach"] == null ? null : Coach.fromJson(json["coach"]),
      startTime: DateTime.tryParse(json["startTime"] ?? ""),
      endTime: DateTime.tryParse(json["endTime"] ?? ""),
      day: DateTime.tryParse(json["day"] ?? ""),
      location: json["location"] ?? "",
      maxStudent: json["maxStudent"] ?? 0,
      availableSlots: json["availableSlots"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      typeOfClass: json["typeOfClass"] ?? "",
      classFess: json["classFess"] ?? 0,
      longitude: json["longitude"]?.toString() ?? "0",
      latitude: json["latitude"]?.toString() ?? "0",
      participants: json["participants"] == null
          ? []
          : (json["participants"] as List).map<String>((x) {
              // Handle both string and object formats for backward compatibility
              if (x is String) {
                return x;
              } else if (x is Map<String, dynamic>) {
                // New format: object with participantId, participantType, _id
                return (x["participantId"]?.toString() ?? 
                       x["_id"]?.toString() ?? "");
              }
              return "";
            }).where((id) => id.isNotEmpty).toList(),
      isInSchedule: json["isInSchedule"] ?? false,
      v: json["__v"] ?? 0,
      enrolled: json["enrolled"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "coach": coach?.toJson(),
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
        "participants": participants?.map((x) => x).toList(),
        "isInSchedule": isInSchedule,
        "__v": v,
        "enrolled": enrolled,
      };

  @override
  String toString() {
    return "$id, $coach, $startTime, $endTime, $day, $location, $maxStudent, $availableSlots, $createdAt, $typeOfClass, $classFess, $longitude, $latitude, $participants, $isInSchedule, $v, $enrolled, ";
  }
}

class Coach {
  Coach({
    required this.image,
    required this.id,
    required this.name,
    required this.email,
    required this.passcode,
    required this.about,
    required this.phoneNumber,
  });

  final Image? image;
  final String id;
  final String name;
  final String email;
  final int passcode;
  final String about;
  final int phoneNumber;

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      passcode: json["passcode"] ?? 0,
      about: json["about"] ?? "",
      phoneNumber: json["phoneNumber"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "image": image?.toJson(),
        "_id": id,
        "name": name,
        "email": email,
        "passcode": passcode,
        "about": about,
        "phoneNumber": phoneNumber,
      };

  @override
  String toString() {
    return "$image, $id, $name, $email, $passcode, $about, $phoneNumber, ";
  }
}

class Image {
  Image({
    required this.publicId,
    required this.url,
  });

  final String publicId;
  final String url;

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
	"_id": "65e0490b8ae3aceb45aec3bf",
	"coach": {
		"image": {
			"public_id": "coach/guv3hcigix4jzvreqqa2",
			"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1709116512/coach/guv3hcigix4jzvreqqa2.jpg"
		},
		"_id": "65d449b0afc22b4f184e65b3",
		"name": "Chandan",
		"email": "kumarchandandbg2@gmail.com",
		"passcode": 70332784,
		"about": "Abhi bhi Prepare for a career in data science by learning how to s problems in a master's program that goes beyond the ab No application required. St This master's program is designed to help you understand how to make sense of data using high-level m science. As you pursue this degree, you'll have many opportunities to become skilled at communicating UGrow your confidence to perform practical applications Workyour way through core courses on statistics, machine learning, project management, big data, and more With a Master of Data Science degree from Illinois Tech, you will know how to analyze data and visualize r articulate your discoveries, too, which is equally important. When you graduate from this program, you wil the structure of available data, create and evaluate models, and construct and test hypotheses. 0 Beready to do exciting and important work with data With this master's degree, you'll be highly qualified for all kinds of jobs that require data science skills and more.",
		"phoneNumber": 9525443159
	},
	"startTime": "2024-03-01T10:01:00.000Z",
	"endTime": "2024-03-01T11:00:00.000Z",
	"day": "2024-02-29T18:30:00.000Z",
	"location": "location",
	"maxStudent": 24,
	"availableSlots": 24,
	"createdAt": "2024-02-29T09:04:29.348Z",
	"typeOfClass": "cricket",
	"classFess": 20,
	"longitude": 2323,
	"latitude": 2323,
	"participants": [
		"65dc391692969cf5bd380d70"
	],
	"isInSchedule": true,
	"__v": 2,
	"enrolled": 1
}*/
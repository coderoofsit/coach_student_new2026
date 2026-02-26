class CoachChatModel {
  CoachChatModel({
    this.isRead,
    this.lasMsgTime = 0,
    required this.imageUrl,
    required this.name,
    required this.userId,
    this.isSelected = false,
    this.coachType,
  });

  final bool? isRead;
  final int lasMsgTime;
  final String imageUrl;
  final String name;
  final String userId;
  bool isSelected;
  String? coachType;
  String? phoneNumber;
  String? email;
  String? passcode;

  factory CoachChatModel.fromJson(Map<String, dynamic> json) {
    return CoachChatModel(
      isRead: json["is_read"] ?? false,
      lasMsgTime: json["lasMsgTime"] ?? 0,
      imageUrl: json["image_url"] ?? "",
      name: json["name"] ?? "",
      userId: json["userId"] ?? "",
      isSelected: json["isSelected"] ?? false,
      coachType: json["coachType"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "is_read": isRead,
        "lasMsgTime": lasMsgTime,
        "image_url": imageUrl,
        "name": name,
        "userId": userId,
        "isSelected": isSelected,
        "coachType": coachType
      };

  @override
  String toString() {
    return "$isRead, $lasMsgTime, $imageUrl, $name, $userId, $isSelected, ";
  }
}

/*
{
	"is_read": false,
	"lasMsgTime": 1708777647671,
	"image_url": "https://res.cloudinary.com/dc8piabne/image/upload/v1708770541/coach/fmekz6l4df3gqj17b2ed.jpg",
	"name": "Abhishek C",
	"userId": "65d449b0afc22b4f184e65b3",
	"isSelected": false
}*/
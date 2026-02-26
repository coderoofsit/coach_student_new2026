class CoachModel {
  CoachModel({
    required this.coachName,
    required this.coachType,
    required this.imageUrl,
    required this.id,
    required this.location,
    required this.token,
  });

  final String coachName;
  final String coachType;
  final String imageUrl;
  final String id;
  final String location;
  final String token;

  factory CoachModel.fromJson(Map<String, dynamic> json){
    return CoachModel(
      coachName: json["CoachName"] ?? "",
      coachType: json["coachType"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      id: json["id"] ?? "",
      location: json["location"] ?? "",
      token: json["token"].toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "CoachName": coachName,
    "coachType": coachType,
    "imageUrl": imageUrl,
    "id": id,
    "location": location,
    "token": token,
  };

  @override
  String toString(){
    return "$coachName, $coachType, $imageUrl, $id, $location, $token, ";
  }

}

/*
{
	"CoachName": "Jessica Huels III",
	"coachType": "Cricket Coach",
	"imageUrl": "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/376.jpg",
	"id": "1",
	"location": "Mohali , punjab",
	"token": "15"
}*/
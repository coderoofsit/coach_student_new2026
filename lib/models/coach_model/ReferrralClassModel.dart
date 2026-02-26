class ReferrelClassModel {
  ReferrelClassModel({
     this.referrerId,
     this.referredUserId,
     this.referralCode,
     this.rewardedToken,
     this.id,
     this.createdAt,
     this.updatedAt,
     this.v,
  });

  final String? referrerId;
  final String? referredUserId;
  final String? referralCode;
  final int? rewardedToken;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory ReferrelClassModel.fromJson(Map<String, dynamic> json){
    return ReferrelClassModel(
      referrerId: json["referrerId"] ?? "",
      referredUserId: json["referredUserId"] ?? "",
      referralCode: json["referralCode"] ?? "",
      rewardedToken: json["rewardedToken"] ?? 0,
      id: json["_id"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "referrerId": referrerId,
    "referredUserId": referredUserId,
    "referralCode": referralCode,
    "rewardedToken": rewardedToken,
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };

  @override
  String toString(){
    return "$referrerId, $referredUserId, $referralCode, $rewardedToken, $id, $createdAt, $updatedAt, $v, ";
  }

}

/*
{
	"referrerId": "65d863676236d8d64e682924",
	"referredUserId": "6597eed8e6e10ff50122efb0",
	"referralCode": "TCX8NIVEZMXH",
	"rewardedToken": 5,
	"_id": "65dec6b540b3c2d5930f0501",
	"createdAt": "2024-02-28T05:37:57.171Z",
	"updatedAt": "2024-02-28T05:37:57.171Z",
	"__v": 0
}*/
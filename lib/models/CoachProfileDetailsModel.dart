class CoachProfileDetailsModel {
  CoachProfileDetailsModel({
    this.image,
    this.id,
    this.name,
    this.timeZone,
    this.coachType,
    this.gender,
    this.email,
    this.token,
    this.isOnline,
    this.role,
    this.referralCode,
    this.passcode,
    this.about,
    this.longitude,
    this.latitude,
    this.radius,
    this.chargePerHour,
    this.phoneNumber,
    this.address,
    this.verified,
    this.clients,
    this.createdAt,
    this.isSubscribed,
    this.activePlan,
    this.hasAccess = false,
    this.accessReason,
    this.trialExpiryDate,
    this.subscriptionExpiryDate,
  });

  final Image? image;
  final String? id;
  final String? name;
  final String? timeZone;
  final String? coachType;
  final String? gender;
  final String? email;
  final num? token;
  final bool? isOnline;
  final String? role;
  String? referralCode;
  final num? passcode;
  final String? about;
  final num? longitude;
  final num? latitude;
  final num? radius;
  final num? chargePerHour;
  final num? phoneNumber;
  final String? address;
  final bool? verified;
  final List<dynamic>? clients;
  final DateTime? createdAt;
  final bool? isSubscribed;
  final String? activePlan;
  final bool hasAccess;
  final String? accessReason;
  final DateTime? trialExpiryDate;
  final DateTime? subscriptionExpiryDate;

  CoachProfileDetailsModel copyWith({
    Image? image,
    String? id,
    String? name,
    String? coachType,
    String? gender,
    String? email,
    num? token,
    bool? isOnline,
    String? role,
    String? referralCode,
    num? passcode,
    String? about,
    num? longitude,
    num? latitude,
    num? radius,
    num? chargePerHour,
    num? phoneNumber,
    String? address,
    bool? verified,
    List<dynamic>? clients,
    DateTime? createdAt,
    bool? isSubscribed,
    String? activePlan,
    bool? hasAccess,
    String? accessReason,
    DateTime? trialExpiryDate,
    DateTime? subscriptionExpiryDate,
  }) {
    return CoachProfileDetailsModel(
      image: image ?? this.image,
      id: id ?? this.id,
      name: name ?? this.name,
      coachType: coachType ?? this.coachType,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      token: token ?? this.token,
      isOnline: isOnline ?? this.isOnline,
      role: role ?? this.role,
      referralCode: referralCode ?? this.referralCode,
      passcode: passcode ?? this.passcode,
      about: about ?? this.about,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      radius: radius ?? this.radius,
      chargePerHour: chargePerHour ?? this.chargePerHour,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      verified: verified ?? this.verified,
      clients: clients ?? this.clients,
      createdAt: createdAt ?? this.createdAt,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      activePlan: activePlan ?? this.activePlan,
      hasAccess: hasAccess ?? this.hasAccess,
      accessReason: accessReason ?? this.accessReason,
      trialExpiryDate: trialExpiryDate ?? this.trialExpiryDate,
      subscriptionExpiryDate: subscriptionExpiryDate ?? this.subscriptionExpiryDate,
    );
  }

  factory CoachProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    return CoachProfileDetailsModel(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      timeZone: json["timeZone"] ?? "",
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      coachType: json["coachType"] ?? "",
      gender: json["gender"] ?? "",
      email: json["email"] ?? "",
      token: json["token"] ?? 0,
      isOnline: json["isOnline"] ?? false,
      role: json["role"] ?? "",
      referralCode: json["referralCode"] ?? "",
      passcode: json["passcode"] ?? 0,
      about: json["about"] ?? "",
      longitude: json["longitude"] ?? 0,
      latitude: json["latitude"] ?? 0,
      radius: json["radius"] ?? 0,
      chargePerHour: json["chargePerHour"] ?? 0,
      phoneNumber: json["phoneNumber"] ?? 0,
      address: json["address"] ?? "",
      verified: json["verified"] ?? false,
      clients: json["clients"] == null
          ? []
          : List<dynamic>.from(json["clients"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      isSubscribed: json["isSubscribed"] ?? false,
      activePlan: json["activePlan"] ?? "",
      hasAccess: json["hasAccess"] ?? false,
      accessReason: json["accessReason"],
      trialExpiryDate: json["trialExpiryDate"] == null ? null : DateTime.tryParse(json["trialExpiryDate"]),
      subscriptionExpiryDate: json["subscriptionExpiryDate"] == null ? null : DateTime.tryParse(json["subscriptionExpiryDate"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "image": image?.toJson(),
        "_id": id,
        "name": name,
        "coachType": coachType,
        "gender": gender,
        "email": email,
        "token": token,
        "isOnline": isOnline,
        "role": role,
        "referralCode": referralCode,
        "passcode": passcode,
        "about": about,
        "longitude": longitude,
        "latitude": latitude,
        "radius": radius,
        "chargePerHour": chargePerHour,
        "phoneNumber": phoneNumber,
        "address": address,
        "verified": verified,
        "timeZone": timeZone,
        "clients": clients?.map((x) => x).toList(),
        "createdAt": createdAt?.toIso8601String(),
        "isSubscribed": isSubscribed,
        "activePlan": activePlan,
        "hasAccess": hasAccess,
        "accessReason": accessReason,
        "trialExpiryDate": trialExpiryDate?.toIso8601String(),
        "subscriptionExpiryDate": subscriptionExpiryDate?.toIso8601String(),
      };

  int get trialDaysLeft {
    if (trialExpiryDate == null) return 0;
    final now = DateTime.now();
    if (trialExpiryDate!.isBefore(now)) return 0;
    return trialExpiryDate!.difference(now).inDays;
  }

  int get subscriptionDaysLeft {
    if (subscriptionExpiryDate == null) return 0;
    final now = DateTime.now();
    if (subscriptionExpiryDate!.isBefore(now)) return 0;
    return subscriptionExpiryDate!.difference(now).inDays;
  }

  // The access status is now managed by the backend
  // bool get isTrialActive {
  //   if (createdAt == null) return true; // Assume new users have trial
  //   final difference = DateTime.now().difference(createdAt!);
  //   return difference.inDays <= 14;
  // }

  // bool get hasAccess => (isSubscribed ?? false) || isTrialActive;
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
}

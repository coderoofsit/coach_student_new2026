class TranscationHistoryCoach {
  TranscationHistoryCoach({
    required this.transaction,
  });

  final List<Transaction> transaction;

  TranscationHistoryCoach copyWith({
    List<Transaction>? transaction,
  }) {
    return TranscationHistoryCoach(
      transaction: transaction ?? this.transaction,
    );
  }

  factory TranscationHistoryCoach.fromJson(Map<String, dynamic> json) {
    return TranscationHistoryCoach(
      transaction: json["transaction"] == null
          ? []
          : List<Transaction>.from(
              json["transaction"]!.map((x) => Transaction.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "transaction": transaction.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$transaction, ";
  }
}

class Transaction {
  Transaction({
    required this.id,
    required this.user,
    required this.message,
    required this.transactionWith,
    required this.type,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.payoutBatchId,
    this.status,
    this.childrenId,
    this.balanceType = 'token',
    this.creditAmount = 0,
    this.tokenAmount = 0,
  });

  final String id;
  final String user;
  final String message;
  final With? transactionWith;
  final String type;
  final num token;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num v;
  final String? payoutBatchId;
  final String? status;
  final Children? childrenId;
  final String balanceType;
  final num creditAmount;
  final num tokenAmount;

  Transaction copyWith({
    String? id,
    String? user,
    String? message,
    With? transactionWith,
    String? type,
    num? token,
    DateTime? createdAt,
    DateTime? updatedAt,
    num? v,
    String? payoutBatchId,
    String? status,
    Children? childrenId,
    String? balanceType,
    num? creditAmount,
    num? tokenAmount,
  }) {
    return Transaction(
      id: id ?? this.id,
      user: user ?? this.user,
      message: message ?? this.message,
      transactionWith: transactionWith ?? this.transactionWith,
      type: type ?? this.type,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      payoutBatchId: payoutBatchId ?? this.payoutBatchId,
      status: status ?? this.status,
      childrenId: childrenId ?? this.childrenId,
      balanceType: balanceType ?? this.balanceType,
      creditAmount: creditAmount ?? this.creditAmount,
      tokenAmount: tokenAmount ?? this.tokenAmount,
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // Parse creditAmount and tokenAmount explicitly
    // Handle both new format (with creditAmount/tokenAmount) and legacy format (only token + balanceType)
    num creditAmt = 0;
    num tokenAmt = 0;
    final tokenValue = json["token"] is num ? json["token"] as num : (int.tryParse(json["token"]?.toString() ?? "0") ?? 0);
    final balanceType = json["balanceType"] ?? "token";
    
    // Check if new fields exist in JSON response (key exists, even if value is 0)
    final hasCreditAmountKey = json.containsKey("creditAmount");
    final hasTokenAmountKey = json.containsKey("tokenAmount");
    
    // Parse creditAmount if key exists
    if (hasCreditAmountKey) {
      final val = json["creditAmount"];
      if (val != null) {
        if (val is num) {
          creditAmt = val;
        } else if (val is String) {
          creditAmt = double.tryParse(val) ?? 0;
        } else {
          creditAmt = (val as num?) ?? 0;
        }
      }
      // Even if value is 0, we know the field exists, so keep it as 0
    }
    
    // Parse tokenAmount if key exists
    if (hasTokenAmountKey) {
      final val = json["tokenAmount"];
      if (val != null) {
        if (val is num) {
          tokenAmt = val;
        } else if (val is String) {
          tokenAmt = double.tryParse(val) ?? 0;
        } else {
          tokenAmt = (val as num?) ?? 0;
        }
      }
      // Even if value is 0, we know the field exists, so keep it as 0
    }
    
    // Debug: Print what we're parsing
    print("=== Parsing Transaction ===");
    print("ID: ${json["_id"]}");
    print("hasCreditAmountKey: $hasCreditAmountKey, creditAmt: $creditAmt");
    print("hasTokenAmountKey: $hasTokenAmountKey, tokenAmt: $tokenAmt");
    print("token: $tokenValue, balanceType: $balanceType");
    
    // If new fields don't exist (legacy transactions), derive from balanceType and token
    if (!hasCreditAmountKey && !hasTokenAmountKey) {
      // Old transaction format - derive from balanceType
      print("Legacy transaction - deriving from balanceType");
      if (balanceType == "credit") {
        creditAmt = tokenValue;
        tokenAmt = 0;
      } else {
        creditAmt = 0;
        tokenAmt = tokenValue;
      }
      print("Derived - creditAmt: $creditAmt, tokenAmt: $tokenAmt");
    }
    // If only one field exists, the other remains 0 (already initialized above)
    
    print("Final - creditAmt: $creditAmt, tokenAmt: $tokenAmt");
    print("========================");
    
    // Handle 'with' field - it might be an object (populated) or a string (ObjectId)
    With? transactionWith;
    if (json["with"] != null) {
      if (json["with"] is Map<String, dynamic>) {
        // It's a populated object
        try {
          transactionWith = With.fromJson(json["with"] as Map<String, dynamic>);
        } catch (e) {
          print("Error parsing 'with' field: $e");
          transactionWith = null;
        }
      } else {
        // It's likely a string ObjectId that wasn't populated - set to null
        transactionWith = null;
      }
    }
    
    return Transaction(
      id: json["_id"] ?? "",
      user: json["user"] ?? "",
      message: json["message"] ?? "",
      transactionWith: transactionWith,
      type: json["type"] ?? "",
      token: tokenValue,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"] ?? 0,
      payoutBatchId: json["payoutBatchId"] ?? json["payout_batch_id"],
      status: json["status"],
      childrenId: json["childrenId"] == null ? null : Children.fromJson(json["childrenId"]),
      balanceType: balanceType,
      creditAmount: creditAmt,
      tokenAmount: tokenAmt,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "message": message,
        "with": transactionWith?.toJson(),
        "type": type,
        "token": token,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "payoutBatchId": payoutBatchId,
        "status": status,
        "childrenId": childrenId?.toJson(),
        "balanceType": balanceType,
        "creditAmount": creditAmount,
        "tokenAmount": tokenAmount,
      };

  @override
  String toString() {
    return "$id, $user, $message, $transactionWith, $type, $token, $createdAt, $updatedAt, $v, $payoutBatchId, $status, $childrenId, $balanceType, $creditAmount, $tokenAmount, ";
  }
}

class With {
  With({
    required this.image,
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.role,
  });

  final Image? image;
  final String id;
  final String name;
  final num age;
  final String gender;
  final String role;

  With copyWith({
    Image? image,
    String? id,
    String? name,
    num? age,
    String? gender,
    String? role,
  }) {
    return With(
      image: image ?? this.image,
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      role: role ?? this.role,
    );
  }

  factory With.fromJson(Map<String, dynamic> json) {
    return With(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
      role: json["role"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "image": image?.toJson(),
        "_id": id,
        "name": name,
        "age": age,
        "gender": gender,
        "role": role,
      };

  @override
  String toString() {
    return "$image, $id, $name, $age, $gender, $role, ";
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

class Children {
  Children({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
  });

  final String id;
  final String name;
  final num age;
  final String gender;

  Children copyWith({
    String? id,
    String? name,
    num? age,
    String? gender,
  }) {
    return Children(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }

  factory Children.fromJson(Map<String, dynamic> json) {
    return Children(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "age": age,
        "gender": gender,
      };

  @override
  String toString() {
    return "$id, $name, $age, $gender, ";
  }
}

/*
{
	"transaction": [
		{
			"_id": "65ded08a28225016a009b471",
			"user": "65d449b0afc22b4f184e65b3",
			"message": "On attending the Music class  class, abhishek paid you 50 tokens.",
			"with": {
				"image": {
					"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1708931350/coach/mqethq6hjm2idhp8sbsz.jpg",
					"public_id": "coach/mqethq6hjm2idhp8sbsz"
				},
				"_id": "65dc391692969cf5bd380d70",
				"name": "abhishek",
				"age": 22,
				"gender": "male",
				"role": "student"
			},
			"type": "increase",
			"token": 50,
			"createdAt": "2024-02-28T06:19:54.825Z",
			"updatedAt": "2024-02-28T06:19:54.825Z",
			"__v": 0
		},
		{
			"_id": "65dc35010d3ab4a6d28331aa",
			"user": "65d449b0afc22b4f184e65b3",
			"message": "On attending the PhySci class, Abhishek paid you 35 tokens.",
			"with": {
				"image": {
					"public_id": "coach/od26dpmi6mnhqpkghuln",
					"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1708946236/coach/od26dpmi6mnhqpkghuln.jpg"
				},
				"_id": "65d863676236d8d64e682924",
				"name": "Pradeep",
				"age": 20,
				"gender": "male",
				"role": "parent"
			},
			"type": "increase",
			"token": 35,
			"createdAt": "2024-02-26T06:51:45.000Z",
			"updatedAt": "2024-02-26T06:51:45.000Z",
			"__v": 0
		},
		{
			"_id": "65d9786493a774135f721dec",
			"user": "65d449b0afc22b4f184e65b3",
			"message": "On attending the had class, Abhishek paid you 55 tokens.",
			"with": {
				"image": {
					"public_id": "coach/od26dpmi6mnhqpkghuln",
					"url": "https://res.cloudinary.com/dc8piabne/image/upload/v1708946236/coach/od26dpmi6mnhqpkghuln.jpg"
				},
				"_id": "65d863676236d8d64e682924",
				"name": "Pradeep",
				"age": 20,
				"gender": "male",
				"role": "parent"
			},
			"type": "increase",
			"token": 55,
			"createdAt": "2024-02-24T05:02:28.924Z",
			"updatedAt": "2024-02-24T05:02:28.924Z",
			"__v": 0
		},
		{
			"_id": "65d83b4e2e3ce531a26b26f8",
			"user": "65d449b0afc22b4f184e65b3",
			"message": "On attending the cricket class, jeet paid you 20 tokens.",
			"with": null,
			"type": "increase",
			"token": 20,
			"createdAt": "2024-02-23T06:29:34.723Z",
			"updatedAt": "2024-02-23T06:29:34.723Z",
			"__v": 0
		}
	]
}*/
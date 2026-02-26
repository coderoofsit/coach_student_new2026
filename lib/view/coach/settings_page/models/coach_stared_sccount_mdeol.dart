class CoachStaredAccountStudent {
  CoachStaredAccountStudent({
    this.staredAccount,
  });

  final StaredAccount? staredAccount;

  factory CoachStaredAccountStudent.fromJson(Map<String, dynamic> json) {
    return CoachStaredAccountStudent(
      staredAccount: json["staredAccount"] == null
          ? null
          : StaredAccount.fromJson(json["staredAccount"]),
    );
  }
}

class StaredAccount {
  StaredAccount({
    required this.id,
    required this.user,
    required this.userType,
    required this.accounts,
    required this.v,
  });

  final String id;
  final String user;
  final String userType;
  final List<Account> accounts;
  final num v;

  factory StaredAccount.fromJson(Map<String, dynamic> json) {
    return StaredAccount(
      id: json["_id"] ?? "",
      user: json["user"] ?? "",
      userType: json["userType"] ?? "",
      accounts: json["accounts"] == null
          ? []
          : List<Account>.from(
              json["accounts"]!.map((x) => Account.fromJson(x))),
      v: json["__v"] ?? 0,
    );
  }
}

class Account {
  Account({
    required this.user,
    required this.role,
    required this.id,
  });

  final User? user;
  final String role;
  final String id;

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      role: json["role"] ?? "",
      id: json["_id"] ?? "",
    );
  }
}

class User {
  User({
    required this.image,
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  final String image;
  final String id;
  final String name;
  final String email;
  final num phoneNumber;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      image: json["image"]["url"] ?? "",
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phoneNumber"] ?? 0,
    );
  }
}

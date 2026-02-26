import 'dart:io';

class StudentModel {
  String? name;
  String? email;
  String? password;
  String? gender;
  File? image;
  String? phoneNumber;
  double? latitude;
  double? longitude;
  double? radius;
  String? address;
  int? age;

  StudentModel(
      {this.name,
      this.email,
      this.password,
      this.gender,
      this.image,
      this.phoneNumber,
      this.latitude,
      this.longitude,
      this.radius,
      this.address,
      this.age});

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        gender: json['gender'],
        image: File(json['image']),
        phoneNumber: json['phoneNumber'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        radius: json['radius'],
        address: json['address'],
        age: json['age']);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "gender": gender,
      "image": image?.path,
      "phoneNumber": phoneNumber,
      "latitude": latitude,
      "longitude": longitude,
      "radius": radius,
      "address": address,
      "age": age
    };
  }
}

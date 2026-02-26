// class MessageModel {
//   MessageModel({
//     required this.author,
//     required this.createdAt,
//     required this.id,
//     required this.status,
//     required this.text,
//     required this.type,
//     required this.height,
//     required this.name,
//     required this.size,
//     required this.uri,
//     required this.width,
//     required this.mimeType,
//   });

//   final Author? author;
//   static const String authorKey = "author";

//   final num createdAt;
//   static const String createdAtKey = "createdAt";

//   final String id;
//   static const String idKey = "id";

//   final String status;
//   static const String statusKey = "status";

//   final String text;
//   static const String textKey = "text";

//   final String type;
//   static const String typeKey = "type";

//   final num height;
//   static const String heightKey = "height";

//   final String name;
//   static const String nameKey = "name";

//   final num size;
//   static const String sizeKey = "size";

//   final String uri;
//   static const String uriKey = "uri";

//   final int width;
//   static const String widthKey = "width";

//   final String mimeType;
//   static const String mimeTypeKey = "mimeType";

//   MessageModel copyWith({
//     Author? author,
//     num? createdAt,
//     String? id,
//     String? status,
//     String? text,
//     String? type,
//     num? height,
//     String? name,
//     num? size,
//     String? uri,
//     int? width,
//     String? mimeType,
//   }) {
//     return MessageModel(
//       author: author ?? this.author,
//       createdAt: createdAt ?? this.createdAt,
//       id: id ?? this.id,
//       status: status ?? this.status,
//       text: text ?? this.text,
//       type: type ?? this.type,
//       height: height ?? this.height,
//       name: name ?? this.name,
//       size: size ?? this.size,
//       uri: uri ?? this.uri,
//       width: width ?? this.width,
//       mimeType: mimeType ?? this.mimeType,
//     );
//   }

//   factory MessageModel.fromJson(Map<String, dynamic> json) {
//     return MessageModel(
//       author: json["author"] == null ? null : Author.fromJson(json["author"]),
//       createdAt: json["createdAt"] ?? 0,
//       id: json["id"] ?? "",
//       status: json["status"] ?? "",
//       text: json["text"] ?? "",
//       type: json["type"] ?? "",
//       height: json["height"] ?? 0,
//       name: json["name"] ?? "",
//       size: json["size"] ?? 0,
//       uri: json["uri"] ?? "",
//       width: json["width"] ?? 0,
//       mimeType: json["mimeType"] ?? "",
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "author": author?.toJson(),
//         "createdAt": createdAt,
//         "id": id,
//         "status": status,
//         "text": text,
//         "type": type,
//         "height": height,
//         "name": name,
//         "size": size,
//         "uri": uri,
//         "width": width,
//         "mimeType": mimeType,
//       };

//   @override
//   String toString() {
//     return "$author, $createdAt, $id, $status, $text, $type, $height, $name, $size, $uri, $width, $mimeType, ";
//   }
// }

// class Author {
//   Author({
//     required this.firstName,
//     required this.id,
//     required this.lastName,
//     required this.imageUrl,
//   });

//   final String firstName;
//   static const String firstNameKey = "firstName";

//   final String id;
//   static const String idKey = "id";

//   final String lastName;
//   static const String lastNameKey = "lastName";

//   final String imageUrl;
//   static const String imageUrlKey = "imageUrl";

//   Author copyWith({
//     String? firstName,
//     String? id,
//     String? lastName,
//     String? imageUrl,
//   }) {
//     return Author(
//       firstName: firstName ?? this.firstName,
//       id: id ?? this.id,
//       lastName: lastName ?? this.lastName,
//       imageUrl: imageUrl ?? this.imageUrl,
//     );
//   }

//   factory Author.fromJson(Map<String, dynamic> json) {
//     return Author(
//       firstName: json["firstName"] ?? "",
//       id: json["id"] ?? "",
//       lastName: json["lastName"] ?? "",
//       imageUrl: json["imageUrl"] ?? "",
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "firstName": firstName,
//         "id": id,
//         "lastName": lastName,
//         "imageUrl": imageUrl,
//       };

//   @override
//   String toString() {
//     return "$firstName, $id, $lastName, $imageUrl, ";
//   }
// }

// /*
// [
// 	{
// 		"author": {
// 			"firstName": "John",
// 			"id": "4c2307ba-3d40-442f-b1ff-b271f63904ca",
// 			"lastName": "Doe"
// 		},
// 		"createdAt": 1655648404000,
// 		"id": "c67ed376-52bf-4d4e-ba2a-7a0f8467b22a",
// 		"status": "seen",
// 		"text": "Ooowww ☺️",
// 		"type": "text"
// 	},
// 	{
// 		"author": {
// 			"firstName": "Janice",
// 			"id": "e52552f4-835d-4dbe-ba77-b076e659774d",
// 			"imageUrl": "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
// 			"lastName": "King"
// 		},
// 		"createdAt": 1655648403000,
// 		"height": 1280,
// 		"id": "02797655-4d73-402e-a319-50fde79e2bc4",
// 		"name": "madrid",
// 		"size": 585000,
// 		"status": "seen",
// 		"type": "image",
// 		"uri": "https://source.unsplash.com/WBGjg0DsO_g/1920x1280",
// 		"width": 1920
// 	},
// 	{
// 		"author": {
// 			"firstName": "Janice",
// 			"id": "e52552f4-835d-4dbe-ba77-b076e659774d",
// 			"imageUrl": "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
// 			"lastName": "King"
// 		},
// 		"createdAt": 1655648402000,
// 		"id": "4e048753-2d60-4144-bc28-9967050aaf12",
// 		"status": "seen",
// 		"text": "What a ~nice~ _wonderful_ sunset! 😻",
// 		"type": "text"
// 	},
// 	{
// 		"author": {
// 			"firstName": "Matthew",
// 			"id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
// 			"lastName": "White"
// 		},
// 		"createdAt": 1655648401000,
// 		"id": "64747b28-df19-4a0c-8c47-316dc3546e3c",
// 		"status": "seen",
// 		"text": "Here you go buddy! 💪",
// 		"type": "text"
// 	},
// 	{
// 		"author": {
// 			"firstName": "Matthew",
// 			"id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
// 			"lastName": "White"
// 		},
// 		"createdAt": 1655648400000,
// 		"id": "6a1a4351-cf05-4d0c-9d0f-47ed378b6112",
// 		"mimeType": "application/pdf",
// 		"name": "city_guide-madrid.pdf",
// 		"size": 10550000,
// 		"status": "seen",
// 		"type": "file",
// 		"uri": "https://www.esmadrid.com/sites/default/files/documentos/madrid_imprescindible_2016_ing_web_0.pdf"
// 	},
// 	{
// 		"author": {
// 			"firstName": "John",
// 			"id": "4c2307ba-3d40-442f-b1ff-b271f63904ca",
// 			"lastName": "Doe"
// 		},
// 		"createdAt": 1655624464000,
// 		"id": "38681a33-2563-42aa-957b-cfc12f791d16",
// 		"status": "seen",
// 		"text": "Matt, where is my Madrid guide?",
// 		"type": "text"
// 	},
// 	{
// 		"author": {
// 			"firstName": "Matthew",
// 			"id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
// 			"lastName": "White"
// 		},
// 		"createdAt": 1655624463000,
// 		"id": "113bb2e8-f74e-42cd-aa30-4085a0f52c58",
// 		"status": "seen",
// 		"text": "Awesome! 😍",
// 		"type": "text"
// 	},
// 	{
// 		"author": {
// 			"firstName": "Janice",
// 			"id": "e52552f4-835d-4dbe-ba77-b076e659774d",
// 			"imageUrl": "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
// 			"lastName": "King"
// 		},
// 		"createdAt": 1655624462000,
// 		"id": "22212d42-1252-4641-9786-d6f83b2ce4a8",
// 		"status": "seen",
// 		"text": "Matt, what do you think?",
// 		"type": "text"
// 	},
// 	{
// 		"author": {
// 			"firstName": "Janice",
// 			"id": "e52552f4-835d-4dbe-ba77-b076e659774d",
// 			"imageUrl": "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
// 			"lastName": "King"
// 		},
// 		"createdAt": 1655624461000,
// 		"id": "afc2269a-374b-4382-8864-b3b60d1e8cd7",
// 		"status": "seen",
// 		"text": "Yeah! Together with Demna, Mark Hamill and others 🥰",
// 		"type": "text"
// 	},
// 	{
// 		"author": {
// 			"firstName": "John",
// 			"id": "4c2307ba-3d40-442f-b1ff-b271f63904ca",
// 			"lastName": "Doe"
// 		},
// 		"createdAt": 1655624460000,
// 		"id": "634b2f0b-2486-4bfe-b36d-1c7d6313c7b3",
// 		"status": "seen",
// 		"text": "Guys! Did you know Imagine Dragons became ambassadors for u24.gov.ua ?",
// 		"type": "text"
// 	}
// ]*/
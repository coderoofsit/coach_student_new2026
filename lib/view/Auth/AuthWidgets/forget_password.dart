// import 'package:flutter/material.dart';

// import '../../../models/student_list_model.dart';

// void showStdentListDialog(BuildContext context,
//     {required StudentListModel studentListModel, }) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Student Profile'),
//         content: SizedBox(
//           height: MediaQuery.of(context).size.height *
//               0.5, // Adjust the height as needed
//           width: MediaQuery.of(context).size.width *
//               0.8, // Adjust the width as needed
//           child: ListView.separated(
//             itemCount: studentListModel.users.length,
//             itemBuilder: (context, index) {
//               final user = studentListModel.users[index];
//               return ListTile(
//                 onTap: () {
//                   // Handle tap action
//                   // AuthProvider().signInStudentProfile(context,
//                   //     email: user.email, password: password, userId: user.id);
//                 },
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(user.image?.url ?? ''),
//                 ),
//                 title: Text(user.name),
//               );
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return const SizedBox(
//                 height: 15,
//               );
//             },
//           ),
//         ),
//       );
//     },
//   );
// }

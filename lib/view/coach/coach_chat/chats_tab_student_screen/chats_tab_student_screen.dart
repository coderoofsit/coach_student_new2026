// import 'package:coach_student/core/app_export.dart';
// import 'package:coach_student/widgets/custom_app_bar_student.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// import '../chat_class_tab/chat_class_tab.dart';
// import '../chats_page/chats_page.dart';

// class ChatScreensTabCoach extends StatefulWidget {
//   const ChatScreensTabCoach({Key? key})
//       : super(
//           key: key,
//         );

//   @override
//   ChatScreensTabCoachState createState() => ChatScreensTabCoachState();
// }

// class ChatScreensTabCoachState extends State<ChatScreensTabCoach>
//     with TickerProviderStateMixin {
//   late TabController tabviewController;

//   @override
//   void initState() {
//     super.initState();
//     tabviewController = TabController(length: 1, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     mediaQueryData = MediaQuery.of(context);

//     return Scaffold(
//       // body: ChatsPageCoach() ,
//       body: Column(
//         children: [
//           _buildAppBar(context),
//           const Expanded(child: ChatsPageCoach()),

//           // Expanded(
//           //   child: TabBarView(
//           //     controller: tabviewController,
//           //     children: const [
//           //       ChatsPageCoach(),
//           //       // ChatClassTabCoach(),
//           //     ],
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return Container(
//       decoration: AppDecoration.fillGray5001,
//       child: ChatAppBar(
//         actionPic: () {
//           // Navigator.push(context, MaterialPageRoute(builder: (context)=> const CoachProfileScreen()));
//         },
//         userName: 'Harvey Spector',
//         userImage:
//             'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//         onBack: () {
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }
// }

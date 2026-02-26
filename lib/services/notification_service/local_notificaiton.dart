// import 'package:awesome_notifications/awesome_notifications.dart';
//
// class LocalNotification {
// // ACTION BUTTON
//   static Future<void> showNotificationContent({
//     required int id,
//     required String title,
//     required String body,
//     String? urlImage,
//   }) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: id,
//         channelKey: 'basic_channel',
//         title: title,
//         body: body,
//         bigPicture:urlImage ,
//       ),
//       // actionButtons: [
//       //   NotificationActionButton(
//       //     key: "SUBCRIBE",
//       //     label: "Subcribe",
//       //     autoDismissible: true,
//       //   ),
//       //   NotificationActionButton(
//       //     key: 'DISMISS',
//       //     label: 'Dismiss',
//       //     actionType: ActionType.Default,
//       //     autoDismissible: true,
//       //     // enabled: false,
//       //     // color: Colors.greenAccent,
//       //     isDangerousOption: true,
//       //   ),
//       // ],
//     );
//   }
//
//   static cancelScheduleNotification(int id) async {
//     await AwesomeNotifications().cancelSchedule(id);
//   }
// }

// =
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class NotificationController extends ChangeNotifier {
//   // SINGLETON PATTERN
//   static final NotificationController _instance =
//       NotificationController._internal();
//
//   factory NotificationController() {
//     return _instance;
//   }
//
//   NotificationController._internal();
//
// // INITIALIZATION METHOD
//
//   static Future<void> initializeLocalNotifications(
//       {required bool debug}) async {
//     await AwesomeNotifications().initialize(
//       null,
//       // 'resource://drawable/res_naruto.png',
//       [
//         NotificationChannel(
//           channelKey: 'basic_channel',
//           channelName: 'Basic notifications',
//           channelDescription: 'Notification channel for coachus',
//           importance: NotificationImportance.Max,
//           // defaultPrivacy: NotificationPrivacy.Secret,
//           enableVibration: true,
//           defaultColor: Colors.redAccent,
//           channelShowBadge: true,
//           enableLights: true,
//
//           // icon: 'resource://drawable/res_naruto',
//           playSound: true,
//
//
//           // soundSource: 'resource://raw/naruto_jutsu',
//         ),
//
//       ],
//       debug: debug,
//     );
//   }
//
//   // Event Listener
//
//   static Future<void> initializeNotificationsEventListeners() async {
//     // Only after at least the action method is set, the notification events are delivered
//     await AwesomeNotifications().setListeners(
//       onActionReceivedMethod: NotificationController.onActionReceivedMethod,
//       onNotificationCreatedMethod:
//           NotificationController.onNotificationCreatedMethod,
//       onNotificationDisplayedMethod:
//           NotificationController.onNotificationDisplayedMethod,
//       onDismissActionReceivedMethod:
//           NotificationController.onDismissActionReceivedMethod,
//     );
//   }
//
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     bool isSilentAction =
//         receivedAction.actionType == ActionType.SilentAction ||
//             receivedAction.actionType == ActionType.SilentBackgroundAction;
//
//     debugPrint(
//         "${isSilentAction ? 'silent action' : 'Action'} notification recevied");
//
//     print("recivedAction : ${receivedAction.toString()}");
//
//     Fluttertoast.showToast(
//       msg:
//           '${isSilentAction ? 'silent action' : 'Action'}  notification recevied',
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: Colors.blue,
//       gravity: ToastGravity.BOTTOM,
//     );
//   }
//
//   static Future<void> onNotificationCreatedMethod(
//       ReceivedNotification receivedAction) async {
//     debugPrint("Notification created");
//
//     Fluttertoast.showToast(
//       msg: 'Notification created ',
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: Colors.blue,
//       gravity: ToastGravity.BOTTOM,
//     );
//   }
//
//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedAction) async {
//     debugPrint("Notification displayed");
//
//     Fluttertoast.showToast(
//       msg: 'Notification displayed ',
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: Colors.blue,
//       gravity: ToastGravity.BOTTOM,
//     );
//   }
//
//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     debugPrint("Notification dismiss");
//
//     Fluttertoast.showToast(
//       msg: 'Notification dismiss ',
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: Colors.blue,
//       gravity: ToastGravity.BOTTOM,
//     );
//   }
// }

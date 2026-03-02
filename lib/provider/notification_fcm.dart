
import 'package:coach_student/services/api/api.dart';
import 'package:coach_student/services/api/configurl.dart';

class NotificationFCM {
  static Future<void> fcmNotification({
    required String receiverId,
    required String senderName,
    required String message,
    required String senderId,
  }) async {
    await DioApi.post(
      path: "${ConfigUrl.notificationFCM}/$receiverId",
      data: {
        "title": senderName,
        "message": message,
        "type": "chatType",
        "senderId": senderId,
      },
    );
  }
}

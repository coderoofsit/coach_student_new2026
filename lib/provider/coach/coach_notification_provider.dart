import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../SharedPref/Shared_pref.dart';
import '../../models/coach_model/NotificationCoachModel.dart';
import '../../services/api/api.dart';
import '../../services/api/configurl.dart';

class NotificationCoachNotifier extends ChangeNotifier {
  bool isLoadingNotification = false;
  NotificationCoachModel notificationCoachModel =
      NotificationCoachModel(notification: []);
  int notificationCount = 0;
  int totalNotication = 0;

  Future<void> getNotificationListCoach(
    BuildContext context,
  ) async {
    isLoadingNotification = true;
    notifyListeners();
    final result = await DioApi.get(path: ConfigUrl.notificationUrl);

    if (result.response != null) {
      notificationCoachModel =
          NotificationCoachModel.fromJson(result.response?.data);

      isLoadingNotification = false;
      notifyListeners();
    } else {
      isLoadingNotification = false;
      notifyListeners();
      result.handleError(context);
    }
  }

  Future<void> getNotifcationCount(context)async{
    getNotificationListCoach(context).then((value) {

        notificationCount = SharedPreferencesManager.getNotificationCount() ?? 0;
        if(notificationCoachModel.notification.length >= notificationCount) {
          totalNotication =
              notificationCoachModel.notification.length - notificationCount;
        }
      notifyListeners();
    });
  }

}

final notificationCoachProvider =
    ChangeNotifierProvider.autoDispose<NotificationCoachNotifier>((ref) {
  return NotificationCoachNotifier();
});

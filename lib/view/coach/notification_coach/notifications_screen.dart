import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../SharedPref/Shared_pref.dart';
import '../../../models/coach_model/NotificationCoachModel.dart'
    as NotificationModel;
import '../../../provider/coach/coach_notification_provider.dart';
import '../../../widgets/custom_app_bar_student.dart';
import 'widgets/notification_item_widget.dart';

class NotificationsScreenCoach extends ConsumerStatefulWidget {
  const NotificationsScreenCoach({super.key});

  @override
  ConsumerState<NotificationsScreenCoach> createState() =>
      _NotificationsScreenCoachConsumerState();
}

class _NotificationsScreenCoachConsumerState
    extends ConsumerState<NotificationsScreenCoach> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final coachHomeProvider = ref.watch(notificationCoachProvider);
      coachHomeProvider.getNotificationListCoach(context).then((value) {
        SharedPreferencesManager.setNoticationCount(
            count:
                coachHomeProvider.notificationCoachModel.notification.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    final notificationCoachList = ref.watch(notificationCoachProvider
        .select((value) => value.notificationCoachModel));

    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: 'Notifications',
      ),
      // appBar: _buildAppBar(context),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 19.h,
            vertical: 15.v,
          ),
          child: ref.watch(notificationCoachProvider).isLoadingNotification
              ? Utils.progressIndicator
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "Notifications",
                    //   style: CustomTextStyles.titleLargeBold,
                    // ),
                    // SizedBox(height: 8.v),
                    notificationCoachList.notification.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 300.v),
                            child: Center(
                              child: Text(
                                "Currently, no notifications",
                                style: CustomTextStyles.titleLargeBold,
                              ),
                            ),
                          )
                        : _buildToday(context,
                            notificationCoachList: notificationCoachList),
                    SizedBox(height: 5.v),
                  ],
                ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildToday(BuildContext context,
      {required NotificationModel.NotificationCoachModel
          notificationCoachList}) {
    return Expanded(
      child: GroupedListView<NotificationModel.Notification, String>(
        shrinkWrap: true,
        stickyHeaderBackgroundColor: Colors.transparent,
        elements: notificationCoachList.notification,
        groupBy: (element) {
          return element.updatedAt!.formattedDate();
        },
        sort: false,
        groupSeparatorBuilder: (String value) {
          return Padding(
            padding: EdgeInsets.only(
              top: 19.v,
              bottom: 8.v,
            ),
            child: Text(
              value,
              style: CustomTextStyles.titleMediumGray900.copyWith(
                color: appTheme.gray900.withOpacity(0.6),
              ),
            ),
          );
        },
        itemBuilder: (context, notificationData) {
          return NotificationItemWidget(notificationData: notificationData);
        },
        separator: SizedBox(
          height: 10.v,
        ),
      ),
    );
  }
}

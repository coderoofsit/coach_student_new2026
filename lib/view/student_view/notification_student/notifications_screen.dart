import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../SharedPref/Shared_pref.dart';
import '../../../provider/student_provider/student_home_provider.dart';
import '../../../widgets/custom_app_bar_student.dart';
import 'widgets/today_item_widget.dart';

class NotificationsScreenStdeunt extends ConsumerStatefulWidget {

  const NotificationsScreenStdeunt({super.key});

  @override
  _NotificationsScreenStdeuntState createState() => _NotificationsScreenStdeuntState();
}

class _NotificationsScreenStdeuntState extends ConsumerState<NotificationsScreenStdeunt> {

  List todayItemList = [
    {'id': 1, 'groupBy': "Today"},
    {'id': 2, 'groupBy': "Today"},
    {'id': 3, 'groupBy': "Yesterday"},
    {'id': 4, 'groupBy': "Yesterday"},
    {'id': 5, 'groupBy': "25th November"},
    {'id': 6, 'groupBy': "25th November"}
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final studentHomeProvider = ref.watch(homeStudentNotifier);
      studentHomeProvider.getNotificationList(context).then((value) {
        SharedPreferencesManager.setNoticationCount(count: studentHomeProvider.notificationList.length);
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final studentHomeProvider = ref.watch(homeStudentNotifier);
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBarStudent(title: 'Notifications',),
        // appBar: _buildAppBar(context),
        body : studentHomeProvider.isLoading ? Center(
          child: Utils.progressIndicator,
        ) : Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 19.h,
            vertical: 15.v,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notification",
                style: CustomTextStyles.titleLargeBold,
              ),
              SizedBox(height: 15.v),
              _buildToday(context,studentHomeProvider),
              
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildToday(BuildContext context,StudentHomeProvider studentHome) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: studentHome.notificationList.length,
        padding: const EdgeInsets.all(0),
        // groupBy: (element) => element['groupBy'],
        // groupSeparatorBuilder: (String value) {
        //   return Padding(
        //     padding: EdgeInsets.only(
        //       top: 19.v,
        //       bottom: 8.v,
        //     ),
        //     child: Text(
        //       value,
        //       style: CustomTextStyles.titleMediumGray900.copyWith(
        //         color: appTheme.gray900.withOpacity(0.6),
        //       ),
        //     ),
        //   );
        // },
        itemBuilder: (context, index) {
          return TodayItemWidget(notification: studentHome.notificationList[index],);
        },

      ),
    );
  }
}

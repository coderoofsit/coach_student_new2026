import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/coach_model/CoachClassDetails_model.dart';
import '../../../../provider/coach/class_coach_details_provider.dart';
import 'widgets/upcomming_class_coach.dart';

// ignore_for_file: must_be_immutable
class MyClassUpcoming extends ConsumerStatefulWidget {
  final List<Schedule> upcomingSchedules;
  final int upcommingClassStatus;

  const MyClassUpcoming({
    Key? key,
    required this.upcomingSchedules,
    required this.upcommingClassStatus,
  }) : super(
          key: key,
        );

  @override
  ConsumerState<MyClassUpcoming> createState() => MyClassUpcomingState();
}

class MyClassUpcomingState extends ConsumerState<MyClassUpcoming>
    with AutomaticKeepAliveClientMixin<MyClassUpcoming> {
  @override
  bool get wantKeepAlive => true;
  
  Future<void> _refreshData() async {
    await ref.read(classDetailsCoachNotifier).fetchClassDeatilsProvider(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    mediaQueryData = MediaQuery.of(context);
    final ClassDetailsCoachModel classDetailsData = ref.watch(
        classDetailsCoachNotifier
            .select((value) => value.classDetailsCoachModel));
    
    // Use the latest data from provider
    final schedules = widget.upcommingClassStatus == 1
        ? classDetailsData.upcomingSchedules
        : classDetailsData.pendingSchedules;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillOnErrorContainer,
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: schedules.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 200.v),
                          child: Text(
                            "${widget.upcommingClassStatus == 1 ? "Upcoming" : "Pending"} class is not available",
                            style: CustomTextStyles.titleLargeBold,
                          ),
                        ),
                      ),
                    ),
                  )
                : _buildMyClasses(
                    context,
                    upcomingSchedules: schedules,
                  ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildMyClasses(BuildContext context,
      {required List<Schedule> upcomingSchedules}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (
          context,
          index,
        ) {
          return SizedBox(
            height: 20.v,
          );
        },
        itemCount: upcomingSchedules.length,
        itemBuilder: (context, index) {
          return MyUpCommingClassesItemWidget(
            scheduleDetails: upcomingSchedules[index],
          );
        },
      ),
    );
  }
}

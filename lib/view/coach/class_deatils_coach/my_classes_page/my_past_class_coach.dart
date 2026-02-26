import 'dart:developer';

import '../../../../models/coach_model/CoachClassDetails_model.dart';
import '../../../../provider/coach/class_coach_details_provider.dart';
import 'widgets/past_past_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPastClassCoach extends ConsumerStatefulWidget {
  final List<Schedule> pastSchedules;

  const MyPastClassCoach({super.key, required this.pastSchedules});

  @override
  ConsumerState<MyPastClassCoach> createState() => _MyPastClassCoachState();
}

class _MyPastClassCoachState extends ConsumerState<MyPastClassCoach> {
  Future<void> _refreshData() async {
    await ref.read(classDetailsCoachNotifier).fetchClassDeatilsProvider(context);
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final ClassDetailsCoachModel classDetailsData = ref.watch(
        classDetailsCoachNotifier
            .select((value) => value.classDetailsCoachModel));
    
    // Use the latest data from provider
    final pastSchedules = classDetailsData.pastSchedules;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillOnErrorContainer,
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: pastSchedules.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 200.v),
                          child: Text(
                            "Past class is not available",
                            style: CustomTextStyles.titleLargeBold,
                          ),
                        ),
                      ),
                    ),
                  )
                : _buildMyClasses(
                    context,
                    pastSchedules: pastSchedules,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyClasses(BuildContext context,
      {required List<Schedule> pastSchedules}) {
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
        itemCount: pastSchedules.length,
        itemBuilder: (context, index) {
          log("class Data ${pastSchedules[index].participants.toString()}");

          return PastClassesItemWidget(
            scheduleDetails: pastSchedules[index],
          );
        },
      ),
    );
  }
}

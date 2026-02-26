import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/student_provider/student_home_provider.dart';
import '../my_classes_page/widgets/myclasses_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';

// ignore_for_file: must_be_immutable
class MyClassesPage extends ConsumerStatefulWidget {
  const MyClassesPage({Key? key})
      : super(
          key: key,
        );

  @override
  MyClassesPageState createState() => MyClassesPageState();
}

class MyClassesPageState extends ConsumerState<MyClassesPage>
    with AutomaticKeepAliveClientMixin<MyClassesPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final studentHomeProvider = ref.watch(homeStudentNotifier);
      studentHomeProvider.getCoachClassesList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final studentHomeProvider = ref.watch(homeStudentNotifier);
    return _buildMyClasses(context, studentHomeProvider);
  }

  /// Section Widget
  Widget _buildMyClasses(
      BuildContext context, StudentHomeProvider studentData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: studentData.coachClassesList.isEmpty ? Center(
        child: Text(
          "Upcoming classes not available",
          style: CustomTextStyles
              .titleLargeBold,
        ),
      ) : ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 20.v),
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,

        itemCount: studentData.coachClassesList.length,
        itemBuilder: (context, index) {
          final classData = studentData.coachClassesList[index];
          return MyclassesItemWidget(coachData: classData,

          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/student_provider/student_home_provider.dart';
import '../my_classes_page/widgets/myclasses_item_widget.dart';

// ignore_for_file: must_be_immutable
class MyClassesPPage extends ConsumerStatefulWidget {
  const MyClassesPPage({Key? key})
      : super(
          key: key,
        );

  @override
  MyClassesPPageState createState() => MyClassesPPageState();
}

class MyClassesPPageState extends ConsumerState<MyClassesPPage>
    with AutomaticKeepAliveClientMixin<MyClassesPPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final studentHomeProvider = ref.watch(homeStudentNotifier);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: studentHomeProvider.pastClassesList.isEmpty ? Center(
        child: Text(
          "Past classes not available",
          style: CustomTextStyles
              .titleLargeBold,
        ),
      ) : ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 20.v),
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,

        itemCount: studentHomeProvider.pastClassesList.length,
        itemBuilder: (context, index) {
          final classData = studentHomeProvider.pastClassesList[index];
          return MyclassesItemWidget(coachData: classData,);
        },
      ),
    );
  }
}

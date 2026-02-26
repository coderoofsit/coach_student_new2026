import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/view/student_view/student_class/my_classes_p_page/my_classes_p_page.dart';
import 'package:coach_student/view/student_view/student_class/my_classes_page/my_classes_page.dart';

class MyClassesTabStudent extends StatefulWidget {
  const MyClassesTabStudent({Key? key}) : super(key: key);

  @override
  MyClassesTabStudentState createState() => MyClassesTabStudentState();
}

// ignore_for_file: must_be_immutable
class MyClassesTabStudentState extends State<MyClassesTabStudent>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
       
            Expanded(

              child: TabBarView(
                controller: tabviewController,
                children: const [
                  MyClassesPage(),
                  MyClassesPPage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: AppDecoration.fillGray5001,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatAppBar(
            centerTitle: true,
            userName: 'My classes',
            onBack: () {
              Navigator.pop(context);
            },
          ),
          // tab controller

          Container(
            margin: EdgeInsets.only(left: 40.h, right: 40.h),
            child: TabBar(
              controller: tabviewController,
              labelPadding: EdgeInsets.zero,
              isScrollable: false, // Set this to false for equal spacing
              labelColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                fontSize: 16.fSize,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelColor: appTheme.black900,
              unselectedLabelStyle: TextStyle(
                fontSize: 16.fSize,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w600,
              ),
              indicatorColor: theme.colorScheme.primary,
              tabs: const [
                Tab(child: Text("Upcoming classes")),
                Tab(child: Text("Past classes")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


//   /// Section Widget
//   Widget _buildView(BuildContext context) {
//     return Container(
//       height: 35.v,
//       width: 316.h,
//       margin: EdgeInsets.only(right: 24.h),
//       child: TabBar(
//         controller: tabviewController,
//         labelPadding: EdgeInsets.zero,
//         labelColor: theme.colorScheme.primary,
//         labelStyle: TextStyle(
//             fontSize: 16.fSize,
//             fontFamily: 'Nunito Sans',
//             fontWeight: FontWeight.w700),
//         unselectedLabelColor: appTheme.black900.withOpacity(0.8),
//         unselectedLabelStyle: TextStyle(
//             fontSize: 16.fSize,
//             fontFamily: 'Nunito Sans',
//             fontWeight: FontWeight.w600),
//         indicatorColor: theme.colorScheme.primary,
//         tabs: const [
//           Tab(child: Text("Upcoming Classes")),
//           Tab(child: Text("Past Classes"))
//         ],
//       ),
//     );
//   }

//   /// Navigates back to the previous screen.
//   onTapImgArrowLeft(BuildContext context) {
//     Navigator.pop(context);
//   }
// }

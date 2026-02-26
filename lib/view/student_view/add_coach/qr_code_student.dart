import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../provider/student_provider/student_home_provider.dart';

class QrScreenStudent extends ConsumerStatefulWidget {
  String passcode;
  String userIdCoach;

  QrScreenStudent(
      {required this.passcode, required this.userIdCoach, super.key});

  @override
  _QrScreenStudentState createState() => _QrScreenStudentState();
}

class _QrScreenStudentState extends ConsumerState<QrScreenStudent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(homeStudentNotifier).getReferral(context, widget.userIdCoach);
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final studenthomeData = ref.watch(homeStudentNotifier);
    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: "Passcode",
      ),
      body: (studenthomeData.isLoading &&
              studenthomeData.referrelClassModel?.referralCode == null)
          ? Utils.progressIndicator
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30.v,
                    // width: 264.h,
                  ),
                  SizedBox(
                    height: 269.v,
                    width: 264.h,
                    child: QrImageView(
                      data:
                          "${widget.passcode}*${studenthomeData.referrelClassModel?.referralCode}",
                      version: QrVersions.auto,
                      // size: 200.0.adaptSize,
                    ),
                  ),
                  SizedBox(
                    height: 20.v,
                    // width: 264.h,
                  ),
                  Text(
                    widget.passcode,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32.fSize,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  SizedBox(
                    height: 62.v,
                    // width: 264.h,
                  ),
                  Container(
                    width: 320.h,
                    height: 119.v,
                    // alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF5F8FE),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: Column(
                      children: [
                        const Spacer(),
                        Text(
                          'Qr Code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.fSize,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        SizedBox(
                          height: 10.v,
                          // width: 264.h,
                        ),
                        Text(
                          'Allow parent and students to easily connect',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14.fSize,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

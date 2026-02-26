import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/provider/coach/coach_profile_provider.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreenCoach extends ConsumerWidget {
  const QrScreenCoach({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    mediaQueryData = MediaQuery.of(context);
    final coachData = ref.watch(
        coachProfileProvider.select((value) => value.coachProfileDetailsModel));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: const CustomAppBarStudent(
          title: "Passcode",
        ),
      body: ref.watch(
              coachProfileProvider.select((value) => value.isLoadingProfile))
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
                      data: "${coachData.passcode}",
                      version: QrVersions.auto,
                      // size: 200.0.adaptSize,
                    ),
                  ),
                  SizedBox(
                    height: 20.v,
                    // width: 264.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${coachData.passcode}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32.fSize,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      SizedBox(width: 12.h),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: '${coachData.passcode}'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Passcode copied to clipboard'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3D6DF5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 20.adaptSize,
                          ),
                        ),
                      ),
                    ],
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
      ),
    );
  }
}

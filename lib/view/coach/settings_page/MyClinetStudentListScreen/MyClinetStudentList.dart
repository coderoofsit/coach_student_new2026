import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/view/coach/settings_page/setting_provider/setting_provider.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../models/coach_model/StudentListClientModel.dart';
import 'ClientDetailsPage.dart';

class MyClientStudentList extends ConsumerStatefulWidget {
  const MyClientStudentList({Key? key})
      : super(
          key: key,
        );

  @override
  ConsumerState<MyClientStudentList> createState() =>
      _MyClinetStudentListConsumerState();
}

class _MyClinetStudentListConsumerState
    extends ConsumerState<MyClientStudentList> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(settingCoachProvider).fetchMyStudent(context);
      // Some provider code that gets/sets some state
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final StudentListClientModel studentListClientModel = ref.watch(
        settingCoachProvider.select((value) => value.studentListClientModel));
    final bool isLoading = ref.watch(
        settingCoachProvider.select((value) => value.isLoadingStudentList));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: const CustomAppBarStudent(
          title: 'My Clients',
        ),
      body: isLoading
          ? Utils.progressIndicator
          : studentListClientModel.clients.isEmpty
              ? Center(
                  child: Text(
                    "no clients attached",
                    style: CustomTextStyles.titleLargeBold,
                  ),
                )
              : Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    vertical: 14.v,
                  ),
                  child: Column(
                    children: [
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: EdgeInsets.only(left: 5.h),
                      //     child: Text(
                      //       "Starred Accounts",
                      //       style: theme.textTheme.headlineSmall,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 20.v),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: studentListClientModel.clients.length,
                          itemBuilder: (context, index) {
                            final data = studentListClientModel.clients[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ClientDetailsPage(
                                      client: data,
                                    ),
                                  ),
                                );
                              },
                              child: _clinetCard(
                                context,
                                profilePic:
                                    data.image?.url ?? imageUrlDummyProfile,
                                nameClinet: data.name,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.v),
                    ],
                  ),
                ),
      ),
    );
  }

  /// Section Widget
  Widget _clinetCard(
    BuildContext context, {
    required String profilePic,
    required String nameClinet,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 9.v,
      ),
      child: Container(
        padding: EdgeInsets.all(10.h),
        decoration: AppDecoration.outlineBlack.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder5,
        ),
        child: Row(
          children: [
            CustomImageView(
              imagePath: profilePic,
              height: 45.adaptSize,
              width: 45.adaptSize,
              fit: BoxFit.cover,
              radius: BorderRadius.circular(
                22.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 13.h),
              child: Text(
                nameClinet,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.800000011920929),
                  fontSize: 16.fSize,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ),
            const Spacer(),
            CustomImageView(
              imagePath: ImageConstant.imgArrowRight,
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.only(
                left: 15.h,
                top: 10.v,
                bottom: 11.v,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Common widget
  Widget _buildHour(
    BuildContext context, {
    required String hourText,
  }) {
    return SizedBox(
      // height: 17.v,
      // width: 75.h,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 2.0,
          ),
          const Gap(2),
          Text(
            hourText,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 12,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(5),
          CustomImageView(
            imagePath: ImageConstant.coinImage,
            height: 14.adaptSize,
            width: 14.adaptSize,
            alignment: Alignment.topLeft,
          ),
          Text(
            '/hour',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6000000238418579),
              fontSize: 12,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }
}

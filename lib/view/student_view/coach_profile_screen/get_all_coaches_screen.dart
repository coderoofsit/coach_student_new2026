import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/image_constant.dart';
import '../../../core/utils/size_utils.dart';
import '../../../models/CoachChatModel.dart';
import '../../../provider/student_provider/student_home_provider.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_app_bar_student.dart';
import '../../../widgets/custom_image_view.dart';
import '../student_chat/chats_page/chats_page.dart';

class GetAllCoaches extends ConsumerStatefulWidget {
  const GetAllCoaches({super.key});

  @override
  ConsumerState<GetAllCoaches> createState() => _GetAllCoachesState();
}

class _GetAllCoachesState extends ConsumerState<GetAllCoaches> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final studentHomeProvider = ref.watch(homeStudentNotifier);

      studentHomeProvider.getCoachesList(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    final studentHomeProvider = ref.watch(homeStudentNotifier);
    return Scaffold(
      appBar: const CustomAppBarStudent(
          title: 'Coaches '),
      body:  ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:  studentHomeProvider.coachesList.length < 5 ? studentHomeProvider.coachesList.length : 5 ,
        itemBuilder: (context, index) {
          final coachData =
          studentHomeProvider.coachesList[index];
          return GestureDetector(
            onTap: () {

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             const CalenderStudent(),),);

              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (_) => ChatsPageStudent(
                  user: CoachChatModel(
                    userId: coachData.id ?? "",
                    name:
                    coachData.name ?? "",
                    imageUrl: coachData
                        .image?.url ??
                        "",
                    isRead: false, coachType: coachData.coachType.toString(),
                  ),
                ),),);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              child: _CoachesCard(
                context,
                profilePic: coachData.image?.url ?? "",
                typeCoach: coachData.coachType ?? "",
                nameCoach: coachData.name ?? "",
                changes: coachData.chargePerHour.toString(),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildHour(
      BuildContext context, {
        required String timeLabel,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              "  $timeLabel",
              style: CustomTextStyles.labelLargeSecondaryContainer,
            ),
            Text(
              "/hour",
              style: CustomTextStyles.labelLargeBold_1,
            ),
          ],
        ),
        CustomImageView(
          imagePath: ImageConstant.coinImage,
          height: 14.adaptSize,
          width: 14.adaptSize,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: 10.h),
        ),
      ],
    );
  }

  Widget _CoachesCard(
      BuildContext context, {
        required String profilePic,
        required String typeCoach,
        required String nameCoach,
        required String changes,
      }) {
    mediaQueryData = MediaQuery.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: SingleChildScrollView(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameCoach,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.800000011920929),
                      fontSize: 16.fSize,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  SizedBox(height: 3.v),
                  Row(
                    children: [
                      Text(
                        typeCoach,
                        style: theme.textTheme.labelLarge,
                      ),
                      _buildHour(
                        context,
                        timeLabel: changes,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Flexible(
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

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
            )

          ],
        ),
      ),
    );
  }
}


import 'package:coach_student/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class TranscationPageCoach extends StatefulWidget {
  const TranscationPageCoach({Key? key})
      : super(
          key: key,
        );

  @override
  TranscationPageCoachState createState() => TranscationPageCoachState();
}

class TranscationPageCoachState extends State<TranscationPageCoach>
    with AutomaticKeepAliveClientMixin<TranscationPageCoach> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillOnErrorContainer,
          child: Column(
            children: [
              SizedBox(height: 19.v),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (
                    context,
                    index,
                  ) {
                    return SizedBox(
                      height: 15.v,
                    );
                  },
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.h,
                        vertical: 11.v,
                      ),
                      decoration: AppDecoration.outlineBlack.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder5,
                      ),
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.coinImage,
                            height: 38.adaptSize,
                            width: 38.adaptSize,
                            margin: EdgeInsets.only(bottom: 2.v),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Withdrawn 100 Tokens',
                                  style: TextStyle(
                                    color: Colors.black
                                        .withOpacity(0.800000011920929),
                                    fontSize: 16.fSize,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                SizedBox(height: 2.v),
                                Row(
                                  children: [
                                    Text(
                                      "10:23",
                                      style: theme.textTheme.labelLarge,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 6.h),
                                      child: Text(
                                        "17th Nov, 2023",
                                        style: theme.textTheme.labelLarge,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 11.v,
                              right: 8.h,
                              bottom: 9.v,
                            ),
                            child: Text(
                              '100\$',
                              style: TextStyle(
                                color: const Color(0xFF3D6DF5),
                                fontSize: 16.fSize,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

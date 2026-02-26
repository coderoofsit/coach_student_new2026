import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/models/CoachChatModel.dart';
import 'package:coach_student/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../models/CoachProfileDetailsModel.dart';
import '../../coach_profile_screen/coach_profile_screen.dart';
import '../chat_class_tab/chat_class_tab.dart';
import '../chats_page/chats_page.dart';

class ChatScreensTab extends StatefulWidget {

 final CoachChatModel user;
   const ChatScreensTab({required this.user, Key? key})
      : super(
          key: key,
        );

  @override
  ChatScreensTabState createState() => ChatScreensTabState();
}

class ChatScreensTabState extends State<ChatScreensTab>
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
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: TabBarView(
              controller: tabviewController,
              children:  [
                ChatsPageStudent(user: widget.user,),
                const ChatClassTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: AppDecoration.fillGray5001,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            height: kToolbarHeight,
            leadingWidth: 56.h,
            leading: IconButton(
              icon: CustomImageView(
                imagePath: ImageConstant1.imgVuesaxLinearArrowRight,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoachProfileScreen(
                          coachProfileDetailsModel: CoachProfileDetailsModel(),
                        ),
                      ),
                    );
                  },
                  child: CustomImageView(
                    imagePath:
                        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    height: 40.adaptSize,
                    width: 40.adaptSize,
                    fit: BoxFit.cover,
                    radius: BorderRadius.circular(25.h),
                  ),
                ),
                SizedBox(width: 8.h),
                const Text('Harvey Spector'),
              ],
            ),
            centerTitle: false,
          ),
          // tab controller
          SizedBox(height: 29.v),
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
                Tab(
                  child: Text(
                    "Messages",
                  ),
                ),
                Tab(
                  child: Text(
                    "Classes",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

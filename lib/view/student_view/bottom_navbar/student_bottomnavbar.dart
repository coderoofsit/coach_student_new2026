import 'dart:developer';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/view/coach/notification_coach/notifications_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../provider/coach/coach_notification_provider.dart';
import '../../../provider/student_provider/settings_provider.dart';
import '../StudentHome/StudentHomeScreen.dart';
import '../add_coach/add_coach.dart';
import '../settings_page/settings_page.dart';
import '../student_chat/student_chat_list.dart';
import '../wallet_student/wallet_student.dart';

class StudentBottomNavbar extends ConsumerStatefulWidget {
  const StudentBottomNavbar({Key? key}) : super(key: key);

  @override
  ConsumerState<StudentBottomNavbar> createState() =>
      _StudentBottomNavbarState();
}

class _StudentBottomNavbarState extends ConsumerState<StudentBottomNavbar> {
  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;
  
  // Track which pages have been loaded
  final Set<int> _loadedPages = {0}; // Home page (index 0) loads by default
  
  // Keys to maintain state for each page
  final List<GlobalKey> _pageKeys = List.generate(4, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final studentHomeProvider = ref.watch(studentSettingProvider);
      studentHomeProvider.getStudentProfile();
    });
  }
  
  // Build page widget only when needed
  Widget _buildPage(int index) {
    // Only build the page if it's been loaded or is currently visible
    if (!_loadedPages.contains(index) && index != currentPageIndex) {
      return const SizedBox.shrink();
    }
    
    switch (index) {
      case 0:
        return HomeStudentScreen(key: _pageKeys[0]);
      case 1:
        return ChatUserListStudent(key: _pageKeys[1]);
      case 2:
        return WalletStudent(key: _pageKeys[2]);
      case 3:
        return SettingsStudentPage(key: _pageKeys[3]);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final studentProfile = ref.watch(studentSettingProvider).studentProfile;
    final notificationCount = ref.watch(notificationCoachProvider.select((value) => value.totalNotication));
    // log("image url ${studentProfile!.image!.url}");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80.v),
        child: Container(
          padding: EdgeInsets.only(
            top: 30.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CustomImageView(
                  //   imagePath: ImageConstant.logoCircle,
                  //   fit: BoxFit.cover,
                  //   height: 74.v,
                  //   width: 88.h,
                  //   // margin: EdgeInsets.only(right: 33.h),
                  // ),
                  CustomImageView(
                    imagePath: ImageConstant.logoCircle,
                    fit: BoxFit.fill,
                    height: 70.v,
                    // width: 88.h,
                    margin: EdgeInsets.only(right: 5.h, left: 10.h, top: 8.v),
                  ),
                  SizedBox(
                    width: 200.adaptSize,
                    child: Text('Hi, ${studentProfile?.name}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: const Color(0xFF3D6DF5),
                        fontSize: 20.adaptSize,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const Spacer(),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCoachScreen(),
                        ),
                      );
                    },
                    child: CustomImageView(
                      imagePath: ImageConstant.addPlusIcon,
                      fit: BoxFit.cover,
                      width: 25.h,
                      height: 25.v,
                      margin: EdgeInsets.only(right: 10.h),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreenCoach(),
                        ),
                      ).then((value) => {
                        ref.read(notificationCoachProvider).getNotifcationCount(context)
                      });
                    },
                    child: Stack(

                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.notificationIcon,
                          fit: BoxFit.cover,
                          width: 25.h,
                          height: 25.v,
                          margin: EdgeInsets.only(right: 33.h),
                        ),
                        notificationCount != 0 ?  Positioned(
                          left: 12,
                          child: Container(
                            height: 10,
                            width: 10,

                            decoration: BoxDecoration( // This controls the shadow

                              borderRadius: BorderRadius.circular(16),
                              color: Colors.red,  // This would be color of the Badge
                            ),// This is your Badge
                            child: const Text('', style: TextStyle(color: Colors.white)),
                          ),
                        ) :const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
              // if (currentPageIndex == 1) _SearchBar(context),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: currentPageIndex,
          children: List.generate(4, (index) => _buildPage(index)),
        ),
      ),
      bottomNavigationBar:  NavigationBar(
        animationDuration: Duration.zero,
        // elevation: 0,

        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            // Mark this page as loaded when user navigates to it
            _loadedPages.add(index);
          });
        },
        destinations: <Widget>[
          NavigationDestination(
            icon: CustomImageView(
              imagePath: ImageConstant.homeGrey,
            ),
            selectedIcon: CustomImageView(
              imagePath: ImageConstant.homeIconColor,
            ),
            label: '',
          ),
          NavigationDestination(
            icon: CustomImageView(
              imagePath: ImageConstant.chatIconGray,
            ),
            selectedIcon: CustomImageView(
              imagePath: ImageConstant.chatIconColor,
            ),
            label: '',
          ),
          NavigationDestination(
            selectedIcon:
                CustomImageView(imagePath: ImageConstant.dollarIconColor),
            icon: CustomImageView(imagePath: ImageConstant.dollarIconGray),
            label: '',
          ),
          NavigationDestination(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(
                  studentProfile?.image?.url ?? imageUrlDummyProfile),
              // child: CustomImageView(imagePath: studentProfile.image!.url,),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

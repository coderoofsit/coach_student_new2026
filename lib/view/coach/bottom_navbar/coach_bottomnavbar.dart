import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/models/CoachProfileDetailsModel.dart';
import 'package:coach_student/provider/coach/coach_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/InAppServices.dart';
import '../../../core/constants/consumable.dart';
import '../../../provider/coach/coach_notification_provider.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_search_view.dart';
import '../coach_chat/ChatScreensUserListCoach.dart';
import '../home_coach/HomeCoachScreens.dart';
import '../notification_coach/notifications_screen.dart';
import '../settings_page/settings_page.dart';
import '../wallet_coach/coach_wallet.dart';

// ignore: depend_on_referenced_packages
import 'package:in_app_purchase/in_app_purchase.dart';
// ignore: depend_on_referenced_packages

import 'package:onepref/onepref.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class CoachBottomNavbar extends ConsumerStatefulWidget {
  const CoachBottomNavbar({Key? key}) : super(key: key);

  @override
  ConsumerState<CoachBottomNavbar> createState() =>
      _CoachBottomNavbarConsumerState();
}

class _CoachBottomNavbarConsumerState extends ConsumerState<CoachBottomNavbar> 
    with WidgetsBindingObserver {
  int currentPageIndex = 0;

  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;



  bool _loading = true;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log("App resumed - refreshing coach profile to sync subscription status");
      // Refresh the profile to catch any external subscription changes (cancellation/expiry)
      ref.read(coachProfileProvider.notifier).getCoachProfile();
    }
  }









  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final notificationCount = ref.watch(
        notificationCoachProvider.select((value) => value.totalNotication));
    CoachProfileDetailsModel coachProfileDetailsModel = ref.watch(
        coachProfileProvider.select((value) => value.coachProfileDetailsModel));
        
    final bool hasAccess = coachProfileDetailsModel.hasAccess;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size(double.infinity, currentPageIndex <= 2 ? 150.v : 70.v),
        child: Container(
          padding: EdgeInsets.only(top: 30.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.logoCircle,
                fit: BoxFit.fill,
                height: 74.v,
                // width: 88.h,
                margin: EdgeInsets.only(right: 10.h, left: 10),
              ),
              SizedBox(
                width: 200.adaptSize,
                child: Text(
                  "Hi, ${coachProfileDetailsModel.name ?? ""}",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: const Color(0xFF3D6DF5),
                    fontSize: 20.adaptSize,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              // CustomImageView(
              //   imagePath: ImageConstant.calanderIcon,
              // ),
              // const Gap(25),
              // GestureDetector(
              //   onTap: () {
              //     _showSubscriptionDialog(context);
              //     // showModalBottomSheet(
              //     //     context: context,
              //     //     builder: (builder) {
              //     //       return ListView.builder(
              //     //           itemCount: _products.length,
              //     //           itemBuilder: (context,item){
              //     //             return ListTile(
              //     //               onTap: (){
              //     //                 iApEngine.handlePurchase(_products[item] , _productsIds);
              //     //               },
              //     //               title: Text(_products[item].title),
              //     //               trailing: Text(_products[item].price),
              //     //             );
              //     //           });
              //     //     });
              //   },
              //   child: Text("subss"),
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreenCoach(),
                    ),
                  ).then((value) => {
                        ref
                            .read(notificationCoachProvider)
                            .getNotifcationCount(context)
                      });
                },
                child: Stack(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.notificationIcon,
                      fit: BoxFit.cover,
                      width: 20.h,
                      height: 20.v,
                      margin: EdgeInsets.only(right: 33.h),
                    ),
                    notificationCount != 0
                        ? Positioned(
                            left: 10,
                            top: 0,
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                // This controls the shadow
                                borderRadius: BorderRadius.circular(16),
                                color: Colors
                                    .red, // This would be color of the Badge
                              ), // This is your Badge
                              child: const Text('',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: currentPageIndex,
            children: const [
              HomeCoachScreens(),
              ChatUserListCoach(),
              CoachWallet(),
              SettingsCoachPage(),
            ],
          ),
          if (!hasAccess)
            _buildAccessRestrictedOverlay(context),
        ],
      ),
      // bottomNavigationBar: SizedBox(
      //   height:Platform.isIOS ? 110 : 75,
      //   child: BottomNavigationBar(
      //
      //     backgroundColor: Colors.white,
      //     selectedItemColor: Colors.blue, // Change this to the color you want for selected items
      //     unselectedItemColor: Colors.grey, // Change this to the color you want for unselected items
      //     currentIndex: currentPageIndex,
      //     onTap: (int index) {
      //       setState(() {
      //         currentPageIndex = index;
      //       });
      //     },
      //     items: <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(
      //         icon: CustomImageView(
      //           imagePath: currentPageIndex == 0
      //               ? ImageConstant.homeIconColor
      //               : ImageConstant.homeGrey,
      //         ),
      //         label: '',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: CustomImageView(
      //           imagePath: currentPageIndex == 1
      //               ? ImageConstant.chatIconColor
      //               : ImageConstant.chatIconGray,
      //         ),
      //         label: '',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: CustomImageView(
      //           imagePath: currentPageIndex == 2
      //               ? ImageConstant.dollarIconColor
      //               : ImageConstant.dollarIconGray,
      //         ),
      //         label: '',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: CircleAvatar(
      //           backgroundImage: NetworkImage(
      //             coachProfileDetailsModel.image?.url ?? imageUrlDummyProfile,
      //           ),
      //         ),
      //         label: '',
      //       ),
      //     ],
      //   ),
      // )

      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
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
                  coachProfileDetailsModel.image?.url ?? imageUrlDummyProfile),
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _SearchBar(BuildContext context) {
    return SizedBox(
      height: 50.v,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: CustomSearchView(
          // controller: searchController,
          hintText: "Search for subject, coach...",
          borderDecoration: SearchViewStyleHelper.outlineBlack,
        ),
      ),
    );
  }

  Widget _buildAccessRestrictedOverlay(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.h),
              child: Container(
                padding: EdgeInsets.all(32.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.h),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_clock_outlined,
                      size: 64.h,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(height: 24.v),
                    Text(
                      "Trial Period Over",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: appTheme.black900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.v),
                    Text(
                      "Your 14-day free access has ended. Subscribe now to continue managing your students and classes.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.v),
                    CustomElevatedButton(
                      text: "View Plans",
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.managePlansScreen);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}

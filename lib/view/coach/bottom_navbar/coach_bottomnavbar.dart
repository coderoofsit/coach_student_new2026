import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/models/CoachProfileDetailsModel.dart';
import 'package:coach_student/provider/coach/coach_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/InAppServices.dart';
import '../../../core/constants/consumable.dart';
import '../../../provider/coach/coach_notification_provider.dart';
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

class _CoachBottomNavbarConsumerState extends ConsumerState<CoachBottomNavbar> {
  int currentPageIndex = 0;

  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;



  final List<String> _kProductIds = <String>[
    "monthly",
    "Monthly_Sub",
  ];

  final InAppPurchaseService _iapService = InAppPurchaseService();
  bool _loading = true;
  String? _error;



  @override
  void initState () {


    super.initState();
    _initializeInAppPurchase();
    // iApEngine.inAppPurchase.purchaseStream.listen((event) {
    //   listenPurchasedActivities(event);
    // });
    //
    // getProducts();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
    //
    // });
    // Future.delayed(Duration(seconds: 1)).then((_) {
    //
    // });
  }



  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }



  Future<void> _initializeInAppPurchase() async {
    try {
      await _iapService.initialize();
      _iapService.handlePurchaseUpdates();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
    setState(() {
      _loading = false;
    });
  }







  void _showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Choose a subscription plan',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildSubscriptionOption(
                context,
                title: 'Monthly',
                price: '₹990.00',
                onTap: () {
                  _iapService.buySubscription(_iapService.products.first);
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 16),
              _buildSubscriptionOption(
                context,
                title: 'Yearly',
                price: '₹9990.00',
                onTap: () {
                  _iapService.buySubscription(_iapService.products.first);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubscriptionOption(BuildContext context,
      {required String title,
      required String price,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final notificationCount = ref.watch(
        notificationCoachProvider.select((value) => value.totalNotication));
    CoachProfileDetailsModel coachProfileDetailsModel = ref.watch(
        coachProfileProvider.select((value) => value.coachProfileDetailsModel));
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
      body: [
        const HomeCoachScreens(),
        const ChatUserListCoach(),
        const CoachWallet(),
        const SettingsCoachPage(),
      ][currentPageIndex],
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

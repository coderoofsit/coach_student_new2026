import 'package:coach_student/core/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../core/utils/image_constant.dart';
import '../theme/theme_helper.dart';
import 'custom_image_view.dart';

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({super.key, this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgComponent4,
      activeIcon: ImageConstant.imgComponent4,
      type: BottomBarEnum.Component4,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgComponent3,
      activeIcon: ImageConstant.imgComponent3,
      type: BottomBarEnum.Component3,
    ),
    BottomMenuModel(
      icon: ImageConstant.coinImageBlueGray100,
      activeIcon: ImageConstant.coinImageBlueGray100,
      type: BottomBarEnum.Component5bluegray100,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgEllipse35,
      activeIcon: ImageConstant.imgEllipse35,
      type: BottomBarEnum.Ellipse35,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 89.v,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.15),
          width: 1.h,
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: CustomImageView(
              imagePath: bottomMenuList[index].icon,
              height: 28.adaptSize,
              width: 28.adaptSize,
              color: appTheme.blueGray100,
            ),
            activeIcon: CustomImageView(
              imagePath: bottomMenuList[index].activeIcon,
              height: 28.adaptSize,
              width: 28.adaptSize,
              color: theme.colorScheme.primary,
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
      ),
    );
  }
}

enum BottomBarEnum {
  Component4,
  Component3,
  Component5bluegray100,
  Ellipse35,
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    required this.type,
  });

  String icon;

  String activeIcon;

  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

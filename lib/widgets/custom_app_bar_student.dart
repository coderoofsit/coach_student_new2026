import 'package:coach_student/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String ?userImage;
  final VoidCallback? onBack;
  final VoidCallback? actionPic;
  final bool? centerTitle;

  const ChatAppBar(
      {super.key,
      required this.userName,
       this.userImage,
      this.onBack,
      this.actionPic, this.centerTitle});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: const Color(0xfff3f6fe),
      elevation: 0,
      leading: IconButton(
        icon: CustomImageView(
          imagePath: ImageConstant1.imgVuesaxLinearArrowRight,
        ),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      title: centerTitle!=null ?Text(userName) : Row(
        children: [
          GestureDetector(
            onTap: actionPic,
            child: CustomImageView(
              imagePath: userImage,
              height: 40.adaptSize,
              width: 40.adaptSize,
              fit: BoxFit.cover,
              radius: BorderRadius.circular(
                25.h,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Text(userName),
        ],
      ),
    );
  }
}


class CustomAppBarStudent extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  const CustomAppBarStudent({
    Key? key,
    required this.title,
    this.onBack,
    this.actions,
    this.bottom,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xfff3f6fe),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: CustomImageView(
          imagePath: ImageConstant1.imgVuesaxLinearArrowRight,
        ),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF171327),
          fontSize: 20.fSize,
          fontFamily: 'Nunito Sans',
          fontWeight: FontWeight.w600,
          height: 0.05,
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

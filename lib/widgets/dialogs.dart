import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> errorDialog(BuildContext context, String err) async {
    return await showAdaptiveDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(
            Icons.error_outline,
            size: 45,
            // color: AppColor.primaryColor,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                err,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                child: const Text(
                  'Back',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> successDialog(
      BuildContext context, String message) async {
    return await showAdaptiveDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(
            Icons.check_circle_outline,
            size: 45,
            // color: AppColor.successColor,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    // color: AppColor.primaryColor,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool?> logoutDialog(BuildContext context) async {
    mediaQueryData = MediaQuery.of(context);

    return showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: 450.h,
            height: 250.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), color: Colors.white),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.0.h,
                right: 20.0.h,
                top: 30.v,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const Text("Logout"),
                  // Icon(
                  //   CupertinoIcons.info,
                  //   size: 50.adaptSize,
                  // ),
                  // Icon for Account Deleted
                  CustomImageView(
                    imagePath: "${ImageConstant.imagePath}/logout.svg",
                    height: 50.h,
                  ),
                  SizedBox(height: 16.0.v),

                  // Text: Account Deleted
                  Text(
                    "Are you sure you want to log out?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.fSize,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  SizedBox(height: 16.0.v),

                  // Done Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 120.h,
                        height: 50.v,
                        child: OutlinedButton(
                          onPressed: () {
                            // Handle the action when the user clicks the Done button
                            Navigator.of(context)
                                .pop(false); // Close the dialog
                          },
                          child: const Text('No'),
                        ),
                      ),
                      SizedBox(
                        width: 120.h,
                        height: 50.v,
                        child: CustomElevatedButton(
                          onPressed: () {
                            // Handle the action when the user clicks the Done button
                            Navigator.of(context).pop(true); // Close the dialog
                          },
                          text: 'Yes',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        // return AlertDialog(
        //   title: const Text('Logout'),
        //   content: const Text('Do you want to logout?'),
        //   actions: [
        //     TextButton(
        //         onPressed: () => Navigator.of(context).pop(false),
        //         child: const Text(
        //           'Cancel',
        //           style: TextStyle(
        //               // color: AppColor.subTextColor
        //               ),
        //         )),
        //     TextButton(
        //       onPressed: () => Navigator.pop(context, true),
        //       // Navigator.of(context).pop(true),
        //       child: const Text(
        //         'Yes',
        //         style: TextStyle(
        //             // color: AppColor.primaryColor
        //             ),
        //       ),
        //     ),
        //   ],
        // );
      },
    );
  }

  static Future<bool?> deleteDialog(BuildContext context) async {
    return showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text(
            'Do you want really want to delete your account?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      // color: AppColor.subTextColor
                      ),
                )),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              // Navigator.of(context).pop(true),
              child: const Text(
                'Yes',
                style: TextStyle(
                    // color: AppColor.primaryColor
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> confirmDeleteDialog(BuildContext context,
      {required String message}) async {
    bool? deleteConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteDialog(
        message: message,
      ),
    );
    return deleteConfirmed;
  }

  static Future<bool?> confirmDeletePermanently(BuildContext context,
      {required String message}) async {
    bool? deleteConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteAccountDialog(
        message: message,
      ),
    );
    return deleteConfirmed;
  }

  static Future<bool?> showSuccessDialog(BuildContext context,
      {required String title, required String subtitle}) async {
    bool? showSuccessDialogBoolValue = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(title: title, subtitle: subtitle);
      },
    );
    return showSuccessDialogBoolValue;
  }
}

class SuccessDialog extends StatelessWidget {
  final String title;
  final String subtitle;

  const SuccessDialog({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 30,
            bottom: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon for Success (you can replace it with your tick icon)
              CustomImageView(
                imagePath: ImageConstant1.imgTickCircle,
              ),
              SizedBox(height: 16.0.v),

              // Text: Success Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.fSize,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.0.v),

              // Text: Success Subtitle
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.fSize,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 24.0.v),

              // Done Button
              SafeArea(
                child: CustomElevatedButton(
                  onPressed: () {
                    // Handle the action when the user clicks the Done button
                    Navigator.of(context).pop(true); // Close the dialog
                  },
                  text: 'Done',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// for delete operation

class DeleteDialog extends StatelessWidget {
  final String message;
  const DeleteDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: 450.h,
        height: 266.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: Colors.white),
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.0.h,
            right: 20.0.h,
            top: 30.v,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon for Account Deleted
              CustomImageView(
                imagePath: ImageConstant.deleteIcon,
              ),
              SizedBox(height: 16.0.v),

              // Text: Account Deleted
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.fSize,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              SizedBox(height: 16.0.v),

              // Done Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 120.h,
                    height: 50.v,
                    child: OutlinedButton(
                      onPressed: () {
                        // Handle the action when the user clicks the Done button
                        Navigator.of(context).pop(false); // Close the dialog
                      },
                      child: const Text('No'),
                    ),
                  ),
                  SizedBox(
                    width: 120.h,
                    height: 50.v,
                    child: CustomElevatedButton(
                      onPressed: () {
                        // Handle the action when the user clicks the Done button
                        Navigator.of(context).pop(true); // Close the dialog
                      },
                      text: 'Yes',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// for delete acc
class DeleteAccountDialog extends StatelessWidget {
  final String message;
  const DeleteAccountDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: 360,
        height: 266,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon for Account Deleted
              CustomImageView(
                imagePath: ImageConstant1.imgTickCircle,
              ),
              const SizedBox(height: 16.0),

              // Text: Account Deleted
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              const SizedBox(height: 16.0),

              // Done Button
              CustomElevatedButton(
                onPressed: () {
                  // Handle the action when the user clicks the Done button
                  Navigator.of(context).pop(true); // Close the dialog
                },
                text: 'Done',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

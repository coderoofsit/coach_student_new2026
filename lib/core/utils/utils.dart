import 'dart:io';

import 'package:coach_student/core/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final Logger logger = Logger();

const String appId = "cd0178afef7b461785e5065583cf2fe3";
String channelName = "test123";

enum ToastType {
  SUCCESS,
  ERROR,
  // Add more types as needed
}

class Utils {
  // Utils._();
  static void showSnackbarErrror(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Widget arrowBackButton(context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              radius: 15,
              child: Center(
                child: Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                  size: 25.adaptSize,
                ),
              ),
            ),
          ),
        ],
      );

  static Future<CroppedFile?> cropImage(
      BuildContext context, XFile? pickedFile) async {
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      return croppedFile;
    }
    return null;
  }

  static void showSnackbarSucc(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Widget progressIndicator = Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: LoadingAnimationWidget.discreteCircle(
        size: 50,
        color: const Color(0xFF3D6DF5),
      ),
    ),
  );
  static void progressDialogsIndicator(BuildContext context) {
    showAdaptiveDialog(
      barrierDismissible: false,
      builder: (ctx) {
        return const Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 4,
          ),
        );
      },
      context: context,
    );
  }

  static String? validateMobile(String? value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);
    if (value!.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  static void launchURL({required String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'could not launch $url';
    }
  }

  static void makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  static void email({required email}) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Could not launch $params';
    }
  }

  //* WhatsApp url lunch
  static Future<void> openWhatsApp(String phoneNumber,
      {String? message}) async {
    // Construct the WhatsApp URL
    String whatsappUrl = 'https://wa.me/$phoneNumber';

    // If a message is provided, add it to the URL
    if (message != null) {
      whatsappUrl += '?text=${Uri.encodeComponent(message)}';
    }

    // Check if WhatsApp is installed and can be launched
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      // Launch WhatsApp
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      // Handle the case where WhatsApp cannot be launched
      throw 'Could not launch $whatsappUrl';
    }
  }

  static const String rupesSymbol = '₹';

  // flutter toast
  static void toast({required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showToast({
    required String message,
    ToastType toastType = ToastType.SUCCESS,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int timeInSecForIosWeb = 2,
    double fontSize = 16.0,
  }) {
    Color backgroundColor;
    Color textColor;

    // Set colors based on toast type
    switch (toastType) {
      case ToastType.SUCCESS:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case ToastType.ERROR:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      // Add more cases as needed
    }

    Fluttertoast.showToast(
      msg: message,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static String dateFormat({required String date}) {
    // Parse the input timestamp string
    DateTime dateTime = DateTime.parse(date).toLocal();

    // Format the date and time as required
    String formattedDateTime =
        DateFormat("h:mm a, d MMMM, yyyy").format(dateTime);

    return formattedDateTime; // Output: 7:19 AM - 12 September, 2023
  }

  // Format the parsed date to "dS MMMM, yyyy"
  static String formatNameDate(String inputDate) {
    try {
      // Parse the input date with a custom format
      DateTime dateTime = DateTime.parse(inputDate);

      // Format the parsed date to "dS MMMM, yyyy"
      return DateFormat('d MMMM, yyyy').format(dateTime);
    } catch (e) {
      print('Error formatting date: $e');
      return ''; // Handle the error or return a default value
    }
  }

//  DateTIme formmated
  static String formatDate(DateTime inputDate) {
    return DateFormat('dd/MM/yyyy').format(inputDate);
  }

  static String formatTime(DateTime inputTime) {
    return DateFormat('h:mm a').format(inputTime);
  }

//  Navigator.popUntil(context, (route) => route.isFirst);
  static void removeRouteFirst(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  static Future<void> openMapUrl(BuildContext context,
      {required num lat, required num lng}) async {
    String url = '';
    String urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      url = 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
        await launchUrl(Uri.parse(urlAppleMaps));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  String formatUtcDate(String originalDateStr) {
    // Parse the original date string
    DateTime originalDate = DateTime.parse(originalDateStr);

    // Format the date as desired
    String formattedDateStr =
        DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(originalDate);

    return formattedDateStr;
  }

  static const String studentType = 'student';
  static const String coachType = 'coach';
  static const String parentsType = 'parent';
}

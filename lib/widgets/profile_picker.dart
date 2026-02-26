


import 'dart:io';

import 'package:coach_student/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



Future<File?> getImage(ImageSource source) async {
  final pickedFile = await ImagePicker().pickImage(source: source);

  File? image;
  image = pickedFile != null ? File(pickedFile.path) : null;
  return image;
}

class ProfilePicker extends StatefulWidget {
  File? image;
   ProfilePicker({required this.image ,super.key});

  @override
  State<ProfilePicker> createState() => _ProfilePickerState();
}

class _ProfilePickerState extends State<ProfilePicker> {

  profilePick(BuildContext context,) async {

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () async{
                  Navigator.pop(context);
                  widget.image = await getImage(ImageSource.gallery);
                  setState(() {

                  });

                  print("image ==${widget.image!.path}");
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a picture'),
                onTap: () async {
                  Navigator.pop(context);
                  widget.image = await getImage(ImageSource.camera);
                  setState(() {
                  });

                },
              ),
            ],
          ),
        );
      },
    );


  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
         profilePick(context);
      },
      child: Container(
        height: 101.adaptSize,
        width: 101.adaptSize,
        // padding: EdgeInsets.all(30.h),
        decoration: AppDecoration.fillGray.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder50,
        ),
        child: widget.image != null
            ? CircleAvatar(
          backgroundImage: FileImage(
            widget.image!,
          ),
        ) : CustomImageView(
          imagePath: ImageConstant.imgMajesticonsPlus,
          height: 41.adaptSize,
          width: 41.adaptSize,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

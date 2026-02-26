import 'package:coach_student/core/app_export.dart';
import 'package:flutter/material.dart';

import '../../../../models/student_list_model.dart';

class SelectStudentItem extends StatelessWidget {

  bool isSelected;
  User user;
  Function() onTap;

  SelectStudentItem({super.key, required this.isSelected, required this.user, required this.onTap});


  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              GestureDetector(
                onTap : onTap,
                child: CircleAvatar(
                  radius: 30.adaptSize,
                  backgroundImage:  NetworkImage(
                     user.image?.url ?? ""
                      ),
                ),
              ),
              SizedBox(height: 8.v),
              Text(
                '${user.name}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF3D6DF5) : Colors.black,
                  fontSize: 14.fSize,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),

            ],

          ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}

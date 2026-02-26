import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:flutter/material.dart';

class AboutUsStudentScreen extends StatelessWidget {
  const AboutUsStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: 'About us',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.v),
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.v),
              child: const SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Ownership',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // Details Text
                    Text(
                      'CreditVault is owned and operated by App Merchant, Inc., '
                      'a leading provider of innovative solutions in the app '
                      'development industry. With a commitment to excellence and '
                      'customer satisfaction, App Merchant, Inc. is dedicated to supporting the success of CreditVault and its users.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Our Mission',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      ''' At CreditVault, we are dedicated to providing a worry-free platform where coaches and students can confidently engage, knowing that their financial transactions are managed accurately and securely. With a focus on transparency and security, CreditVault ensures that coaches and students can trust in the seamless handling of payments, balances, and the fair distribution of funds. Our mission is to revolutionize the coaching industry by offering a secure environment where coaches and students can fully concentrate on their growth and development journey. By prioritizing financial clarity and peace of mind, CreditVault aims to establish a community built on trust, integrity, and mutual respect, where every interaction is conducted with transparency and fairness. Whether you're a coach seeking efficient management of your coaching business or a student in pursuit of guidance on your learning path, CreditVault is your reliable partner every step of the way. Join us as we redefine coaching excellence and empower individuals to unlock their full potential. ''',
                      style: TextStyle(fontSize: 16.0),
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

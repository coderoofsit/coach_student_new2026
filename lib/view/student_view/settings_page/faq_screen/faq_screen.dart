import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: 'FAQ',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.v),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  Text(
                    '💬',
                    style: TextStyle(fontSize: 24.fSize),
                  ),
                  SizedBox(width: 8.h),
                  Expanded(
                    child: Text(
                      'CreditVault – Frequently Asked Questions',
                      style: TextStyle(
                        fontSize: 22.fSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.v),

              // GENERAL Section
              _buildSectionTitle('GENERAL'),
              SizedBox(height: 15.v),

              _buildFaqItem(
                'What is CreditVault?',
                'CreditVault is an app built for freelancers — such as coaches, babysitters, tutors, and other session-based service providers — to easily track prepaid session credits (called tokens) with their clients. It simplifies payments, scheduling, and credit tracking for both freelancers and clients.',
              ),

              _buildFaqItem(
                'Who is CreditVault for?',
                'CreditVault is designed specifically for freelancers who offer recurring services by the session. It\'s ideal for coaches, private tutors, babysitters, fitness instructors, and more.',
              ),

              _buildFaqItem(
                'What is a "token"?',
                'Tokens are used to represent prepaid sessions. 1 token = \$1. Clients purchase tokens in advance, and these are deducted automatically as sessions are attended.',
              ),

              SizedBox(height: 30.v),

              // FOR CLIENTS & PARENTS Section
              _buildSectionTitle('FOR CLIENTS & PARENTS'),
              SizedBox(height: 15.v),

              _buildFaqItem(
                'How do I sign up as a student or parent?',
                'There are three ways to register:\n'
                '• As a freelancer/coach\n'
                '• As a parent (if the student is under 18)\n'
                '• As a student (18 or older)',
              ),

              _buildFaqItem(
                'Can a student connect with more than one coach?',
                'Yes! Students can connect with and use tokens for multiple coaches or freelancers within the app.',
              ),

              _buildFaqItem(
                'How do I buy tokens?',
                'Clients can pay coaches directly (manual payment) or purchase tokens through the app using PayPal.\n\n'
                'If paid manually, the coach must enter the correct number of tokens into the app. Always verify that your token balance is accurate in your account.',
              ),

              _buildFaqItem(
                'Can I see how many tokens I have left?',
                'Yes. Your remaining token balance is always visible, and you\'ll receive a notification whenever tokens are used. You can also view your full token usage history.',
              ),

              _buildFaqItem(
                'Will I be notified if I run out of tokens?',
                'Yes. You\'ll receive a push notification when your token balance reaches zero.',
              ),

              SizedBox(height: 30.v),

              // FOR FREELANCERS / COACHES Section
              _buildSectionTitle('FOR FREELANCERS / COACHES'),
              SizedBox(height: 15.v),

              _buildFaqItem(
                'How do I set pricing for sessions?',
                'You set your own pricing per session or class. Since 1 token = \$1, you assign the number of tokens required for each class when creating it.',
              ),

              _buildFaqItem(
                'Can I offer different types of sessions?',
                'Yes. You can create and customize your own classes, choose the location, and assign a token amount per session.',
              ),

              _buildFaqItem(
                'How do I get paid?',
                'You can accept payments in two ways:\n'
                '• Manually (offline, in person)\n'
                '• In-app via PayPal\n\n'
                'If paid manually, you are responsible for entering the correct number of tokens into your client\'s account. In-app payments will automatically update their token balance.',
              ),

              _buildFaqItem(
                'Is there a fee to use CreditVault?',
                'Yes, but only for freelancers and coaches.\n\n'
                'CreditVault is free for students and parents. Freelancers pay a monthly subscription through the Apple App Store or Google Play.',
              ),

              _buildFaqItem(
                'Can I customize CreditVault with my own branding?',
                'Not at this time. CreditVault is not a white-label platform.\n\n'
                'However, clients (students and parents) will only see and interact with the specific freelancers they\'re connected to. They won\'t see a public list or directory of other coaches.',
              ),

              _buildFaqItem(
                'Is CreditVault a searchable directory of freelancers?',
                'No. Clients must be invited or manually connected to a freelancer. CreditVault is designed for private management — not for public discovery.',
              ),

              SizedBox(height: 30.v),

              // TECHNICAL & APP FEATURES Section
              _buildSectionTitle('TECHNICAL & APP FEATURES'),
              SizedBox(height: 15.v),

              _buildFaqItem(
                'What platforms is CreditVault available on?',
                'CreditVault is available on both iOS and Android.',
              ),

              _buildFaqItem(
                'Is payment secure?',
                'Yes. All payments processed through the app use PayPal\'s secure platform.',
              ),

              _buildFaqItem(
                'Can I manage multiple students?',
                'Absolutely. As a freelancer, you can:\n'
                '• Manage multiple students at once\n'
                '• Build classes for individual or group sessions\n'
                '• Customize each class based on time, location, and pricing',
              ),

              _buildFaqItem(
                'How do I create and run a class?',
                'To build a class, simply enter:\n'
                '• Location\n'
                '• Date\n'
                '• Start time & end time\n'
                '• Class description\n'
                '• Token cost\n\n'
                'Once the class ends, open the app. You\'ll see a list of all students assigned to that class. Just check off who attended, and CreditVault will automatically deduct tokens and handle the rest — it\'s that simple!',
              ),

              SizedBox(height: 30.v),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20.fSize,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.v),
          Text(
            answer,
            style: TextStyle(
              fontSize: 14.fSize,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}


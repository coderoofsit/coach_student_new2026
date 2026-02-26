import 'package:coach_student/core/utils/size_utils.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarStudent(
        title: 'Terms & Conditions',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.v),
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.v),
              child:  SingleChildScrollView(
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
                        'PRIVACY',
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
                      '''Please refer to the “CreditVault” – Privacy Policy” for terms relating to how your private information will be used and when, if ever, your information will be disseminated to others''',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'ACCURACY DISCLAIMER',
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
                      '''Any electronic reports provided to you through the Virtual Estimate service and its components, are provided to you “as is,” and you agree to use at your own risk. It is the responsibility of you, the end-user, to check the accuracy and usefulness of the supplied reports and the information contained therein. App Merchant, Inc. shall not be responsible or liable for the accuracy, usefulness, completeness, reliability, effectiveness, fitness for a particular purpose or availability of any information provided or made available via the Virtual Estimate service, and shall not be responsible or liable for any errors or omissions ''',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'LIABILITY DISCLAIMER',
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
                      '''App Merchant, Inc. and its respective officers, directors and employees shall not be liable to you in respect to any claim, demand or action, irrespective of the nature of the cause of the claim, demand or action, alleging any loss, injury or damages, direct or indirect, which may result from the use or possession of electronic reports, provided by the Virtual Estimate service, or the information contained therein.''',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'INTELLECTUAL PROPERTY',
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
                      '''The App Merchant, Inc. app and its original content, features, and functionality, as well as the format of electronic reports provided to you through the Virtual Estimate service, are owned by App Merchant, Inc. and are protected by international copyright, trademark, patent, trade secret, and other intellectual property and proprietary rights laws.''',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'INDEMNIFICATION',
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
                      '''You agree to indemnify, defend and hold App Merchant, Inc (including its licensees, assignees, subsidiaries, affiliated companies, and the respective officers, directors, employees and representatives) free and harmless from and against any liability, loss, injury, demand, action, cost, expense, or claim of any kind or character, arising out of or in connection with any use or possession by you of the supplied reports and the information contained therein.''',
                      style: TextStyle(fontSize: 16.0),
                    ),SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'TERMINATION',
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
                      '''App Merchant, Inc reserves the right to terminate your access to the service, without cause or notice, which may result in the forfeiture and destruction of all information associated with your account. All provisions of this Agreement that, by their nature, should survive termination shall survive termination, including, without limitation, accuracy disclaimer, liability disclaimer, intellectual property and indemnification''',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'FORCE MAJEURE',
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
                      '''In no event shall App Merchant, Inc. be responsible or liable for any failure or delay in the performance of its obligations hereunder arising out of or caused by, directly or indirectly, forces beyond its control, including, without limitation, strikes, work stoppages, accidents, acts of war or terrorism, civil or military disturbances, nuclear or natural catastrophes or acts of God, and interruptions, loss or malfunctions of utilities, communications or computer
(Software and hardware) services; it being understood that the App Merchant, Inc shall use reasonable efforts which are consistent with accepted practices in the information technology industry to resume performance as soon as practicable under the circumstances.
''',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'GOVERNING LAW',
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
                      '''These Terms and Conditions and the rights and obligations of the parties hereunder this agreement shall be governed by, and construed and interpreted in accordance with, the laws of the State of Florida, in the country of the United States of America.''',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'NOTIFICATION OF CHANGES',
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
                      '''App Merchant, Inc reserves the right to change these conditions from time to time as it sees fit and your continued use of the service will signify your acceptance of any adjustment to these terms. If there are any changes to our privacy policy, we will announce that these changes have been made on our home page and on other key pages on our app. If there are any changes in how we use our apps customers' Personally Identifiable Information, notification by email or postal mail will be made to those affected by the change. Any changes to our privacy policy will be posted on our app 30 days prior to these changes taking place. You are therefore advised to re-read these Terms and Conditions on a regular basis''',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Privacy Policy',
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
                      '''We know that privacy is important to you. Your privacy is important to us too. This Policy Document explains how App Merchant, Inc. and its affiliates collect information from or about you when you visit the app or any applications that link to this Policy Document, and how we use, maintain, protect and disclose that information. Should you have any questions about this Policy Document, or our privacy practices more generally, please email us at yourappmerchant@gmail.com''',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    buildTermsCondition(
                      'Personal Information We Collect',
                      '''Information From You We collect some information directly from you when you voluntarily provide it to us, for example:
Contact Information: such as your name, address, telephone number, email address, and/or username and password, if you choose to create them.
Transaction Information: such as address, photos and other information related to scheduling an appointment.
Client Services/Customer Care/Technical Assistance and Other Inquiries: such as, questions or comments you submit through online and app forms or via email.
Applicant Information: information you provide about such demographics.
Other Information You Provide: any other information you may provide to us directly through our app or website for things like whitepapers or surveys, or through social media.
App Merchant, Inc may collect other information online automatically when you visit our websites or app, this can include things like:
Device Information: including your IP address, browser types, operating system, device types and device IDs or advertising identifiers.
Usage Information: such as your browsing activity while on our websites or app, what pages you visit and what you click, forms you complete or start to complete, search terms you use, whether you open emails and interact with content, access times, error logs and similar information.
App Merchant, Inc. may also receive information about you from others, such as updated address information if we discover the information, we have is no longer current.
How to Review and Change Your Personal Information
If you register for an App Merchant, Inc. app account, you may review and change your personal information by logging into the app, clicking on your name at the top of the screen and then clicking on “Manage Profile.”''',
                    ),
                    buildTermsCondition(
                      'How We Use Personal Information That We Collect',
                      '''As reasonably necessary and proportionate to fulfill the purposes for which the information was provided
To provide information, products or services
To audit and measure user interaction with our website and/or app, so we can improve the relevancy or effectiveness of our content and messaging
To develop and carry out marketing, advertising and analytics
To provide texts or emails containing information about our products or services, or events or news, that may be of interest to recipients, as permitted by law
To deliver content and products or services relevant to your interests, including targeted ads on third party sites
To detect security incidents or monitor for fraudulent or illegal activity
Debugging to identify and repair errors
To comply with laws, regulations or other legal process
We may also use your personal information to:
Provide you with the services and products you request or that have been ordered and/or requested through the App Merchant, Inc. website and/or app
Process or collect payments for our services
Respond to your questions and otherwise provide support in your request.
''',
                    ),buildTermsCondition(
                      'How We Share Your Personal Information',
                      '''
                  We may share the information we collect as described below. When we share information, either within our company or with others, we take steps to require any recipients to uphold similar protections for information as that provided by App Merchant, Inc
Within App Merchant, Inc We may share your personal information with other App Merchant, Inc owned business entities.
Service Providers/Vendors/Third Parties. We work with others to manage or support some of our business operations and services. These entities may be located outside of your country of residence or the country in which you are located.
For Legal Purposes. We may disclose relevant information as may be necessary or required for legal, compliance or regulatory purposes. This includes, for example, disclosures that are required to: (i) respond to duly authorized information requests of police and governmental authorities; (ii) comply with any law, regulation, subpoena, or court order; (iii) investigate and help prevent security threats, fraud or other malicious activity; (iv) enforce/protect the rights and properties of App Merchant, Inc. or its subsidiaries; (v) protect the rights or personal safety of App Merchant, Inc., our employees, and third parties; or protect the security of our websites, app, systems, information, premises or property.
Otherwise with Your Consent. We may also share information about you with third parties if we ask you, and you provide consent to such sharing.
''',
                    ),buildTermsCondition(
                      'Keeping Your Information Secure',
                      '''
                  App Merchant, Inc. has adopted physical, technical and administrative measures that are designed to prevent unauthorized access or disclosure, maintain data accuracy, and ensure appropriate use of personal information. We cannot, however, ensure or warrant the security of information. No security measures are infallible.

''',
                    ),buildTermsCondition(
                      'How can you help protect your information?',
                      '''
                 If you are using a App Merchant, Inc. website or application for which you registered and chose a password, you should not divulge your password to anyone. We will never ask you for your password in an unsolicited phone call or in an unsolicited email. Also remember to sign out of the App Merchant, Inc. website and/or app and close your browser window when you have finished your work.
Please note that unencrypted email is not a secure method of transmission, as information in such emails may be accessed and viewed by others while in transit to us. For this reason, we prefer that you not communicate confidential or sensitive information to us via regular unencrypted email. We will, however, honor requests for communications through unencrypted email.
''',
                    ),
                    buildTermsCondition(
                      'Commission Fees',
                      '''App Merchant, Inc. does grant commission fees. Please contact office to confirm commission rate. Commission rates are based off of remediation portions of the job only, not any rebuild.''',
                    ),
                    buildTermsCondition(
                      'Updates To This Privacy Notice',
                      '''From time to time, we may change this Privacy Notice. If we make changes, we will revise the “Last Updated” date at the bottom of this Notice. We encourage you to review this Notice periodically to be sure you are aware of these changes. Changes will become effective as of the “Last Updated” date. 
Last Updated: May 16, 2024''',
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


Widget buildTermsCondition(String heading , String body){
  return Column(
    children: <Widget>[
      const SizedBox(
        height: 10,
      ),
      Align(
        alignment: Alignment.topLeft,
        child: Text(
          '$heading',
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
        '''$body''',
        style: TextStyle(fontSize: 16.0),
      ),
    ],
  );
}

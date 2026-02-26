import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:flutter/material.dart';

class LegalPoliciesScreen extends StatelessWidget {
  const LegalPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: 'Legal & Policies',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.v),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                'CREDIT VAULT – TERMS OF USE',
                style: TextStyle(
                  fontSize: 22.fSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.v),
              Text(
                'Effective Date: May 16, 2024',
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Last Updated: December 9, 2025',
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Operated by: App Merchant, Inc.',
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Contact: creditvaultapp@gmail.com',
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 24.v),

              // Section 1
              _buildSection(
                '1. Ownership',
                'Credit Vault is owned, licensed, and trademarked by App Merchant, Inc.\n\n'
                'All software, features, reports, tools, and materials in the Credit Vault platform are the exclusive property of App Merchant, Inc., protected by U.S. and international copyright, trademark, patent, trade secret, and other intellectual property laws.\n\n'
                'By accessing or using Credit Vault, you agree to be bound by these Terms of Use ("Terms").\n\n'
                'If you do not agree to these Terms, you may not use the Service.',
              ),

              // Section 2
              _buildSection(
                '2. About Credit Vault / Important Disclaimers',
                'Credit Vault is not a:\n'
                '• Credit bureau\n'
                '• Bank or financial institution\n'
                '• Credit repair organization\n'
                '• Credit monitoring service\n'
                '• Lender\n'
                '• Financial advisor\n'
                '• Tax advisor\n'
                '• Legal advisor\n\n'
                'Credit Vault provides organizational tools, secure document storage, and optional user–coach connection features.\n\n'
                'However:\n'
                '• We do not validate or verify any uploaded financial documents.\n'
                '• We do not guarantee accuracy of any information within the platform.\n'
                '• We are not responsible for loan outcomes, score changes, or financial decisions.\n'
                '• We do not provide professional or regulated financial services.\n'
                '• All use is at your own risk.',
              ),

              // Section 3
              _buildSection(
                '3. Eligibility',
                '3.1 General Eligibility (Adults 18+)\n'
                'You must be 18 years of age or older to create a primary Credit Vault account, enter into a subscription, make payments, or otherwise use any features involving contractual obligations with App Merchant, Inc.\n\n'
                '3.2 Students Ages 13–17\n'
                'Students who are at least 13 years old may create a student account solely for the purpose of participating in classes or sessions arranged through Credit Vault.\n'
                'Student accounts:\n'
                '• May not enter contracts\n'
                '• May not make purchases\n'
                '• May not represent themselves as customers of App Merchant, Inc.\n'
                '• Are limited to student-specific features only\n\n'
                'By registering, the student confirms they are at least 13 years of age and legally permitted to provide their own personal information.\n\n'
                '3.3 Children Under 13 (Parental Consent Required)\n'
                'Children under 13 years of age may not create an account on their own. Any child under 13 may only use Credit Vault through an account created, registered, and actively managed by a parent or legal guardian, who assumes full responsibility for the child\'s use of the Service.\n'
                'Parents or guardians who create accounts for children under 13 agree to:\n'
                '• Provide supervision and oversight of the child\'s use of the Service\n'
                '• Ensure all submitted information is accurate and lawful\n'
                '• Accept all liability associated with the child\'s use of Credit Vault\n\n'
                '3.4 Children\'s Online Privacy Protection Act (COPPA) Compliance\n'
                'Credit Vault does not knowingly collect personal information from children under 13 without verifiable parental consent.\n'
                'If App Merchant, Inc. discovers or reasonably believes that an account was created by a user under age 13 without proper parental involvement, we may:\n'
                '• Immediately suspend or delete the account\n'
                '• Remove associated data\n'
                '• Take any action necessary to maintain COPPA compliance\n\n'
                'If you believe a child under 13 has provided information without authorization, contact us immediately at creditvaultapp@gmail.com.',
              ),

              // Section 4
              _buildSection(
                '4. Privacy',
                'See the Credit Vault Privacy Policy for details on how your personal information is collected, stored, used, and shared. Your use of the Service constitutes acceptance of that policy.',
              ),

              // Section 5
              _buildSection(
                '5. User Responsibilities & Prohibited Conduct',
                'You agree not to:\n'
                '• Upload fraudulent, misleading, stolen, or illegal financial documents\n'
                '• Attempt unauthorized access to systems, accounts, or data\n'
                '• Interfere with the security, stability, or integrity of the Service\n'
                '• Use automated tools, bots, or scrapers\n'
                '• Upload bank login credentials or passwords (strictly prohibited)\n'
                '• Misuse the platform for identity theft, fraud, impersonation, or unlawful activity\n'
                '• Upload harmful software or malicious content\n\n'
                'Violation of these rules may result in immediate termination.',
              ),

              // Section 6
              _buildSection(
                '6. Account Registration & Security',
                'To use certain features, you must create an account and:\n'
                '• Provide accurate and complete information\n'
                '• Keep your login credentials confidential\n'
                '• Accept responsibility for all activity under your account\n\n'
                'App Merchant, Inc. is not responsible for unauthorized access caused by:\n'
                '• Weak passwords\n'
                '• Lost or stolen devices\n'
                '• Shared accounts\n'
                '• User negligence',
              ),

              // Section 7
              _buildSection(
                '7. Sensitive Financial Data Disclaimer',
                'You may upload financial documents, credit-related information, or personal data voluntarily. By doing so, you acknowledge:\n'
                '• You are solely responsible for the accuracy and legality of all data you upload.\n'
                '• Credit Vault does not review, verify, or validate any financial documents or reports.\n'
                '• Credit Vault does not generate, modify, or correct credit or financial information.\n'
                '• You must independently verify all critical financial information.\n'
                '• App Merchant, Inc. is not liable for decisions, outcomes, or disputes related to your uploaded documents.',
              ),

              // Section 8
              _buildSection(
                '8. Not Financial Advice',
                'Credit Vault does not provide:\n'
                '• Financial advice\n'
                '• Legal advice\n'
                '• Tax advice\n'
                '• Investment guidance\n'
                '• Credit repair or score improvement services\n'
                '• Professional recommendations\n\n'
                'All tools and stored data are for organizational and informational purposes only. Consult a licensed professional for financial decisions.',
              ),

              // Section 9
              _buildSection(
                '9. Data Storage, Encryption & Security',
                'Credit Vault uses secure third-party hosting (such as AWS or Google Cloud). We use industry-standard encryption for data in transit and at rest.\n\n'
                'However, no system is perfectly secure. App Merchant, Inc. is not liable for:\n'
                '• Unauthorized access\n'
                '• Third-party breaches\n'
                '• Data loss\n'
                '• System outages\n'
                '• Device-level compromise\n'
                '• User-side security failures',
              ),

              // Section 10
              _buildSection(
                '10. Subscription, Billing & Payments',
                'Credit Vault may offer free or paid plans.\n\n'
                'Payment Methods\n'
                'Payments may be processed through:\n'
                '• Stripe (web subscriptions)\n'
                '• PayPal (for applicable plans)\n'
                '• Apple App Store\n'
                '• Google Play Store\n\n'
                'App Merchant, Inc. does not store or directly process credit card numbers.\n\n'
                'Auto-Renewal\n'
                'Subscriptions automatically renew unless cancelled.\n\n'
                'Cancellation\n'
                '• Apple users cancel via Apple Settings → Subscriptions\n'
                '• Google users cancel via Google Play → Payments & Subscriptions\n'
                '• Web users cancel via Credit Vault account settings\n\n'
                'Deleting the app does not cancel your subscription.\n\n'
                'Refunds\n'
                'Refunds follow the policy of the payment processor used. Web-based refunds (Stripe/PayPal) are granted only where required by law or at our discretion.',
              ),

              // Section 11
              _buildSection(
                '11. Lifetime, One-Time Purchase & Non-Recurring Access',
                'Some Credit Vault plans may offer "lifetime," "one-time," or permanent access ("Lifetime Access").\n\n'
                'Lifetime Access refers ONLY to the operational lifetime of the Credit Vault platform, as determined solely by App Merchant, Inc.\n'
                'It does not refer to:\n'
                '• The lifetime of the user\n'
                '• The lifetime of a device\n'
                '• Guaranteed continued availability\n'
                '• Ongoing updates or feature additions\n'
                '• Platform presence on app stores\n\n'
                'If the platform is discontinued, changed, removed from stores, or unsupported, continued access is not guaranteed. No refunds or compensation will be provided for platform retirement or discontinuation.',
              ),

              // Section 12
              _buildSection(
                '12. Payments Between Users and Coaches',
                'If Credit Vault allows users to interact with coaches, you acknowledge:\n'
                '• App Merchant, Inc. is not a party to any agreement between users and coaches\n'
                '• We do not manage, guarantee, or oversee any payments or exchanges between users and coaches\n'
                '• We are not responsible for payment disputes, refunds, failures, chargebacks, or financial outcomes\n'
                '• We do not verify or endorse any financial coaching, advice, or guidance\n'
                '• All financial arrangements between users and coaches are strictly between those parties.',
              ),

              // Section 13
              _buildSection(
                '13. PayPal Requirements',
                'PayPal Requirement for Coaches and Freelancers\n'
                'Credit Vault includes features that allow coaches, tutors, freelancers, and similar service providers ("Coaches") to receive payments from students, clients, or parents ("Users").\n\n'
                'By using the coaching or freelancer features within Credit Vault, you acknowledge and agree to the following:\n'
                '• Coaches must have an active, valid PayPal account in good standing in order to receive payments through the Service.\n'
                '• Credit Vault does not process or hold payments. All payments move directly through PayPal from Users to Coaches.\n'
                '• App Merchant, Inc. is not responsible for: PayPal account holds or freezes, delayed, failed, or reversed transfers, incorrect payment setup by a Coach, chargebacks, disputes, or refunds, PayPal fees or policies, PayPal account suspensions or terminations.\n'
                '• All payment disputes or issues between Coaches and Users are strictly between those parties.\n'
                '• App Merchant, Inc. does not reimburse funds, enforce payments, mediate disputes, or guarantee financial performance for Coaches.\n'
                '• Coaches are solely responsible for maintaining accurate PayPal information in the app.\n'
                '• By participating as a Coach or Freelancer, you accept full responsibility for establishing and maintaining your PayPal account.\n\n'
                'PayPal Requirements for Students and Parents\n'
                'Students, parents, or clients ("Users") may use Credit Vault to connect with Coaches and pay for services.\n\n'
                'By using the Service, you acknowledge the following:\n'
                '• A PayPal account is not required for students, parents, or general Users to use Credit Vault.\n'
                '• However, if you choose to make payments to Coaches through the PayPal system, you must have an active PayPal account capable of sending payments.\n'
                '• All payments made to Coaches using PayPal are direct transactions between the User and the Coach.\n'
                '• App Merchant, Inc. is not responsible for: Any fees charged by PayPal, failed or reversed payments, refunds, disputes, or chargebacks, issues related to incorrect payment amounts or accidental transfers, PayPal account limitations, holds, or closure.\n'
                '• App Merchant, Inc. does not monitor or enforce payment obligations between Users and Coaches.\n'
                '• Any disputes related to payments must be resolved directly between the User and the Coach, or through PayPal\'s dispute resolution process.\n'
                '• By making payments through PayPal, Users agree to follow PayPal\'s terms, conditions, and policies.',
              ),

              // Section 14
              _buildSection(
                '14. Accuracy Disclaimer',
                '(Incorporates your original CV language)\n\n'
                'All documents, reports, and electronic information provided or stored within Credit Vault are offered "as is" and used at your own risk. App Merchant, Inc. is not responsible for:\n'
                '• Accuracy\n'
                '• Usefulness\n'
                '• Completeness\n'
                '• Reliability\n'
                '• Availability\n'
                '• Fitness for a particular purpose\n\n'
                'We make no guarantees regarding correctness of stored or generated data.',
              ),

              // Section 15
              _buildSection(
                '15. Liability Disclaimer',
                'To the fullest extent permitted by law, App Merchant, Inc. and its officers, employees, and affiliates are not liable for:\n'
                '• Financial loss\n'
                '• Loan denial\n'
                '• Credit score changes\n'
                '• Payment disputes\n'
                '• Accuracy of user-uploaded content\n'
                '• Data loss, breaches, or unauthorized access\n'
                '• Errors, interruptions, or service outages\n'
                '• Consequential, incidental, or indirect damages\n\n'
                'Your sole remedy is to discontinue use of the Service.',
              ),

              // Section 16
              _buildSection(
                '16. Intellectual Property',
                'All original content, software, design, functionality, and reports are owned by App Merchant, Inc. User-uploaded content remains the property of the user.\n\n'
                'You may not:\n'
                '• Copy\n'
                '• Reverse-engineer\n'
                '• Sell\n'
                '• Distribute\n'
                '• Reproduce\n'
                '• Exploit the platform or its components\n\n'
                'Without written permission.',
              ),

              // Section 17
              _buildSection(
                '17. Indemnification',
                'You agree to indemnify and hold harmless App Merchant, Inc., its officers, employees, licensees, and affiliates against any claims, damages, losses, or expenses arising out of:\n'
                '• Your use of Credit Vault\n'
                '• Your uploaded data\n'
                '• Your violation of these Terms\n'
                '• Any fraudulent or illegal financial information you provide',
              ),

              // Section 18
              _buildSection(
                '18. Termination',
                'We may suspend or terminate your account at any time, with or without cause or notice. Upon termination:\n'
                '• Your right to use the Service ends immediately\n'
                '• All associated data may be deleted\n'
                '• We are not obligated to restore or retain any data\n\n'
                'Sections relating to accuracy, liability, intellectual property, and indemnification survive termination.',
              ),

              // Section 19
              _buildSection(
                '19. Force Majeure',
                '(From your original ToU)\n\n'
                'App Merchant, Inc. is not responsible for delays or failures caused by events outside our control, including but not limited to:\n'
                '• Natural disasters\n'
                '• War, terrorism, or civil unrest\n'
                '• Labor disputes\n'
                '• Utility failures\n'
                '• Internet or hosting outages\n'
                '• Hardware/software failures beyond our control\n\n'
                'We will resume operations as soon as reasonably possible.',
              ),

              // Section 20
              _buildSection(
                '20. Governing Law',
                'These Terms are governed by the laws of the State of Florida, USA, without regard to conflict-of-law principles.',
              ),

              // Section 21
              _buildSection(
                '21. Notification of Changes',
                'App Merchant, Inc. may update these Terms at any time. Changes will be posted within the app or on the website. Continued use of the Service signifies acceptance of updated Terms.',
              ),

              // Section 22
              _buildSection(
                '22. Contact',
                'For questions, support, or legal concerns:\n'
                '📧 creditvaultapp@gmail.com',
              ),

              SizedBox(height: 40.v),
              Divider(thickness: 2, color: Colors.grey[300]),
              SizedBox(height: 40.v),

              // Privacy Policy Header
              Text(
                'Credit Vault – Privacy Policy',
                style: TextStyle(
                  fontSize: 22.fSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.v),
              Text(
                'Effective Date: March 21, 2024',
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Last Updated: December 17, 2025',
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Operated by: App Merchant, Inc.',
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'Contact: creditvaultapp@gmail.com',
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 24.v),

              // Privacy Policy Section 1
              _buildSection(
                '1. Introduction',
                'This Privacy Policy describes how Credit Vault ("Credit Vault," "we," "our," or "us") collects, uses, stores, and protects your information when you use our mobile applications, web applications, and related services (collectively, the "Service").\n\n'
                'Credit Vault is owned and operated by App Merchant, Inc., headquartered in Florida, USA.\n\n'
                'By accessing or using Credit Vault, you agree to this Privacy Policy. If you do not agree, please do not use the Service.',
              ),

              // Privacy Policy Section 2
              _buildSection(
                '2. About This Policy',
                'This Privacy Policy applies to:\n'
                '• The Credit Vault mobile and web apps\n'
                '• Any websites or landing pages that link to this Policy\n'
                '• All roles using the Service, including students, parents/guardians, coaches, tutors, and freelancers\n\n'
                'This Policy explains:\n'
                '• What information we collect\n'
                '• How we use it\n'
                '• How we share it\n'
                '• How we secure it\n'
                '• Your choices and rights regarding your data\n\n'
                'In some jurisdictions (e.g., GDPR in the EU/EEA), you may have additional legal rights, which are addressed in Section 12.',
              ),

              // Privacy Policy Section 3
              _buildSection(
                '3. Information We Collect',
                'We collect the minimum information necessary to operate Credit Vault, provide subscriptions, and support interactions between students, parents, and coaches.\n\n'
                '3.1 Account Information\n'
                'When you register or manage an account, we may collect:\n'
                '• Name\n'
                '• Email address\n'
                '• Role (e.g., student, parent, coach/freelancer)\n'
                '• Encrypted password or authentication tokens\n'
                '• Basic profile details you choose to add (e.g., class participation, schedule preferences)\n\n'
                '3.2 Usage & Class Information\n'
                'When you use the Service, we may collect:\n'
                '• Classes, sessions, or events you create, join, or attend\n'
                '• Tokens or credits purchased or used (if applicable to your plan)\n'
                '• Attendance history and participation details\n'
                '• Communication preferences and notification settings\n\n'
                '3.3 Payment & Billing Information\n'
                'Credit Vault uses third-party payment processors to handle all billing and subscription payments.\n\n'
                'Depending on your platform, payments may be processed by:\n'
                '• Apple App Store\n'
                '• Google Play Store\n'
                '• Stripe (web payments)\n'
                '• PayPal (especially for coach/freelancer payments)\n\n'
                'We do not store your full payment card numbers. Payment details are handled under the respective privacy and security terms of Apple, Google, Stripe, and PayPal.\n\n'
                'We may store:\n'
                '• The fact that a payment occurred\n'
                '• Subscription plan, status, renewal date\n'
                '• Last 4 digits of a card or masked billing info provided by the processor\n'
                '• Transaction IDs or receipts for accounting purposes\n\n'
                '3.4 Communications & Support\n'
                'When you contact us or use in-app support, we may collect:\n'
                '• Email content and support messages\n'
                '• Feedback, surveys, or form responses\n'
                '• Bug reports, error logs, and related details\n\n'
                '3.5 Device & Technical Information\n'
                'We may automatically collect limited technical data for security, analytics, and performance:\n'
                '• Device type and operating system\n'
                '• Browser type (for web users)\n'
                '• IP address and approximate location\n'
                '• App version, language, and time zone\n'
                '• Log data (e.g., error logs, crash reports)\n\n'
                'This is similar in scope to what you collect for Bond By Voice and Candle Recall.\n\n'
                '3.6 Cookies & Tracking (Web Only)\n'
                'On our website or web app, we may use cookies and similar technologies to:\n'
                '• Keep you logged in\n'
                '• Remember preferences\n'
                '• Analyze site usage and performance\n'
                '• Support basic marketing and analytics\n\n'
                'These tools may involve third-party partners such as Google Analytics or Firebase Analytics, consistent with your other apps.\n\n'
                'You can adjust cookie preferences through your browser settings; disabling cookies may affect some website features.',
              ),

              // Privacy Policy Section 4
              _buildSection(
                '4. How We Use Your Information',
                'We use the information we collect to:\n\n'
                'Provide and Operate the Service\n'
                '• Create and manage accounts\n'
                '• Enable scheduling, classes, and session tracking\n'
                '• Process subscriptions and payments\n\n'
                'Support Coaches, Parents, and Students\n'
                '• Help coaches manage classes and attendance\n'
                '• Help parents and students track participation and credits/tokens\n\n'
                'Improve and Secure the Platform\n'
                '• Monitor system performance and fix bugs\n'
                '• Prevent abuse, fraud, or unauthorized access\n'
                '• Analyze usage patterns to improve features and usability\n\n'
                'Communicate With You\n'
                '• Send service-related emails and notifications (e.g., account alerts, security notices, billing issues)\n'
                '• Respond to support requests\n'
                '• Send optional product updates, tips, and promotional communications (which you may opt out of at any time)\n\n'
                'Legal & Compliance\n'
                '• Comply with applicable laws and regulations\n'
                '• Enforce our Terms of Use\n'
                '• Maintain records for tax, accounting, and regulatory purposes\n\n'
                'We do not use your personal information to provide investment, lending, credit repair, or financial advice.',
              ),

              // Privacy Policy Section 5
              _buildSection(
                '5. Special Notes on Payments Between Users and Coaches',
                'Credit Vault may allow coaches/freelancers to be paid directly by students or parents, typically via PayPal or another external payment channel.\n\n'
                '• These payments are direct transactions between users and coaches.\n'
                '• App Merchant, Inc. does not act as an escrow agent, broker, or guarantor.\n'
                '• We may store basic metadata (e.g., whether a payment was recorded in the system) but we do not see full account details or control funds.\n'
                '• Any disputes, chargebacks, or issues related to those payments are governed by the payment provider\'s policies (e.g., PayPal) and must be resolved between the parties and that provider.',
              ),

              // Privacy Policy Section 6
              _buildSection(
                '6. Legal Bases for Processing (For GDPR and Similar Laws)',
                'Where applicable law (such as GDPR) requires a legal basis for processing, we rely on:\n\n'
                'Contract – To provide the Service you sign up for and to fulfill our obligations under our Terms of Use.\n\n'
                'Legitimate Interests – To improve the Service, prevent abuse, secure our systems, and understand how the platform is used.\n\n'
                'Consent – For certain types of marketing communications, cookies, or where required for processing children\'s data with parental approval.\n\n'
                'Legal Obligation – To comply with applicable laws, regulations, or valid legal requests.',
              ),

              // Privacy Policy Section 7
              _buildSection(
                '7. How We Share Your Information',
                'We do not sell your personal data.\n\n'
                'We may share your information with:\n\n'
                'Service Providers / Vendors\n'
                'Trusted third parties who assist us with:\n'
                '• Cloud hosting (e.g., AWS, Google Cloud)\n'
                '• Authentication and analytics (e.g., Firebase)\n'
                '• Subscription management (e.g., RevenueCat, if used)\n'
                '• Payment processing (Apple, Google Play, Stripe, PayPal)\n'
                '• Email delivery or support tools\n\n'
                'These providers are contractually restricted from using your data for purposes other than providing services to us.\n\n'
                'Coaches, Parents, and Students (By Functionality)\n'
                'Credit Vault allows users to connect around classes or sessions. Within this limited context, we may display:\n'
                '• Your name and role (e.g., student, parent, coach)\n'
                '• Class participation or attendance status\n'
                '• Limited contact or profile info necessary for the platform to function\n\n'
                'Legal and Compliance\n'
                'We may disclose information when required to:\n'
                '• Comply with a law, regulation, subpoena, or court order\n'
                '• Respond to lawful requests by public authorities\n'
                '• Protect the rights, property, or safety of App Merchant, Inc., our users, or others\n\n'
                'Business Transfers\n'
                'In the event of a merger, acquisition, or sale of assets, your data may be transferred as part of that transaction, subject to this Privacy Policy or a successor policy that offers materially similar protections.',
              ),

              // Privacy Policy Section 8
              _buildSection(
                '8. Data Retention',
                'We retain personal information only as long as necessary to:\n'
                '• Maintain your account\n'
                '• Provide the Service\n'
                '• Meet legal, tax, and regulatory requirements\n'
                '• Enforce our Terms of Use\n\n'
                'When data is no longer needed, we will either delete it or de-identify it in a commercially reasonable manner.\n\n'
                'You may request deletion of your account and associated data (see Section 12), subject to any legal obligations we may have to retain certain records.',
              ),

              // Privacy Policy Section 9
              _buildSection(
                '9. Data Security',
                'We implement technical and organizational measures designed to protect your data against unauthorized access, loss, misuse, or disclosure, including:\n'
                '• Encrypted data transmission (HTTPS/SSL)\n'
                '• Encrypted storage where appropriate\n'
                '• Access controls and authentication safeguards\n'
                '• Regular monitoring for unusual activity\n\n'
                'However, no method of transmission or storage is 100% secure. We cannot guarantee absolute security and are not responsible for breaches that arise from third-party infrastructure beyond our reasonable control, consistent with your other projects.\n\n'
                'You are responsible for:\n'
                '• Keeping your password confidential\n'
                '• Logging out of shared devices\n'
                '• Using strong, unique passwords',
              ),

              // Privacy Policy Section 10
              _buildSection(
                '10. Children\'s Privacy & COPPA',
                'Credit Vault follows similar principles as your other apps with respect to children\'s privacy, with additional student-specific rules.\n\n'
                'Under 13: Children under 13 may not create an account by themselves. Any use by a child under 13 must occur under a parent or legal guardian\'s account and supervision, in compliance with the Terms of Use.\n\n'
                '13–17: Students aged 13–17 may use a student account for class participation only.\n\n'
                'We do not knowingly collect personal information from children under 13 without verifiable parental consent. If we learn that a child under 13 has provided information without proper authorization, we will take steps to delete that information and may disable the related account.\n\n'
                'If you believe a child under 13 has provided us personal information without consent, please contact us immediately at creditvaultapp@gmail.com.',
              ),

              // Privacy Policy Section 11
              _buildSection(
                '11. International Use & Data Transfers',
                'Credit Vault is operated from the United States and complies with U.S. laws and regulations.\n\n'
                'If you access the Service from outside the U.S.:\n'
                '• Your data may be transferred to, stored in, and processed in the United States or other countries where we or our service providers operate.\n'
                '• These countries may have different data protection laws than your country of residence.\n'
                '• Where required, we use appropriate safeguards (such as contractual protections) to protect your data in cross-border transfers.\n\n'
                'By using the Service, you consent to this transfer, storage, and processing of your information.',
              ),

              // Privacy Policy Section 12
              _buildSection(
                '12. Your Rights and Choices',
                'Depending on your location and applicable law (for example, GDPR in the EU/EEA), you may have some or all of the following rights, similar to those outlined in the Bond By Voice policy:\n\n'
                'Access – Request a copy of the personal data we hold about you.\n\n'
                'Rectification – Request correction of inaccurate or incomplete data.\n\n'
                'Erasure ("Right to be Forgotten") – Request deletion of your personal data, subject to legal or contractual obligations.\n\n'
                'Restriction – Request that we limit how we process your data.\n\n'
                'Objection – Object to certain processing activities, such as direct marketing.\n\n'
                'Data Portability – Request that we provide your data in a structured, commonly used format for transfer to another service.\n\n'
                'Withdraw Consent – Where processing is based on consent, you may withdraw it at any time.\n\n'
                'To exercise any of these rights, contact us at creditvaultapp@gmail.com. We may need to verify your identity before fulfilling your request.\n\n'
                'You can also:\n'
                '• Unsubscribe from marketing emails by using the "unsubscribe" link in the message.\n'
                '• Adjust cookie settings through your browser.',
              ),

              // Privacy Policy Section 13
              _buildSection(
                '13. No Sale of Personal Data',
                'We do not sell, lease, or rent your personal data to third parties.\n\n'
                'We may use aggregated or de-identified data for analytics, performance, and product improvement, but this information does not identify you personally.',
              ),

              // Privacy Policy Section 14
              _buildSection(
                '14. External Links',
                'Our website or app may contain links to third-party sites or services (for example, app stores, payment providers, social media, or external resources).\n\n'
                'We are not responsible for the privacy practices, security, or content of these external sites. We encourage you to review their privacy policies before providing any personal information.',
              ),

              // Privacy Policy Section 15
              _buildSection(
                '15. Changes to This Privacy Policy',
                'We may update this Privacy Policy periodically to reflect changes in our practices, technologies, or legal requirements.\n\n'
                'When we make material changes, we will:\n'
                '• Update the "Last Updated" date at the top of this Policy, and\n'
                '• Provide additional notice where required (e.g., in-app notice or email).\n\n'
                'Your continued use of Credit Vault after changes become effective constitutes your acceptance of the revised Privacy Policy.',
              ),

              // Privacy Policy Section 16
              _buildSection(
                '16. Contact Us',
                'If you have questions about this Privacy Policy, your data, or your rights, please contact us at:\n\n'
                'Email: creditvaultapp@gmail.com\n'
                'Subject Line: "Credit Vault – Privacy Inquiry"',
              ),

              SizedBox(height: 30.v),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10.v),
          Text(
            content,
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


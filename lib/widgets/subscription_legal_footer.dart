import 'dart:io';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/view/student_view/settings_page/legal_policies_screen/legal_policies_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Legal URLs and copy required by Apple for auto-renewable subscriptions.
class SubscriptionLegalLinks {
  SubscriptionLegalLinks._();

  static const String appleStandardEulaUrl =
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';

  /// Paste into App Store Connect → App Description when using Apple's standard EULA.
  static const String appStoreDescriptionEulaLine =
      'Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';

  static const String autoRenewDisclosure =
      'Payment will be charged to your Apple ID account at confirmation of purchase. '
      'Subscriptions automatically renew unless canceled at least 24 hours before the end of the current period. '
      'Your account will be charged for renewal within 24 hours prior to the end of the current period. '
      'You can manage and cancel subscriptions in your App Store account settings after purchase.';
}

/// Subscription disclaimer + tappable Privacy Policy and Terms of Use links.
class SubscriptionLegalFooter extends StatelessWidget {
  const SubscriptionLegalFooter({super.key});

  Future<void> _openTermsOfUse(BuildContext context) async {
    if (Platform.isIOS) {
      final uri = Uri.parse(SubscriptionLegalLinks.appleStandardEulaUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return;
    }
    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const LegalPoliciesScreen(),
      ),
    );
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const LegalPoliciesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final linkStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w600,
      fontSize: 11.fSize,
      height: 1.4,
    );
    final bodyStyle = theme.textTheme.bodySmall?.copyWith(
      color: Colors.grey[600],
      fontSize: 10.fSize,
      height: 1.4,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Column(
        children: [
          Text(
            SubscriptionLegalLinks.autoRenewDisclosure,
            textAlign: TextAlign.center,
            style: bodyStyle,
          ),
          SizedBox(height: 12.v),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: bodyStyle,
              children: [
                const TextSpan(text: 'By subscribing, you agree to our '),
                TextSpan(
                  text: 'Terms of Use (EULA)',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openTermsOfUse(context),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openPrivacyPolicy(context),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

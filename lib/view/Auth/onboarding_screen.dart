import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../SharedPref/Shared_pref.dart' show SharedPreferencesManager;
import '../../core/app_export.dart';
import '../../core/utils/utils.dart';
import '../../provider/iap_provider.dart';

import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final int initialPage;
  const OnboardingScreen({this.initialPage = 0, super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}


class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalSteps = 9; // Requirements say "Step 1 of 9"

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
  }


  // Options for different screens
  final List<Map<String, String>> _occupationOptions = [
    {'emoji': '📚', 'label': 'Tutor'},
    {'emoji': '🎓', 'label': 'Coach'},
    {'emoji': '👶', 'label': 'Babysitter / Nanny'},
    {'emoji': '🐕', 'label': 'Dog Walker / Pet Care'},
    {'emoji': '🎵', 'label': 'Music / Sports Instructor'},
    {'emoji': '👤', 'label': 'Other Freelancer'},
  ];

  final List<String> _trackingOptions = [
    'I write it down',
    'Spreadsheet',
    'Phone notes',
    'I try to remember',
    'I don\'t track them',
  ];

  final List<String> _painPointOptions = [
    'Yes, multiple times',
    'Once or twice',
    'Not yet',
  ];

  final List<String> _clientCountOptions = [
    '1–3',
    '4–10',
    '10+',
  ];

  final List<String> _sessionCostOptions = [
    'Under 10',
    '10–20',
    '20–40',
    '40–60',
    '60+',
  ];

  // Selection states
  String? _selectedOccupation;
  String? _selectedTracking;
  String? _selectedPainPoint;
  String? _selectedClientCount;
  String? _selectedSessionCost;
  String _selectedSubscription = 'Annual';

  void _nextPage() {
    if (_currentPage < 9) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  void prevPage (){
    if(_currentPage>0){
      _pageController.previousPage(duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(0.02),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                if (_currentPage < 7) _buildProgressBar(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildWelcomeScreen(),
                      _buildOccupationScreen(),
                      _buildTrackingScreen(),
                      _buildPainPointScreen(),
                      _buildMomentumScreen(),
                      _buildSessionCostScreen(),
                      _buildSummaryScreen(),
                      _buildPrimerOne(),
                      _buildPrimerTwo(),
                      _buildPaywall(),
                    ],
                  ),
                ),
              ],
            ),
            if (ref.watch(iapProvider).isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),

    );
  }

  Widget _buildProgressBar() {
    double progress = (_currentPage + 1) / _totalSteps;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.v),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Step ${_currentPage + 1} of $_totalSteps",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.v),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.h),
            child: LinearProgressIndicator(
              value: progress > 1 ? 1 : progress,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              minHeight: 8.v,
            ),
          ),
        ],
      ),
    );
  }

  // --- Screen 1: Welcome ---
  Widget _buildWelcomeScreen() {
    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.appLogo,
            height: 120.v,
            width: 120.h,
          ),
          SizedBox(height: 40.v),
          Text(
            "Welcome to CreditVault",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.v),
          Text(
            "You just downloaded the easiest way to track client sessions and payments.\n\nNo spreadsheets. No guessing. No forgotten sessions.",
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.v),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBulletPoint("Coaches"),
              _buildBulletPoint("Tutors"),
              _buildBulletPoint("Babysitters"),
              _buildBulletPoint("Freelancers"),
            ],
          ),
          const Spacer(),
          CustomElevatedButton(
            text: "Start Setup",
            onPressed: _nextPage,
            buttonStyle: CustomButtonStyles.fillPrimaryTL8,
            buttonTextStyle: CustomTextStyles.titleMediumWhiteA700SemiBold_1,
          ),
          SizedBox(height: 8.v),
          Text(
            "Takes less than 30 seconds.",
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  // --- Screen 2: Occupation ---
  Widget _buildOccupationScreen() {
    return _buildQuestionScreen(
      title: "What type of work do you do?",
      helperText: "This helps us tailor CreditVault for you.",
      options: _occupationOptions.map((opt) {
        return _buildSelectableTile(
          title: opt['label']!,
          leading: Text(opt['emoji']!, style: TextStyle(fontSize: 20.fSize)),
          isSelected: _selectedOccupation == opt['label'],
          onTap: () {
            setState(() => _selectedOccupation = opt['label']);
            _nextPage();
          },
        );
      }).toList(),
    );
  }

  // --- Screen 3: Tracking Method ---
  Widget _buildTrackingScreen() {
    return _buildQuestionScreen(
      title: "How do you track sessions today?",
      helperText: "Most freelancers lose money because sessions are hard to track manually.",
      options: _trackingOptions.map((opt) {
        return _buildSelectableTile(
          title: opt,
          isSelected: _selectedTracking == opt,
          onTap: () {
            setState(() => _selectedTracking = opt);
            _nextPage();
          },
        );
      }).toList(),
    );
  }

  // --- Screen 4: Pain Point ---
  Widget _buildPainPointScreen() {
    return _buildQuestionScreen(
      title: "Have you ever forgotten a session or payment?",
      helperText: "Just one missed \$40 session can cost more than the entire app for the year.\n\nCreditVault makes sure that never happens again.",
      options: _painPointOptions.map((opt) {
        return _buildSelectableTile(
          title: opt,
          isSelected: _selectedPainPoint == opt,
          onTap: () {
            setState(() => _selectedPainPoint = opt);
            _nextPage();
          },
        );
      }).toList(),
    );
  }

  // --- Screen 5: Momentum (Clients) ---
  Widget _buildMomentumScreen() {
    return _buildQuestionScreen(
      title: "How many clients do you currently have?",
      helperText: "Setup Momentum - Get started in seconds.",
      options: _clientCountOptions.map((opt) {
        return _buildSelectableTile(
          title: opt,
          isSelected: _selectedClientCount == opt,
          onTap: () {
            setState(() => _selectedClientCount = opt);
            _nextPage();
          },
        );
      }).toList(),
    );
  }

  // --- Screen 6: Session Cost ---
  Widget _buildSessionCostScreen() {
    return _buildQuestionScreen(
      title: "What does one session usually cost?",
      helperText: "This helps us calculate how much CreditVault can protect for you.",
      options: _sessionCostOptions.map((opt) {
        return _buildSelectableTile(
          title: opt,
          isSelected: _selectedSessionCost == opt,
          onTap: () {
            setState(() => _selectedSessionCost = opt);
            _nextPage();
          },
        );
      }).toList(),
    );
  }

  // --- Screen 7: Summary ---
  Widget _buildSummaryScreen() {
    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.v),
          Text(
            "One forgotten session could cost you \$40+",
            style: theme.textTheme.headlineLarge,
          ),
          SizedBox(height: 32.v),
          Text(
            "CreditVault helps you:",
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 24.v),
          _buildCheckItem("Track prepaid session credits"),
          _buildCheckItem("See remaining sessions instantly"),
          _buildCheckItem("Avoid awkward payment reminders"),
          _buildCheckItem("Never lose track of sessions again"),
          const Spacer(),
          CustomElevatedButton(
            text: "Start My Free 14-Day Trial",
            onPressed: _nextPage,
          ),
          SizedBox(height: 12.v),
          Center(
            child: Text(
              "Most freelancers recover the cost of CreditVault after preventing just one missed session.",
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }

  // --- Screen 8: Primer 1 (Trial) ---
  Widget _buildPrimerOne() {
    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.appLogo,
            height: 100.v,
            width: 100.h,
          ),
          SizedBox(height: 48.v),
          Text(
            "Try Credit Vault Free",
            style: theme.textTheme.headlineLarge,
          ),
          SizedBox(height: 32.v),
          _buildCheckItem("Unlimited Clients", isLarge: true),
          _buildCheckItem("No payment due now", isLarge: true),
          _buildCheckItem("14-day free trial", isLarge: true),
          const Spacer(),
          CustomElevatedButton(
            text: "Continue",
            onPressed: _nextPage,
          ),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }

  // --- Screen 9: Primer 2 (Reminders) ---
  Widget _buildPrimerTwo() {
    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_active_outlined, size: 80.h, color: theme.colorScheme.primary),
          SizedBox(height: 48.v),
          _buildCheckItem("We’ll remind you before your trial ends", isLarge: true),
          _buildCheckItem("No surprises.", isLarge: true),
          _buildCheckItem("Cancel anytime.", isLarge: true),
          _buildCheckItem("No credit card required for the 14-day trial", isLarge: true),
          const Spacer(),
          CustomElevatedButton(
            text: "Continue for Free",
            onPressed: _nextPage,
          ),
          SizedBox(height: 8.v),
          Text(
            "Just \$99/year (\$8.25/month)",
            style: theme.textTheme.bodySmall?.copyWith(color: appTheme.black900),
          ),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }

  // --- Screen 10: Paywall ---
  Widget _buildPaywall() {
    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  SharedPreferencesManager.setOnboardingDone(true);
                  if (SharedPreferencesManager.getToken().isEmpty) {
                    // If not logged in, request login first
                    // Note: We don't set PendingOnboardingPurchase here because they chose to SKIP.
                    Navigator.pushNamed(context, AppRoutes.loginScreen, arguments: {
                      'userType': Utils.coachType,
                    });
                    return;
                  }
                  else{
                    SharedPreferencesManager.setOnboardingDone(true);
                    Navigator.pushReplacementNamed(context, AppRoutes.coachBottomNavBar,
                        arguments: {'userType': Utils.coachType});
                  }
                },
                child: Text("Skip", style: theme.textTheme.bodyMedium),
              ),

            ],
          ),
          SizedBox(height: 20.v),
          Text(
            "Choose Your Plan",
            style: theme.textTheme.headlineLarge,
          ),
          SizedBox(height: 32.v),
          _buildSubscriptionTile(
            title: "Monthly",
            price: "\$12.99",
            subtitle: "No free trial",
            isSelected: _selectedSubscription == 'Monthly',
            onTap: () => setState(() => _selectedSubscription = 'Monthly'),
          ),
          SizedBox(height: 16.v),
          _buildSubscriptionTile(
            title: "Annual ⭐ Best Value",
            price: "\$99/year",
            subtitle: "\$8.25/month • 14 day FREE trial",
            extra: "Save \$56 per year",
            isSelected: _selectedSubscription == 'Annual',
            isBestValue: true,
            onTap: () => setState(() => _selectedSubscription = 'Annual'),
          ),
          const Spacer(),
          CustomElevatedButton(
            text: _selectedSubscription == 'Annual' ? "Start 14-Day Free Trial" : "Subscribe Now",
            onPressed: () async {
              if (SharedPreferencesManager.getToken().isEmpty) {
                // If not logged in, request login first
                SharedPreferencesManager.setPendingOnboardingPurchase(true);
                Navigator.pushNamed(context, AppRoutes.loginScreen, arguments: {
                  'userType': Utils.coachType,
                });
                return;
              }


              final iap = ref.read(iapProvider.notifier);

              final productId = _selectedSubscription == 'Annual' 
                  ? 'year_plan_test'
                  : 'test_product_id';
              
              await iap.buyProduct(productId, isConsumable: false);
              
              if (mounted && ref.read(iapProvider).errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ref.read(iapProvider).errorMessage!)),
                );
              } else if (mounted) {
                // On success
                SharedPreferencesManager.setOnboardingDone(true);
                Navigator.pushReplacementNamed(context, AppRoutes.coachBottomNavBar,
                    arguments: {'userType': Utils.coachType});
              }
            },
          ),


          SizedBox(height: 20.v),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildQuestionScreen({
    required String title,
    required String helperText,
    required List<Widget> options,
  }) {
    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.headlineLarge),
          SizedBox(height: 24.v),
          Expanded(
            child: ListView(
              children: options,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.v, bottom: 8.v),
            child: Text(
              helperText,
              style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          // CustomElevatedButton(
          //   text: "Next",
          //   onPressed: _nextPage,
          // ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.v),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 20.h, color: theme.colorScheme.primary),
          SizedBox(width: 12.h),
          Text(text, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text, {bool isLarge = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.v),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: isLarge ? 24.h : 20.h, color: Colors.green),
          SizedBox(width: 16.h),
          Expanded(
            child: Text(
              text,
              style: (isLarge ? theme.textTheme.titleMedium : theme.textTheme.bodyLarge)?.copyWith(
                color: appTheme.black900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableTile({
    required String title,
    Widget? leading,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.v),
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.v),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading,
              SizedBox(width: 16.h),
            ],
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 24.h)
            else
              Container(
                width: 24.h,
                height: 24.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionTile({
    required String title,
    required String price,
    required String subtitle,
    String? extra,
    required bool isSelected,
    bool isBestValue = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16.h),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: appTheme.black900,
                        ),
                      ),
                      SizedBox(height: 4.v),
                      Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: appTheme.black900)),
                    ],
                  ),
                ),
                Text(
                  price,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            if (extra != null) ...[
              SizedBox(height: 12.v),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 4.v),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Text(
                  extra,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

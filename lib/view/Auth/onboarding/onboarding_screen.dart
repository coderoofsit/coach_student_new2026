import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_export.dart';
import '../../../features/onboarding/onboarding_provider.dart';
import '../../../widgets/custom_elevated_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalSteps = 10;

  void _nextPage() {
    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer.withOpacity(1),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
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
                  _WelcomeStep(onNext: _nextPage),
                  _OccupationStep(onNext: _nextPage),
                  _TrackingMethodStep(onNext: _nextPage),
                  _ForgottenExperienceStep(onNext: _nextPage),
                  _ClientCountStep(onNext: _nextPage),
                  _SessionCostStep(onNext: _nextPage),
                  _ValuePropStep(onNext: _nextPage),
                  _TrialPrimerStep1(onNext: _nextPage),
                  _TrialPrimerStep2(onNext: _nextPage),
                  _PaywallStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Step ${_currentPage + 1} of $_totalSteps",
            style: CustomTextStyles.bodySmallBlack900,
          ),
          SizedBox(height: 8.v),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.h),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / _totalSteps,
              minHeight: 8.v,
              backgroundColor: appTheme.gray200,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Step Widgets ---

class _WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomeStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        children: [
          const Spacer(flex: 2),
          CustomImageView(
            imagePath: ImageConstant.welcomeImage,

            fit: BoxFit.contain,
          ),
          const Spacer(),
          Text(
            "Welcome to CreditVault",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.v),
          Text(
            "You just downloaded the easiest way to\ntrack client sessions and payments.",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: appTheme.black900.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.v),
          _buildFeatureList(),
          SizedBox(height: 24.v),
          _buildPerfectForList(),
          const Spacer(flex: 3),
          CustomElevatedButton(
            text: "Start Setup",
            onPressed: onNext,
          ),
          SizedBox(height: 12.v),
          Text(
            "Takes less than 30 seconds.",
            style: CustomTextStyles.bodySmallBlack900.copyWith(
              color: appTheme.black900.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      "No spreadsheets.",
      "No guessing.",
      "No forgotten sessions.",
    ];
    
    return Column(
      children: features.map((f) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4.v),
        child: Text(
          f,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
      )).toList(),
    );
  }

  Widget _buildPerfectForList() {
    return Column(
      children: [
        Text(
          "Perfect for:",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: appTheme.black900.withOpacity(0.8),
          ),
        ),
        SizedBox(height: 8.v),
        Wrap(
          spacing: 12.h,
          runSpacing: 4.v,
          alignment: WrapAlignment.center,
          children: [
            _buildCheckmarkItem("Coaches"),
            _buildCheckmarkItem("Tutors"),
            _buildCheckmarkItem("Babysitters"),
            _buildCheckmarkItem("Freelancers"),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckmarkItem(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, size: 14.adaptSize, color: theme.colorScheme.primary),
        SizedBox(width: 4.h),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: appTheme.black900.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _OccupationStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _OccupationStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingProvider).occupation;
    final options = [
      {'label': 'Tutor', 'icon': '📚'},
      {'label': 'Coach', 'icon': '🎓'},
      {'label': 'Babysitter / Nanny', 'icon': '👶'},
      {'label': 'Dog Walker / Pet Care', 'icon': '🐕'},
      {'label': 'Music / Sports Instructor', 'icon': '🎹'},
      {'label': 'Other Freelancer', 'icon': '💼'},
    ];

    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What type of work do you do?",
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 20.v),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.v),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selected == option['label'];
                return InkWell(
                  onTap: () => ref.read(onboardingProvider.notifier).updateOccupation(option['label']!),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.v),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.h),
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : appTheme.gray300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(option['icon']!, style: const TextStyle(fontSize: 20)),
                        SizedBox(width: 12.h),
                        Text(
                          option['label']!,
                          style: CustomTextStyles.titleMediumBlack900_3.copyWith(
                            color: isSelected ? theme.colorScheme.primary : appTheme.black900,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(Icons.check_circle, color: theme.colorScheme.primary),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            "This helps us tailor CreditVault for you.",
            style: CustomTextStyles.bodySmallBlack900,
          ),
          SizedBox(height: 20.v),
          CustomElevatedButton(
            text: "Next",
            onPressed: selected.isNotEmpty ? onNext : null,
          ),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }
}

class _TrackingMethodStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _TrackingMethodStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingProvider).trackingMethod;
    final options = [
      "I write it down",
      "Spreadsheet",
      "Phone notes",
      "I try to remember",
      "I don't track them",
    ];

    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How do you track sessions today?",
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 20.v),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.v),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selected == option;
                return InkWell(
                  onTap: () => ref.read(onboardingProvider.notifier).updateTrackingMethod(option),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.v),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.h),
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : appTheme.gray300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          option,
                          style: CustomTextStyles.titleMediumBlack900_3.copyWith(
                            color: isSelected ? theme.colorScheme.primary : appTheme.black900,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(Icons.check_circle, color: theme.colorScheme.primary),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
             padding: EdgeInsets.all(12.h),
             decoration: BoxDecoration(
               color: Colors.amber.withOpacity(0.1),
               borderRadius: BorderRadius.circular(8.h),
             ),
             child: Text(
              "Most freelancers lose money because sessions are hard to track manually.",
              style: CustomTextStyles.bodyMediumBlack900.copyWith(color: Colors.amber[900]),
            ),
          ),
          SizedBox(height: 20.v),
          CustomElevatedButton(
            text: "Next",
            onPressed: selected.isNotEmpty ? onNext : null,
          ),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }
}

class _ForgottenExperienceStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _ForgottenExperienceStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingProvider).forgottenExperience;
    final options = [
      "Yes, multiple times",
      "Once or twice",
      "Not yet",
    ];

    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Have you ever forgotten a session or payment?",
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 20.v),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.v),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selected == option;
                return InkWell(
                  onTap: () => ref.read(onboardingProvider.notifier).updateForgottenExperience(option),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.v),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.h),
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : appTheme.gray300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          option,
                          style: CustomTextStyles.titleMediumBlack900_3.copyWith(
                            color: isSelected ? theme.colorScheme.primary : appTheme.black900,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(Icons.check_circle, color: theme.colorScheme.primary),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
             padding: EdgeInsets.all(12.h),
             decoration: BoxDecoration(
               color: theme.colorScheme.primary.withOpacity(0.1),
               borderRadius: BorderRadius.circular(8.h),
             ),
             child: Text(
              "Just one missed \$40 session can cost more than the entire app for the year.\n\nCreditVault makes sure that never happens again.",
              style: CustomTextStyles.bodyMediumBlack900.copyWith(color: theme.colorScheme.primary),
            ),
          ),
          SizedBox(height: 20.v),
          CustomElevatedButton(
            text: "Next",
            onPressed: selected.isNotEmpty ? onNext : null,
          ),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }
}

class _ClientCountStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _ClientCountStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingProvider).clientCount;
    final options = ["1–3", "4–10", "10+"];

    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How many clients do you currently have?",
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 20.v),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.v),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selected == option;
                return InkWell(
                  onTap: () => ref.read(onboardingProvider.notifier).updateClientCount(option),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.v),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.h),
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : appTheme.gray300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      option,
                      style: CustomTextStyles.titleMediumBlack900_3.copyWith(
                        color: isSelected ? theme.colorScheme.primary : appTheme.black900,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          CustomElevatedButton(
            text: "Next",
            onPressed: selected.isNotEmpty ? onNext : null,
          ),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }
}

class _SessionCostStep extends ConsumerWidget {
  final VoidCallback onNext;
  const _SessionCostStep({required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingProvider).sessionCost;
    final options = ["Under \$10", "\$10–\$20", "\$20–\$40", "\$40–\$60", "\$60+"];

    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What does one session usually cost?",
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 20.v),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.v),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selected == option;
                return InkWell(
                  onTap: () => ref.read(onboardingProvider.notifier).updateSessionCost(option),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.v),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.h),
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : appTheme.gray300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      option,
                      style: CustomTextStyles.titleMediumBlack900_3.copyWith(
                        color: isSelected ? theme.colorScheme.primary : appTheme.black900,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            "This helps us calculate how much CreditVault can protect for you.",
            style: CustomTextStyles.bodySmallBlack900,
          ),
          SizedBox(height: 20.v),
          CustomElevatedButton(
            text: "Next",
            onPressed: selected.isNotEmpty ? onNext : null,
          ),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }
}

class _ValuePropStep extends StatelessWidget {
  final VoidCallback onNext;
  const _ValuePropStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "One forgotten session could cost you \$40+",
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 20.v),
          Text(
            "CreditVault helps you:",
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 20.v),
          _buildCheckItem(context, "Track prepaid session credits"),
          _buildCheckItem(context, "See remaining sessions instantly"),
          _buildCheckItem(context, "Avoid awkward payment reminders"),
          _buildCheckItem(context, "Never lose track of sessions again"),
          const Spacer(),
          CustomElevatedButton(
            text: "Start My Free 14-Day Trial",
            onPressed: onNext,
          ),
          SizedBox(height: 10.v),
          Text(
            "Most freelancers recover the cost of CreditVault after preventing just one missed session.",
            style: CustomTextStyles.bodySmallBlack900,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.v),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 12.h),
          Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}

class _TrialPrimerStep1 extends StatelessWidget {
  final VoidCallback onNext;
  const _TrialPrimerStep1({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        children: [
          const Spacer(),
          // Placeholder for large logo
          CustomImageView(
            imagePath: ImageConstant.appLogo,
            height: 300.v,
          ),
          SizedBox(height: 20.v),
          Text(
            "Try Credit Vault Free",
            style: theme.textTheme.headlineLarge,
          ),
          SizedBox(height: 30.v),
          _buildCheckListItem("Unlimited Clients"),
          _buildCheckListItem("No payment due now"),
          _buildCheckListItem("14-day free trial"),
          const Spacer(),
          CustomElevatedButton(
            text: "Continue",
            onPressed: onNext,
          ),
          SizedBox(height: 40.v),
        ],
      ),
    );
  }

  Widget _buildCheckListItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.v),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check, color: primaryColor),
          SizedBox(width: 10.h),
          Text(text, style: theme.textTheme.titleMedium!.copyWith(color: Colors.black)),
        ],
      ),
    );
  }
}

class _TrialPrimerStep2 extends StatelessWidget {
  final VoidCallback onNext;
  const _TrialPrimerStep2({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.h),
      child: Column(
        children: [
          const Spacer(),
          // Placeholder for large reminder icon
          const Icon(Icons.notifications_active, size: 180, color: primaryColor),
          SizedBox(height: 40.v),
          _buildCheckListItem("We’ll remind you before your trial ends"),
          _buildCheckListItem("No surprises."),
          _buildCheckListItem("Cancel anytime."),
          _buildCheckListItem("No credit card required for the 14-day trial"),
          const Spacer(),
          CustomElevatedButton(
            text: "Continue for Free",
            onPressed: onNext,
          ),
          SizedBox(height: 10.v),
          Text(
            "Just \$99/year (\$8.25/month)",
            style: CustomTextStyles.bodySmallBlack900,
          ),
          SizedBox(height: 40.v),
        ],
      ),
    );
  }

  Widget _buildCheckListItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.v),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, color: primaryColor),
          SizedBox(width: 10.h),
          Expanded(child: Text(text, style: theme.textTheme.titleMedium!.copyWith(color: Colors.black))),
        ],
      ),
    );
  }
}

class _PaywallStep extends StatefulWidget {
  @override
  State<_PaywallStep> createState() => _PaywallStepState();
}

class _PaywallStepState extends State<_PaywallStep> {
  String _selectedPlan = 'Annual';

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: EdgeInsets.all(24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.v),
              Text("Choose Your Plan", style: theme.textTheme.headlineSmall),
              SizedBox(height: 30.v),
              _buildPlanOption(
                context,
                id: 'Monthly',
                title: "Monthly",
                price: "\$12.99",
                subtitle: "No free trial",
                isSelected: _selectedPlan == 'Monthly',
                onTap: () => setState(() => _selectedPlan = 'Monthly'),
              ),
              SizedBox(height: 16.v),
              _buildPlanOption(
                context,
                id: 'Annual',
                title: "Annual ⭐ Best Value",
                price: "\$99/year",
                subtitle: "14 day FREE trial",
                isSelected: _selectedPlan == 'Annual',
                extraInfo: "(\$8.25/month) • Save \$56 per year",
                onTap: () => setState(() => _selectedPlan = 'Annual'),
              ),
              const Spacer(),
              CustomElevatedButton(
                text: "Get Started",
                onPressed: () async {
                  final success = await ref.read(onboardingProvider.notifier).completeOnboarding();
                  if (success && context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.coachBottomNavBar,
                      (route) => false,
                    );
                  }
                },
              ),
              SizedBox(height: 10.v),
              Center(
                child: TextButton(
                  onPressed: () async {
                    final success = await ref.read(onboardingProvider.notifier).completeOnboarding();
                    if (success && context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.coachBottomNavBar,
                        (route) => false,
                      );
                    }
                  },
                  child: Text("Skip for now", style: CustomTextStyles.bodySmallBlack900),
                ),
              ),
              SizedBox(height: 20.v),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanOption(
    BuildContext context, {
    required String id,
    required String title,
    required String price,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    String? extraInfo,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : appTheme.gray300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(width: 8.h),
                Text(
                  price,
                  style: theme.textTheme.headlineSmall!.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.v),
            Text(
              subtitle,
              style: CustomTextStyles.bodyMediumBlack900.copyWith(color: Colors.green),
            ),
            if (extraInfo != null) ...[
              SizedBox(height: 8.v),
              Text(
                extraInfo,
                style: CustomTextStyles.bodySmallBlack900,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

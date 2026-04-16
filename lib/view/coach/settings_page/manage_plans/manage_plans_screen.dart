import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/provider/iap_provider.dart';
import 'package:coach_student/provider/coach/coach_profile_provider.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_outlined_button.dart';
import 'package:iap_package/iap_package.dart';

final _selectedPlanProvider =
StateProvider.autoDispose<String>((ref) => 'Annual');

// ---------------------------------------------------------------------------
// Cross-platform product ID helpers (top-level so they can be used anywhere)
// ---------------------------------------------------------------------------
String get monthlyProductId =>
    Platform.isAndroid ? 'google_play_monthly_plan' : 'Monthly_Sub';

String get yearlyProductId =>
    Platform.isAndroid ? 'google_play_yearly_plan' : 'yearly_sub';

/// Returns the human-readable plan name for a given product ID,
/// regardless of platform.
String planNameFromId(String? id) {
  if (id == null) return '';
  if (id == monthlyProductId) return 'Monthly';
  if (id == yearlyProductId) return 'Annual';
  return '';
}

// ---------------------------------------------------------------------------

class ManagePlansScreen extends ConsumerStatefulWidget {
  const ManagePlansScreen({super.key});

  @override
  ConsumerState<ManagePlansScreen> createState() => _ManagePlansScreenState();
}

class _ManagePlansScreenState extends ConsumerState<ManagePlansScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(coachProfileProvider.notifier).getCoachProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final iapState = ref.watch(iapProvider);
    final profileState = ref.watch(coachProfileProvider);
    final selectedPlan = ref.watch(_selectedPlanProvider);

    final coachProfile = profileState.coachProfileDetailsModel;

    // Source of truth: backend profile only.
    final bool isSubscribed = coachProfile.isSubscribed ?? false;
    final String? activePlanId = coachProfile.activePlan;

    // FIX 1: activePlanName was commented out but used. Now derived via helper.
    final String activePlanName = planNameFromId(activePlanId);

    // FIX 2: price/subtitle helpers use the platform-aware ID, not a hardcoded one.
    String _priceFor(String productId, String fallback) {
      final products = iapState.products;
      final idx = products.indexWhere((p) => p.id == productId);
      return idx != -1 ? products[idx].price : fallback;
    }

    final String monthlyPrice = _priceFor(monthlyProductId, '\$12.99/month');
    final String yearlyPrice = _priceFor(yearlyProductId, '\$99/year');

    // Listen for IAP errors
    ref.listen<IAPState>(iapProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Subscription"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.v),
                  Text(
                    isSubscribed ? "Your Subscription" : "Choose Your Plan",
                    style: theme.textTheme.headlineLarge,
                  ),

                  // --- Trial banner ---
                  if (coachProfile.accessReason == 'trial') ...[
                    SizedBox(height: 12.v),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.h, vertical: 8.v),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.h),
                        border:
                        Border.all(color: Colors.amber.withOpacity(0.5)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer_outlined,
                                  color: Colors.amber[800], size: 20.h),
                              SizedBox(width: 8.h),
                              Text(
                                "Free Trial: ${coachProfile.trialDaysLeft} days left",
                                style:
                                theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.v),
                          Text(
                            "Get full access to all features",
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.amber[900]),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // --- Active plan badge ---
                  // FIX 1 (continued): activePlanName is now properly populated.
                  if (isSubscribed && activePlanName.isNotEmpty) ...[
                    SizedBox(height: 8.v),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.h, vertical: 4.v),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.h),
                      ),
                      child: Text(
                        "Active: $activePlanName Plan",
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 32.v),

                  // --- Monthly tile ---
                  // FIX 3: isActive now uses platform-aware monthlyProductId.
                  _buildSubscriptionTile(
                    ref: ref,
                    title: "Monthly",
                    price: monthlyPrice,
                    subtitle: "Flexible billing",
                    isSelected: selectedPlan == 'Monthly',
                    isActive: isSubscribed && activePlanId == monthlyProductId,
                    onTap: () =>
                    ref.read(_selectedPlanProvider.notifier).state =
                    'Monthly',
                  ),

                  SizedBox(height: 16.v),

                  // --- Annual tile ---
                  // FIX 2: price and subtitle both use platform-aware yearlyProductId.
                  // FIX 4: isActive uses platform-aware yearlyProductId.
                  _buildSubscriptionTile(
                    ref: ref,
                    title: "Annual ⭐ Best Value",
                    price: yearlyPrice,
                    subtitle: "$yearlyPrice • 14 day FREE trial",
                    extra: "Save with annual billing",
                    isSelected: selectedPlan == 'Annual',
                    isActive: isSubscribed && activePlanId == yearlyProductId,
                    isBestValue: true,
                    onTap: () =>
                    ref.read(_selectedPlanProvider.notifier).state =
                    'Annual',
                  ),

                  const Spacer(),

                  // --- Restore Purchases ---
                  TextButton.icon(
                    onPressed: iapState.isLoading
                        ? null
                        : () => ref.read(iapProvider.notifier).restore(),
                    icon: const Icon(Icons.restore),
                    label: const Text("Restore Purchases"),
                  ),
                  SizedBox(height: 12.v),

                  // --- Cancel Subscription (subscribed users only) ---
                  if (isSubscribed) ...[
                    CustomOutlinedButton(
                      text: "Cancel Subscription",
                      onPressed: () => ref
                          .read(iapProvider.notifier)
                          .openSubscriptionManagement(),
                      buttonStyle: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                      buttonTextStyle: const TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 12.v),
                  ],

                  // --- Main action button ---
                  _buildMainActionButton(
                      ref, selectedPlan, activePlanId, isSubscribed),

                  SizedBox(height: 20.v),
                ],
              ),
            ),

            // Loading overlay
            if (iapState.isLoading || profileState.isLoadingProfile)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainActionButton(
      WidgetRef ref,
      String selectedPlan,
      String? activePlanId,
      bool isSubscribed,
      ) {
    final iapState = ref.watch(iapProvider);

    // FIX 5: Use platform-aware IDs instead of hardcoded iOS-only IDs.
    final String selectedProductId =
    selectedPlan == 'Annual' ? yearlyProductId : monthlyProductId;

    final bool isSelectedPlanActive = Platform.isAndroid
        ? (isSubscribed && activePlanId == selectedProductId)
        : (activePlanId == selectedProductId);

    if (isSelectedPlanActive) {
      return CustomElevatedButton(
        text: "Plan Active",
        onPressed: null,
        buttonStyle: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
      );
    }

    final String buttonText = isSubscribed
        ? "Change to $selectedPlan"
        : (selectedPlan == 'Annual'
        ? "Start 14-Day Free Trial"
        : "Subscribe Now");

    return CustomElevatedButton(
      text: buttonText,
      onPressed: iapState.isLoading
          ? null
          : () async {
        final iap = ref.read(iapProvider.notifier);
        await iap.buyProduct(selectedProductId, isConsumable: false);
      },
    );
  }

  Widget _buildSubscriptionTile({
    required WidgetRef ref,
    required String title,
    required String price,
    required String subtitle,
    String? extra,
    required bool isSelected,
    required bool isActive,
    bool isBestValue = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(16.h),
          border: Border.all(
            color: isActive
                ? Colors.green
                : (isSelected
                ? theme.colorScheme.primary
                : Colors.grey.withOpacity(0.2)),
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
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8.h,
                        runSpacing: 4.v,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: appTheme.black900,
                            ),
                          ),
                          if (isActive)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.h, vertical: 2.v),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4.h),
                              ),
                              child: Text(
                                "ACTIVE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.fSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.v),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: appTheme.black900),
                      ),
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
                padding:
                EdgeInsets.symmetric(horizontal: 12.h, vertical: 4.v),
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
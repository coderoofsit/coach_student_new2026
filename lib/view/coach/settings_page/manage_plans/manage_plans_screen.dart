import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/provider/iap_provider.dart';
import 'package:coach_student/provider/coach/coach_profile_provider.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_outlined_button.dart';
import 'package:iap_package/iap_package.dart';

final _selectedPlanProvider = StateProvider.autoDispose<String>((ref) => 'Annual');

class ManagePlansScreen extends ConsumerStatefulWidget {
  const ManagePlansScreen({super.key});

  @override
  ConsumerState<ManagePlansScreen> createState() => _ManagePlansScreenState();
}

class _ManagePlansScreenState extends ConsumerState<ManagePlansScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh the coach profile when entering this screen to ensure latest plan status
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
    
    // Check backend first, fallback to local IAP state for immediate feedback
    bool isSubscribed = coachProfile.isSubscribed ?? false;
    String? activePlanId = coachProfile.activePlan;
    
    if (!isSubscribed && iapState.latestPurchase?.status == PurchaseStatus.success) {
      isSubscribed = true;
      activePlanId = iapState.latestPurchase?.productId;
    }

    // Map plan IDs to readable names for the active plan display
    String activePlanName = "";
    if (activePlanId == 'year_plan_test') activePlanName = "Annual";
    else if (activePlanId == 'test_product_id') activePlanName = "Monthly";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Subscription"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: Stack(
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
                if (isSubscribed && activePlanName.isNotEmpty) ...[
                  SizedBox(height: 8.v),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 4.v),
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
                _buildSubscriptionTile(
                  ref: ref,
                  title: "Monthly",
                  price: "\$12.99",
                  subtitle: "Flexible billing",
                  isSelected: selectedPlan == 'Monthly',
                  isActive: activePlanId == 'test_product_id',
                  onTap: () => ref.read(_selectedPlanProvider.notifier).state = 'Monthly',
                ),
                SizedBox(height: 16.v),
                _buildSubscriptionTile(
                  ref: ref,
                  title: "Annual ⭐ Best Value",
                  price: "\$99/year",
                  subtitle: "\$8.25/month • 14 day FREE trial",
                  extra: "Save \$56 per year",
                  isSelected: selectedPlan == 'Annual',
                  isActive: activePlanId == 'year_plan_test',
                  isBestValue: true,
                  onTap: () => ref.read(_selectedPlanProvider.notifier).state = 'Annual',
                ),
                const Spacer(),
                
                // Restore Purchases Button
                TextButton.icon(
                  onPressed: () => ref.read(iapProvider.notifier).restore(),
                  icon: const Icon(Icons.restore),
                  label: const Text("Restore Purchases"),
                ),
                SizedBox(height: 12.v),
                
                // Conditional Cancel Subscription Button
                if (isSubscribed) ...[
                  CustomOutlinedButton(
                    text: "Cancel Subscription",
                    onPressed: () => ref.read(iapProvider.notifier).openSubscriptionManagement(),
                    buttonStyle: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                    buttonTextStyle: const TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 12.v),
                ],

                // Main Action Button
                _buildMainActionButton(ref, selectedPlan, activePlanId, isSubscribed),
                
                SizedBox(height: 20.v),
              ],
            ),
          ),
          if (iapState.isLoading || profileState.isLoadingProfile)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainActionButton(WidgetRef ref, String selectedPlan, String? activePlanId, bool isSubscribed) {
    final String selectedProductId = selectedPlan == 'Annual' ? 'year_plan_test' : 'test_product_id';
    final bool isSelectedPlanActive = activePlanId == selectedProductId;

    if (isSelectedPlanActive) {
      return CustomElevatedButton(
        text: "Plan Active",
        onPressed: null, // Disabled
        buttonStyle: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
        ),
      );
    }

    return CustomElevatedButton(
      text: isSubscribed ? "Change to $selectedPlan" : (selectedPlan == 'Annual' ? "Start 14-Day Free Trial" : "Subscribe Now"),
      onPressed: () async {
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
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16.h),
          border: Border.all(
            color: isActive ? Colors.green : (isSelected ? theme.colorScheme.primary : Colors.grey.withOpacity(0.2)),
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
                      Row(
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: appTheme.black900,
                            ),
                          ),
                          if (isActive) ...[
                            SizedBox(width: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.v),
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
                        ],
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

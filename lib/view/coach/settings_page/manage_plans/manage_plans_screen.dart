import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/provider/iap_provider.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/SharedPref/Shared_pref.dart';

class ManagePlansScreen extends ConsumerStatefulWidget {
  const ManagePlansScreen({super.key});

  @override
  ConsumerState<ManagePlansScreen> createState() => _ManagePlansScreenState();
}

class _ManagePlansScreenState extends ConsumerState<ManagePlansScreen> {
  String _selectedSubscription = 'Annual';

  @override
  Widget build(BuildContext context) {
    final iapState = ref.watch(iapProvider);

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
                  "Choose Your Plan",
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(height: 16.v),
                Text(
                  "Get unlimited access to all features.",
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.v),
                _buildSubscriptionTile(
                  title: "Monthly",
                  price: "\$12.99",
                  subtitle: "Flexible billing",
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
                    final iap = ref.read(iapProvider.notifier);

                    // Use correct product IDs as discussed
                    final productId = _selectedSubscription == 'Annual' 
                        ? 'year_plan_test'
                        : 'test_product_id';
                    
                    await iap.buyProduct(productId, isConsumable: false);
                    
                    if (mounted && ref.read(iapProvider).errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(ref.read(iapProvider).errorMessage!)),
                      );
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Subscription successful!")),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
                SizedBox(height: 20.v),
              ],
            ),
          ),
          if (iapState.isLoading)
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
                        ),
                      ),
                      SizedBox(height: 4.v),
                      Text(subtitle, style: theme.textTheme.bodySmall),
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

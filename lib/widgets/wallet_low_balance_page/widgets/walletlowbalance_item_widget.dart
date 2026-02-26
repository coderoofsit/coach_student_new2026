import 'package:auto_size_text/auto_size_text.dart';
import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/models/coach_model/TranscationHistoryCoach.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/provider/coach/TranscationHistoryProvider.dart';

// ignore: must_be_immutable
class WalletlowbalanceItemWidget extends ConsumerWidget {
  final Transaction trnstactionData;
  const WalletlowbalanceItemWidget({Key? key, required this.trnstactionData})
      : super(key: key);

  String _getDisplayName() {
    final isPending = trnstactionData.status == "pending" && 
                      trnstactionData.type == "decrease";
    final isSuccessWithdrawal = trnstactionData.status == "success" && 
                                trnstactionData.type == "decrease";
    
    // If childrenId is present, show both teacher and child name
    if (trnstactionData.childrenId?.name != null && 
        trnstactionData.childrenId!.name.isNotEmpty) {
      final teacherName = trnstactionData.transactionWith?.name ?? "";
      final childName = trnstactionData.childrenId!.name;
      
      if (teacherName.isNotEmpty) {
        return "$teacherName - Child: $childName";
      } else {
        return "Child: $childName";
      }
    }
    
    // Then try transactionWith
    if (trnstactionData.transactionWith?.name != null && 
        trnstactionData.transactionWith!.name.isNotEmpty) {
      return trnstactionData.transactionWith!.name;
    }
    
    // For withdrawals
    if (isPending) {
      return "Withdrawal Pending";
    }
    if (isSuccessWithdrawal) {
      return "Token Withdrawal";
    }
    
    // Extract name from message for increase transactions
    // Message format: "On attending the Theory  class, Test st paid you 10 tokens."
    // Or for purchases: "You've successfully purchased 10 tokens!"
    if (trnstactionData.type == "increase" && 
        trnstactionData.message.isNotEmpty) {
      // Check if it's a purchase transaction
      if (trnstactionData.message.contains("purchased") || 
          trnstactionData.message.contains("successfully purchased")) {
        return "Token Purchase";
      }
      
      try {
        // Find the part before "paid you"
        final paidIndex = trnstactionData.message.indexOf(" paid you");
        if (paidIndex > 0) {
          // Find the last comma before "paid you"
          final commaIndex = trnstactionData.message.lastIndexOf(",", paidIndex);
          if (commaIndex > 0 && commaIndex < paidIndex) {
            final name = trnstactionData.message
                .substring(commaIndex + 1, paidIndex)
                .trim();
            if (name.isNotEmpty) {
              return name;
            }
          }
        }
      } catch (e) {
        // If extraction fails, return empty or message
      }
    }
    
    // Default fallback for transactions without a name
    if (trnstactionData.type == "increase") {
      return "Transaction";
    }
    
    return "";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionProvider = ref.watch(transcationHistoryProvider);
    final isLoading = transactionProvider.isTransactionLoading(trnstactionData.id);
    final isPending = trnstactionData.status == "pending" && 
                      trnstactionData.type == "decrease";
    final hasPayoutBatchId = trnstactionData.payoutBatchId != null && 
                             trnstactionData.payoutBatchId!.isNotEmpty;
    
    // Check if credits and tokens were used for this transaction
    // Check if the values are > 0 to determine what was actually used
    final creditAmt = trnstactionData.creditAmount;
    final tokenAmt = trnstactionData.tokenAmount;
    final hasCredits = creditAmt > 0;
    final hasTokens = tokenAmt > 0;
    final hasBoth = hasCredits && hasTokens;
    
    // Debug: Print transaction data to verify parsing
    print("=== Transaction Debug ===");
    print("Transaction ID: ${trnstactionData.id}");
    print("Type: ${trnstactionData.type}");
    print("creditAmount: $creditAmt (raw: ${trnstactionData.creditAmount}, type: ${trnstactionData.creditAmount.runtimeType})");
    print("tokenAmount: $tokenAmt (raw: ${trnstactionData.tokenAmount}, type: ${trnstactionData.tokenAmount.runtimeType})");
    print("token: ${trnstactionData.token}");
    print("balanceType: ${trnstactionData.balanceType}");
    print("hasCredits: $hasCredits");
    print("hasTokens: $hasTokens");
    print("hasBoth: $hasBoth");
    print("Message: ${trnstactionData.message}");
    print("=========================");

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(10.h),
          decoration: AppDecoration.outlineBlack.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder5,
          ),
          child: Opacity(
            opacity: isLoading ? 0.5 : 1.0,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.coinImage,
                  height: 38.adaptSize,
                  width: 38.adaptSize,
                  margin: EdgeInsets.only(bottom: 2.v),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 12.h,
                      top: 2.v,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: 205.h,
                                child: Text(
                                  // Show the transaction message from API
                                  trnstactionData.message,
                                  style: CustomTextStyles.titleMediumBlack900,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.h),
                            // Show badges for credits and tokens based on what was actually used
                            if (hasBoth) ...[
                              // Both credits and tokens used
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 2.v),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4.h),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "C: ${creditAmt.toInt()}",
                                  style: TextStyle(
                                    fontSize: 9.fSize,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 2.v),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4.h),
                                  border: Border.all(
                                    color: Colors.amber,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "T: ${tokenAmt.toInt()}",
                                  style: TextStyle(
                                    fontSize: 9.fSize,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.amber[700],
                                  ),
                                ),
                              ),
                            ] else if (hasCredits) ...[
                              // Only credits used
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.v),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4.h),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "Credits",
                                  style: TextStyle(
                                    fontSize: 10.fSize,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ),
                            ] else ...[
                              // Only tokens used (default)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.v),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4.h),
                                  border: Border.all(
                                    color: Colors.amber,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "Tokens",
                                  style: TextStyle(
                                    fontSize: 10.fSize,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.amber[700],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 2.v),
                        Row(
                          children: [
                            AutoSizeText(
                              Utils.formatTime(trnstactionData.createdAt!.toLocal()),
                              style: theme.textTheme.labelLarge,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6.h),
                              child: AutoSizeText(
                                Utils.formatNameDate(
                                    trnstactionData.createdAt!.toIso8601String()),
                                style: theme.textTheme.labelLarge,
                              ),
                            ),
                          ],
                        ),
                        // Show pending status message if status is pending (not success)
                        if (isPending)
                          Padding(
                            padding: EdgeInsets.only(top: 4.v),
                            child: SizedBox(
                              width: 205.h,
                              child: Text(
                                trnstactionData.message,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 11.fSize,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  height: 1.3, // Line height to ensure 2 lines spacing
                                ),
                              ),
                            ),
                          ),
                        // Show "Check Status" button for pending transactions with payoutBatchId
                        if (isPending && hasPayoutBatchId && !isLoading)
                          Padding(
                            padding: EdgeInsets.only(top: 6.v),
                            child: GestureDetector(
                              onTap: () {
                                ref.read(transcationHistoryProvider)
                                    .checkTransactionStatus(
                                      context, 
                                      trnstactionData.id,
                                      trnstactionData.payoutBatchId,
                                    );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.h,
                                  vertical: 4.v,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4.h),
                                ),
                                child: Text(
                                  "Check Status",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.fSize,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 8.h,
                    top: 12.v,
                    bottom: 10.v,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Show breakdown based on what was actually used
                      if (hasBoth) ...[
                        // Both credits and tokens used - show breakdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  trnstactionData.type == "decrease" ? "-" : "+",
                                  style: CustomTextStyles.titleMediumPrimaryBold.copyWith(
                                    color: isPending ? Colors.red : null,
                                  ),
                                ),
                                Text(
                                  "${creditAmt.toInt()}",
                                  style: CustomTextStyles.titleMediumPrimaryBold.copyWith(
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  "C",
                                  style: TextStyle(
                                    fontSize: 12.fSize,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  " + ",
                                  style: CustomTextStyles.titleMediumPrimaryBold.copyWith(
                                    color: isPending ? Colors.red : null,
                                  ),
                                ),
                                Text(
                                  "${tokenAmt.toInt()}",
                                  style: CustomTextStyles.titleMediumPrimaryBold.copyWith(
                                    color: Colors.amber[700],
                                  ),
                                ),
                                Text(
                                  "T",
                                  style: TextStyle(
                                    fontSize: 12.fSize,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.amber[700],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.v),
                            // For coach transactions (type="increase"), show what they received
                            // For student transactions (type="decrease"), show total paid
                            Text(
                              trnstactionData.type == "increase" && SharedPreferencesManager.getUserType() == Utils.coachType
                                ? "Received: ${trnstactionData.tokenAmount.toInt()}T"
                                : "Total: ${trnstactionData.token.toInt()}",
                              style: TextStyle(
                                fontSize: 10.fSize,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ] else if (hasCredits) ...[
                        // Only credits used
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${trnstactionData.type == "decrease" ? "-" : "+"}${creditAmt.toInt()}",
                              style: CustomTextStyles.titleMediumPrimaryBold.copyWith(
                                color: isPending ? Colors.red : Colors.blue[700],
                              ),
                            ),
                            SizedBox(height: 2.v),
                            Text(
                              "Credits",
                              style: TextStyle(
                                fontSize: 10.fSize,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Only tokens used (or legacy transactions)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${trnstactionData.type == "decrease" ? "-" : "+"}${trnstactionData.tokenAmount > 0 ? trnstactionData.tokenAmount.toInt() : trnstactionData.token.toInt()}",
                              style: CustomTextStyles.titleMediumPrimaryBold.copyWith(
                                color: isPending ? Colors.red : null,
                              ),
                            ),
                            SizedBox(height: 2.v),
                            Text(
                              "Tokens",
                              style: TextStyle(
                                fontSize: 10.fSize,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 13.h),

              ],
            ),
          ),
        ),
        // Show loader overlay when checking status
        if (isLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadiusStyle.roundedBorder5,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

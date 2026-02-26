import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/models/coach_model/LowStudentBalanceModel.dart';
import 'package:coach_student/models/coach_model/TranscationHistoryCoach.dart';
import 'package:coach_student/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../SharedPref/Shared_pref.dart';
import '../../models/CoachProfileDetailsModel.dart';
import '../../models/student_profile_model.dart';
import '../../services/api/api.dart';
import '../../services/api/configurl.dart';
import '../../services/api/dio.dart';

class TranscationHistoryNotifier extends ChangeNotifier {
  TranscationHistoryCoach transcationHistoryCoach =
      TranscationHistoryCoach(transaction: []);
  LowBalanceStudent lowBalanceStudent = LowBalanceStudent();
  bool isLoadingTranscation = false;
  int selectedIndex = 0;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Track loading state for individual transactions
  final Map<String, bool> _transactionLoadingStates = {};

  // Get loading state for a specific transaction
  bool isTransactionLoading(String transactionId) {
    return _transactionLoadingStates[transactionId] ?? false;
  }

  void changeIndex(int val) {
    selectedIndex = val;
    if (!_disposed) notifyListeners();
  }

  Future<void> getTranscationListCoach(
    BuildContext context,
  ) async {
    isLoadingTranscation = true;
    if (!_disposed) notifyListeners();

    final result = await DioApi.get(path: ConfigUrl.getTranscationHistory);

    if (_disposed) return;

    if (result.response != null) {
      await fetchCoachProfile();

      // Parse new transactions from API
      // Handle response wrapped in success object: { "success": true, "transaction": [...] }
      final responseData = result.response?.data;
      final transactionData = responseData is Map<String, dynamic> &&
              responseData.containsKey("transaction")
          ? {"transaction": responseData["transaction"]}
          : responseData;

      final newTransactionData =
          TranscationHistoryCoach.fromJson(transactionData);

      // Create a map of existing transactions by ID for quick lookup
      final Map<String, Transaction> existingTransactionsMap = {};
      for (var transaction in transcationHistoryCoach.transaction) {
        existingTransactionsMap[transaction.id] = transaction;
      }

      // Merge new transactions with existing ones
      final List<Transaction> mergedTransactions = [];

      for (var newTransaction in newTransactionData.transaction) {
        final existingTransaction = existingTransactionsMap[newTransaction.id];

        if (existingTransaction != null) {
          // Transaction exists - merge/update it with new data from API
          // Always prioritize new status from API if available
          mergedTransactions.add(
            existingTransaction.copyWith(
              message: newTransaction.message,
              transactionWith: newTransaction.transactionWith,
              type: newTransaction.type,
              token: newTransaction.token,
              createdAt: newTransaction.createdAt,
              updatedAt: newTransaction.updatedAt,
              v: newTransaction.v,
              payoutBatchId: newTransaction.payoutBatchId ??
                  existingTransaction.payoutBatchId,
              // Always use new status from API - this ensures pending -> success updates
              status: newTransaction.status ?? existingTransaction.status,
              childrenId:
                  newTransaction.childrenId ?? existingTransaction.childrenId,
            ),
          );

          // Remove from map to track which existing transactions are still present
          existingTransactionsMap.remove(newTransaction.id);
        } else {
          // New transaction - add it directly (includes status from API)
          mergedTransactions.add(newTransaction);
        }
      }

      // Keep transactions that exist locally but not in API response
      // This preserves transactions that might have been created locally
      for (var existingTransaction in existingTransactionsMap.values) {
        mergedTransactions.add(existingTransaction);
      }

      // Update the transaction list
      transcationHistoryCoach = TranscationHistoryCoach(
        transaction: mergedTransactions,
      );

      isLoadingTranscation = false;
      notifyListeners();
    } else {
      isLoadingTranscation = false;
      notifyListeners();
      result.handleError(context);
    }
  }

  // Add new method to check status for a specific transaction
  Future<void> checkTransactionStatus(
    BuildContext context,
    String transactionId,
    String? payoutBatchId,
  ) async {
    // Validate required parameters
    if (payoutBatchId == null || payoutBatchId.isEmpty) {
      Utils.toast(message: "Cannot check status: Missing payout batch ID");
      return;
    }

    // Set loading state for this specific transaction
    _transactionLoadingStates[transactionId] = true;
    if (!_disposed) notifyListeners();

    try {
      // Build URL with query parameters
      final url =
          "${ConfigUrl.withdrawStatus}?payoutBatchId=$payoutBatchId&transactionId=$transactionId";

      final result = await DioApi.get(path: url);

      if (_disposed) return;

      if (result.response != null && result.response?.data != null) {
        final responseData = result.response!.data;

        // Check if the response indicates success
        if (responseData['success'] == true &&
            responseData['payoutBatch'] != null) {
          final payoutBatch =
              responseData['payoutBatch'] as Map<String, dynamic>;
          final items = payoutBatch['items'] as List<dynamic>?;

          // Check transaction_status in items
          if (items != null && items.isNotEmpty) {
            final firstItem = items[0] as Map<String, dynamic>;
            final transactionStatus =
                firstItem['transaction_status'] as String?;

            // If transaction_status is "SUCCESS", update the transaction status
            String? newStatus;
            if (transactionStatus == "SUCCESS") {
              newStatus = "success";
            } else if (transactionStatus == "PENDING") {
              newStatus = "pending";
            } else {
              // Keep existing status for other states
              newStatus = null;
            }

            // Update the transaction in the list if status changed
            if (newStatus != null) {
              final updatedTransactions =
                  transcationHistoryCoach.transaction.map((t) {
                if (t.id == transactionId) {
                  return t.copyWith(
                    status: newStatus,
                  );
                }
                return t;
              }).toList();

              transcationHistoryCoach = TranscationHistoryCoach(
                transaction: updatedTransactions,
              );

              // Show success message if status changed to success
              if (newStatus == "success") {
                Utils.toast(message: "Withdrawal completed successfully!");
              }
            }
          }
        }

        // Clear loading state
        _transactionLoadingStates[transactionId] = false;
        if (!_disposed) notifyListeners();
      } else {
        // Clear loading state on error
        _transactionLoadingStates[transactionId] = false;
        if (!_disposed) notifyListeners();
        result.handleError(context);
      }
    } catch (e) {
      // Clear loading state on exception
      _transactionLoadingStates[transactionId] = false;
      if (!_disposed) notifyListeners();
      logger.e("Error checking transaction status: $e");
      Utils.toast(message: "Failed to check status. Please try again.");
    }
  }

  Future<void> getLowBalance(
    BuildContext context,
  ) async {
    isLoadingTranscation = true;
    if (!_disposed) notifyListeners();
    final result = await DioApi.get(path: ConfigUrl.getLowBalanceStudent);

    if (_disposed) return;

    if (result.response != null) {
      lowBalanceStudent = LowBalanceStudent.fromJson(result.response?.data);

      isLoadingTranscation = false;
      if (!_disposed) notifyListeners();
    } else {
      isLoadingTranscation = false;
      if (!_disposed) notifyListeners();
      result.handleError(context);
    }
  }

  Future<void> deletePendingBalance(BuildContext context, String id) async {
    isLoadingTranscation = true;
    if (!_disposed) notifyListeners();
    String finalUrl = ConfigUrl.deleteBalanceStudent + id;
    final result = await DioApi.get(path: finalUrl);

    if (_disposed) return;

    if (result.response != null) {
      getLowBalance(context);

      isLoadingTranscation = false;
      if (!_disposed) notifyListeners();
    } else {
      isLoadingTranscation = false;
      if (!_disposed) notifyListeners();
      result.handleError(context);
    }
  }

  Future<void> collectFeeFromOwedStudent(
    BuildContext context, {
    required String studentId,
    required String classScheduleId,
    required int classFees,
    required String pendingBalanceId,
  }) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);

    try {
      // Delete from pending balance list - this endpoint already creates the transaction
      String deleteUrl = ConfigUrl.deleteBalanceStudent + pendingBalanceId;
      Result result = await DioApi.delete(path: deleteUrl);

      if (result.response != null) {
        // Refresh data - check if context is still mounted before using it
        if (context.mounted) {
          await getLowBalance(context);
          await getTranscationListCoach(context);
        }
        await fetchCoachProfile();

        EasyLoading.dismiss();

        // Check if context is still mounted before showing dialog
        if (context.mounted) {
          await Dialogs.showSuccessDialog(
            context,
            title: 'Payment Collected',
            subtitle: 'Successfully collected $classFees tokens from student',
          );
        } else {
          // If context is not mounted, just show toast
          Utils.toast(
              message: 'Successfully collected $classFees tokens from student');
        }
      } else {
        EasyLoading.dismiss();
        if (context.mounted) {
          result.handleError(context);
        } else {
          Utils.toast(message: "Failed to collect payment. Please try again.");
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      logger.e("Error collecting fee from owed student: $e");
      if (context.mounted) {
        Utils.toast(message: "An error occurred. Please try again.");
      }
    }
  }

  CoachProfileDetailsModel coachProfileDetailsModel =
      CoachProfileDetailsModel();

  StudentProfileModel studentProfileModel = StudentProfileModel();
  // bool isLoadingProfile = false;
  Future<void> fetchCoachProfile() async {
    // isLoadingProfile = true;
    isLoadingTranscation = true;

    if (!_disposed) notifyListeners();
    final userType = SharedPreferencesManager.getUserType();

    Result result = await DioApi.get(
        path: userType == Utils.coachType
            ? ConfigUrl.cachProfileGet
            : ConfigUrl.studentProfile);

    if (_disposed) return;

    if (result.response != null) {
      userType == Utils.coachType
          ? coachProfileDetailsModel =
              CoachProfileDetailsModel.fromJson(result.response?.data)
          : studentProfileModel =
              StudentProfileModel.fromJson(result.response?.data);
      // SharedPreferencesManager.clearCoachProfile();
      // SharedPreferencesManager.saveCoachProfile(coachProfileDetailsModel);
      isLoadingTranscation = false;

      // isLoadingProfile = false;
      if (!_disposed) notifyListeners();
    } else {
      isLoadingTranscation = false;

      // isLoadingProfile = false;
      if (!_disposed) notifyListeners();
    }
  }

  bool isLoading = false;

  Future<void> withdrawMoney(BuildContext context,
      {required int amount}) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);

    try {
      Result result =
          await DioApi.post(path: ConfigUrl.paypalWithdrawAmount, data: {
        "token": amount,
      });

      if (result.response != null) {
        fetchCoachProfile();
        // Refresh transaction list to show the new withdrawal transaction
        await getTranscationListCoach(context);
        EasyLoading.dismiss();
        Utils.toast(message: "Withdraw Successful!!");
      } else {
        EasyLoading.dismiss();

        // Check if there's a DioException with response data
        if (result.dioError != null &&
            result.dioError!.response != null &&
            result.dioError!.response!.data != null) {
          // Check if the error response contains httpStatusCode: 200 in batch
          final responseData = result.dioError!.response!.data;

          // Handle Map response
          if (responseData is Map<String, dynamic>) {
            // Check for httpStatusCode: 200 in the batch object
            if (responseData['batch'] != null &&
                responseData['batch'] is Map<String, dynamic>) {
              final batch = responseData['batch'] as Map<String, dynamic>;
              final httpStatusCode = batch['httpStatusCode'];

              if (httpStatusCode == 200) {
                // PayPal payout was created successfully (pending status)
                fetchCoachProfile(); // Refresh profile to update balance
                // Refresh transaction list to show the new pending withdrawal transaction
                await getTranscationListCoach(context);

                Dialogs.showSuccessDialog(
                  context,
                  title: "Payment Pending",
                  subtitle:
                      "Your withdrawal request has been submitted and is pending. Please check your PayPal account.",
                );
                return; // Exit early, don't show error
              }
            }
          }
        }

        // If we reach here, it's a real error
        result.handleError(context);
      }
    } catch (e) {
      // Ensure loader is dismissed even if there's an unexpected error
      EasyLoading.dismiss();
      logger.e("Unexpected error in withdrawMoney: $e");
      Dialogs.errorDialog(
          context, "An unexpected error occurred. Please try again.");
    }
  }
}

final transcationHistoryProvider =
    ChangeNotifierProvider.autoDispose<TranscationHistoryNotifier>((ref) {
  return TranscationHistoryNotifier();
});

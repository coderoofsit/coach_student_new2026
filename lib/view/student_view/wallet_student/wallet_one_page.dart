import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/coach/TranscationHistoryProvider.dart';
import '../../../widgets/wallet_low_balance_page/widgets/walletlowbalance_item_widget.dart';

// ignore_for_file: must_be_immutable
class WalletOnePage extends ConsumerStatefulWidget {
  const WalletOnePage({Key? key})
      : super(
          key: key,
        );

  @override
  WalletOnePageConsumerState createState() => WalletOnePageConsumerState();
}

class WalletOnePageConsumerState extends ConsumerState<WalletOnePage>
    with AutomaticKeepAliveClientMixin<WalletOnePage> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    // Use transaction history provider instead of payments provider
    final transcationHistoryCoach = ref.watch(
      transcationHistoryProvider.select(
        (value) => value.transcationHistoryCoach,
      ),
    );

    // Filter for 'decrease' type transactions (Used Funds)
    final usedFundsTransactions = transcationHistoryCoach.transaction
        .where((t) => t.type == 'decrease')
        .toList();

    return SafeArea(
      child: Scaffold(
        body: ref.watch(
          transcationHistoryProvider.select(
            (value) => value.isLoadingTranscation,
          ),
        )
            ? Utils.progressIndicator
            : usedFundsTransactions.isEmpty
                ? Center(
                    child: Text(
                      "No funds used yet",
                      style: CustomTextStyles.titleLargeBold,
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(
                    width: double.maxFinite,
                    decoration: AppDecoration.fillOnErrorContainer,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: ListView.separated(
                        // physics: const NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        separatorBuilder: (
                          context,
                          index,
                        ) {
                          return SizedBox(
                            height: 15.v,
                          );
                        },
                        itemCount: usedFundsTransactions.length,
                        itemBuilder: (context, index) {
                          final transactionData = usedFundsTransactions[index];
                          // Reuse WalletlowbalanceItemWidget which has logic for credits/tokens display
                          return WalletlowbalanceItemWidget(
                            trnstactionData: transactionData,
                          );
                        },
                      ),
                    ),
                  ),
      ),
    );
  }
}

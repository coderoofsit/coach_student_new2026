import 'package:coach_student/provider/coach/TranscationHistoryProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../wallet_low_balance_page/widgets/walletlowbalance_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';

// ignore_for_file: must_be_immutable
class WalletLowBalancePage extends ConsumerStatefulWidget {
  const WalletLowBalancePage({Key? key})
      : super(
          key: key,
        );

  @override
  WalletLowBalancePageConsumerState createState() =>
      WalletLowBalancePageConsumerState();
}

class WalletLowBalancePageConsumerState
    extends ConsumerState<WalletLowBalancePage>
    with AutomaticKeepAliveClientMixin<WalletLowBalancePage> {
  // @override
  // void initState() {
  //   super.initState();

  // }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    mediaQueryData = MediaQuery.of(context);
    final transtData = ref.watch(transcationHistoryProvider
        .select((value) => value.transcationHistoryCoach));
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillOnErrorContainer,
          child: Column(
            children: [
              SizedBox(height: 19.v),
              if (transtData.transaction.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      "no transaction history at this time",
                      style: CustomTextStyles.titleLargeBold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.h),
                    child: ListView.separated(
                      // physics: const NeverScrollableScrollPhysics(),
                      // shrinkWrap: true,
                      separatorBuilder: (
                        context,
                        index,
                      ) {
                        return SizedBox(
                          height: 12.v,
                        );
                      },
                      itemCount: transtData.transaction.length,
                      itemBuilder: (context, index) {
                        final data = transtData.transaction[index];
                        // Show all transactions, even if transactionWith is null
                        // (e.g., purchase transactions where 'with' might be null)
                        return WalletlowbalanceItemWidget(
                          trnstactionData: data,
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

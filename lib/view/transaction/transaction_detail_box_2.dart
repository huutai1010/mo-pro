import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/const/const.dart';
import 'package:etravel_mobile/models/transaction_detail.dart';
import 'package:etravel_mobile/view/transaction/transaction_row_text.dart';
import 'package:flutter/material.dart';

class TransactionDetailBox2 extends StatelessWidget {
  final TransactionItem transactionData;
  const TransactionDetailBox2({
    super.key,
    required this.transactionData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 5.0,
            offset: Offset(0.0, 0.5),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...generateRowItem(
            spacing: 20,
            Text(context.tr('payment_account_id'), style: titleTextStyle),
            RowText(
              transactionData.details.paymentAccountId?.toString() ?? '---',
            ),
          ),
          ...generateRowItem(
            spacing: 20,
            Text(context.tr('payment_id'), style: titleTextStyle),
            RowText(
              transactionData.details.paymentId?.toString() ?? '---',
            ),
          ),
          ...generateRowItem(
            Text(context.tr('capture_id'), style: titleTextStyle),
            RowText(
              transactionData.details.captureId?.toString() ?? '---',
            ),
          ),
        ],
      ),
    );
  }
}

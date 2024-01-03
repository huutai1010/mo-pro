import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/const/const.dart';
import 'package:etravel_mobile/models/transaction_detail.dart';
import 'package:etravel_mobile/res/colors/app_color.dart';
import 'package:etravel_mobile/view/transaction/transaction_detail_header_price_container.dart';
import 'package:flutter/material.dart';

import 'transaction_row_text.dart';

class TransactionDetailBox1 extends StatelessWidget {
  const TransactionDetailBox1({
    super.key,
    required this.transactionData,
  });
  final TransactionItem transactionData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
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
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TransactionDetailBox1PriceContainer(data: transactionData),
              const SizedBox(
                height: 15,
              ),
              ...generateRowDataUpperBox(context, transactionData),
            ],
          ),
          const Divider(
            color: Colors.red,
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: generateRowDataPayment(context, transactionData),
          ),
        ],
      ),
    );
  }
}

List<Widget> generateRowDataPayment(
    BuildContext ctx, TransactionItem transactionData) {
  return [
    ...generateRowItem(
        Text(ctx.tr('transaction_id'), style: titleTextStyle),
        RowText(
          transactionData.id.toString(),
        ),
        spacing: 20),
    ...generateRowItem(
        Text(ctx.tr('total'), style: titleTextStyle),
        RowText(
          transactionData.amount.toStringAsFixed(2),
        ),
        spacing: 20),
    ...generateRowItem(
        Text(ctx.tr('currency'), style: titleTextStyle),
        RowText(
          transactionData.details.currency,
        ),
        spacing: 20),
    ...generateRowItem(
      Text(ctx.tr('payment_method'), style: titleTextStyle),
      RowText(
        transactionData.paymentMethod,
      ),
    ),
  ];
}

List<Widget> generateRowDataUpperBox(
    BuildContext ctx, TransactionItem transactionData) {
  return [
    ...generateRowItem(
      Text(
        ctx.tr('status'),
        style: titleTextStyle,
      ),
      Text(
        ctx.tr(transactionData.statusName.toLowerCase()),
        textAlign: TextAlign.right,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
          fontSize: 18,
        ),
      ),
      spacing: 20,
    ),
    ...generateRowItem(
      spacing: 20,
      Text(ctx.tr('booking_id'), style: titleTextStyle),
      RowText(
        transactionData.bookingId.toString(),
      ),
    ),
    ...generateRowItem(
      spacing: 20,
      Text(ctx.tr('create_time'), style: titleTextStyle),
      RowText(
        overflow: TextOverflow.clip,
        DateFormat(kDateTimeFormat).format(transactionData.createTime!),
      ),
    ),
    if (transactionData.updateTime != null)
      ...generateRowItem(
        spacing: 10,
        Text(ctx.tr('payment_time'), style: titleTextStyle),
        RowText(
          overflow: TextOverflow.clip,
          DateFormat(kDateTimeFormat).format(transactionData.updateTime!),
        ),
      ),
  ];
}

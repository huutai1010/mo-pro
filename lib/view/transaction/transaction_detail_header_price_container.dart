import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/transaction_detail.dart';
import 'package:flutter/material.dart';

import '../../const/const.dart';

class TransactionDetailBox1PriceContainer extends StatelessWidget {
  const TransactionDetailBox1PriceContainer({
    super.key,
    required this.data,
  });

  final TransactionItem data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              data.amount.toStringAsFixed(2),
              style: titleTextStyle.copyWith(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              context.tr('payment'),
              style: titleTextStyle,
            ),
          ],
        )
      ],
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../services/local_storage_service.dart';
import 'transaction_header_item.dart';

class TransactionHeader extends StatelessWidget {
  const TransactionHeader({
    super.key,
    required this.totalTransactions,
  });
  final int totalTransactions;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      // color: Colors.grey,
      width: double.infinity,
      height: 70,
      child: FutureBuilder(
        future: LocalStorageService.getInstance.getAccount(),
        builder: (ctx, snapshot) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TransactionHeaderItem(
                content:
                    '${snapshot.data?.firstName} ${snapshot.data?.lastName}',
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: snapshot.data?.image != null
                        ? Colors.transparent
                        : Colors.grey,
                    image: snapshot.data?.image != null
                        ? DecorationImage(
                            image: NetworkImage(snapshot.data?.image ?? ''),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TransactionHeaderItem(
                content: context.tr('transactions'),
                icon: Text(
                  totalTransactions.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

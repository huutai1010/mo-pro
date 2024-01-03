import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/repository/transaction_repository.dart';
import 'package:etravel_mobile/view/common/common_app_bar.dart';
import 'package:flutter/material.dart';

import '../../models/transaction_detail.dart';
import 'transaction_detail_box_2.dart';
import 'transaction_detail_box_1.dart';

class TransactionDetailView extends StatelessWidget {
  final int transactionId;
  const TransactionDetailView({
    required this.transactionId,
    super.key,
  });

  Future<TransactionItem> _fetchTransactionData() async {
    try {
      final responseData =
          await TransactionRepository().getTransaction(transactionId);
      final data = TransactionItem.fromJson(responseData['transaction']);
      return data;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text(
          context.tr('payment_detail'),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(),
      ),
      body: FutureBuilder(
        future: _fetchTransactionData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TransactionDetailBox1(transactionData: data),
                const SizedBox(
                  height: 10,
                ),
                TransactionDetailBox2(transactionData: data)
              ],
            ),
          );
        },
      ),
    );
  }
}

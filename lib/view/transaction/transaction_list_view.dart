import 'package:etravel_mobile/view/transaction/transaction_detail_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../models/transaction_overview.dart';
import 'package:flutter/material.dart';
import '../widgets/transaction_item.dart';

class TransactionListView extends StatelessWidget {
  final PagingController<int, TransactionOverview> pagingController;
  const TransactionListView({
    required this.pagingController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ), //BoxShadow
        ],
      ),
      child: PagedListView<int, TransactionOverview>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<TransactionOverview>(
          itemBuilder: (ctx, item, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(ctx).push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                        TransactionDetailView(transactionId: item.id!),
                  ),
                );
              },
              child: TransactionItem(
                transaction: item,
              ),
            );
          },
        ),
      ),
    );
  }
}

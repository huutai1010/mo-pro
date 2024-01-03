import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/transaction_overview.dart';
import 'package:etravel_mobile/repository/transaction_repository.dart';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../common/common_app_bar.dart';
import 'transaction_header.dart';
import 'transaction_list_view.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  bool _isInit = true;
  int _total = 0;
  static const _pageSize = 10;

  final PagingController<int, TransactionOverview> _pagingController =
      PagingController(firstPageKey: 0);
  Future<void> _getTransaction(int pageKey) async {
    try {
      final response =
          await TransactionRepository().getTransactions(pageKey, _pageSize);
      if (_isInit) {
        setState(() {
          _total = response['transactions']['totalCount'] as int;
          _isInit = false;
        });
      }
      final responseData = (response['transactions']['data'] as List<dynamic>)
          .map((responseItem) {
        return TransactionOverview.fromJson(responseItem);
      }).toList();
      final isLastPage = responseData.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(responseData);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(responseData, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _getTransaction(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: Text(
          context.tr('transactions'),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(),
      ),
      body: Column(
        children: [
          TransactionHeader(
            totalTransactions: _total,
          ),
          Expanded(
            child: TransactionListView(
              pagingController: _pagingController,
            ),
          ),
        ],
      ),
    );
  }
}

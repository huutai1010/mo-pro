import '../res/strings/app_url.dart';

import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';

class TransactionRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getTransactions(int pageKey, int pageSize) async {
    try {
      print(pageKey);
      dynamic response = await _apiServices.getGetApiResponseAuth(
          '${AppUrl.getTransactionsEndpoint}?pagesize=$pageSize&pagenumber=$pageKey');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTransaction(int transactionId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponseAuth(
          '${AppUrl.getTransactionsEndpoint}/$transactionId');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

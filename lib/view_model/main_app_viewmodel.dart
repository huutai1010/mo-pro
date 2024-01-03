import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/repository/auth_repository.dart';
import 'package:etravel_mobile/services/local_storage_service.dart';
import 'package:etravel_mobile/services/secure_storage_service.dart';
import 'package:etravel_mobile/utils/utils.dart';
import 'package:etravel_mobile/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/language.dart';

class MainAppViewModel extends ChangeNotifier {
  Language? selectedLanguage;
  int id;
  String code;
  bool isLoading = false;
  MainAppViewModel({
    required this.id,
    required this.code,
  });

  void onLanguageSelected(BuildContext ctx, Language language) async {
    selectedLanguage = language;
    id = language.id!;
    code = language.languageCode!;
    notifyListeners();
    final newLocale = Utils.getLanguageCodeToLocalize(language.languageCode!);
    await ctx.setLocale(newLocale);
  }

  Future<void> changeLanguage(BuildContext ctx) {
    String? newAccessToken;
    return AuthRepository().changeLanguageApi(id).then((value) {
      newAccessToken = value['account']['accessToken'];
      return SecureStorageService.getInstance
          .writeSecureAcessToken(newAccessToken!);
    }).then((_) {
      return LocalStorageService.getInstance.getAccount();
    }).then((account) {
      account!.accessToken = newAccessToken!;
      account.languageCode = selectedLanguage!.languageCode;
      final authVm = Provider.of<AuthViewModel>(ctx, listen: false);
      authVm.socket.emit('change-language', {
        'id': account.id,
        'languageCode': account.languageCode,
      });
      return LocalStorageService.getInstance.saveAccountInfo(account);
    }).then((value) {
      id = selectedLanguage!.id!;
      code = selectedLanguage!.languageCode!;
      notifyListeners();
    });
  }
}

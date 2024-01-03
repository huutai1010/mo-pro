import 'dart:async';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:etravel_mobile/services/callkit_service.dart';
import 'package:etravel_mobile/view/auth/login_view.dart';
import 'package:etravel_mobile/view_model/auth_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:provider/provider.dart';
import '../services/local_storage_service.dart';
import '../services/secure_storage_service.dart';
import 'package:flutter/material.dart';

class ProfileViewModel with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  StreamSubscription<CallEvent?>? streamSubscription;
  bool allowSearch = true;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void toggleSearch(BuildContext ctx, bool status) async {
    final existingAccountData =
        await LocalStorageService.getInstance.getAccount();
    if (ctx.mounted) {
      final authVm = Provider.of<AuthViewModel>(ctx, listen: false);
      authVm.socket.emit('switch', {
        'id': existingAccountData!.id,
        'allowSearch': status,
      });
      allowSearch = status;
      notifyListeners();
    }
  }

  Future logout(BuildContext profileViewContext) async {
    if (streamSubscription != null) {
      CallkitService().closeCallkit(streamSubscription!);
    }
    await FirebaseAuth.instance.signOut();
    await SecureStorageService.getInstance.clearAccessToken();

    final existingAccountData =
        await LocalStorageService.getInstance.getAccount();
    ChatClient.getInstance.chatManager
        .removeEventHandler("chat_notification_${existingAccountData!.id}");
    await ChatClient.getInstance.logout();
    await LocalStorageService.getInstance.removeAccountData().then(
      (value) {
        final authProvider =
            Provider.of<AuthViewModel>(profileViewContext, listen: false);
        authProvider.disconnectSocket();
        authProvider.isAlreadyLoggedIn = false;

        return Navigator.pushAndRemoveUntil(
          profileViewContext,
          MaterialPageRoute(
            builder: (_) => const LoginView(),
          ),
          (route) => false,
        );
      },
    );
  }
}

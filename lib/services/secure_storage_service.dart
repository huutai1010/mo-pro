import '../data/app_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  static SecureStorageService getInstance = SecureStorageService();

  Future writeSecureAcessToken(String accessToken) async {
    await storage.write(key: 'accessToken', value: accessToken);
  }

  writeSecureFCMToken(String fcmToken) async {
    await storage.write(key: 'fcmToken', value: fcmToken);
  }

  Future<String?> readSecureAccessToken() async {
    String? accessToken;
    await storage.read(key: 'accessToken').then((value) => accessToken = value);
    return accessToken;
  }

  Future clearAccessToken() async {
    await storage.delete(key: 'accessToken');
  }

  Future clearFCMToken() async {
    await storage.delete(key: 'fcmToken');
  }

  Future<String?> readSecureFCMToken() async {
    String? fcmToken;
    await storage.read(key: 'fcmToken').then((value) => fcmToken = value);
    if (fcmToken == null) {
      throw NotFoundDeviceTokenException('Your device token not found!');
    } else {
      // loggerInfo
      //     .i('Get fcmToken from storage = ${fcmToken?.substring(0, 20)}...');
    }
    return fcmToken;
  }
}

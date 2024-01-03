// Dart imports:
import 'dart:async';
import 'dart:io';
import 'package:etravel_mobile/main_app.dart';
import 'package:etravel_mobile/services/callkit_service.dart';
import 'package:etravel_mobile/view/loading/loading_view.dart';
import 'package:etravel_mobile/view_model/audio_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:etravel_mobile/view/language/choose_language_view.dart';
import 'api/dev_http_override.dart';
import 'configs/agora_options.dart';
import 'configs/firebase_options.dart';
import 'helper/custom_asset_loader.dart';
import 'res/colors/app_color.dart';
import 'services/logger_service.dart';
import 'services/notification_service.dart';
import 'services/secure_storage_service.dart';
import 'view_model/auth_viewmodel.dart';
import 'view_model/language_viewmodel.dart';
import 'view_model/main_app_viewmodel.dart';
import 'view_model/profile_viewmodel.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
final notificationService = NotificationService();
final callkitService = CallkitService();

Future<void> _firebaseMessagingBackgroundHandler(message) async {
  loggerInfo.i('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  loggerInfo.i('eTravel mobile');
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (kDebugMode) {
    HttpOverrides.global = DevHttpOverride();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  if (fcmToken != null) {
    SecureStorageService.getInstance.writeSecureFCMToken(fcmToken);
  }
  // Initialize Agora
  await ChatClient.getInstance.init(
    ChatOptions(
      appKey: AgoraChatConfig.appKey,
      autoLogin: false,
      requireAck: true,
      isAutoDownloadThumbnail: false,
    ),
  );
  try {
    await notificationService.ensurePermissionsGranted();
  } on PlatformException {
    // library failed to initialize, check code and message
  }
  final app = EasyLocalization(
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('en', 'GB'),
      Locale('fr'),
      Locale('ko'),
      Locale('ru'),
      Locale('th'),
      Locale('tr'),
      Locale('vi'),
      Locale('ja'),
      Locale('zh', 'CN'),
    ],
    fallbackLocale: const Locale('en', 'US'),
    assetLoader: CustomAssetLoader(),
    path: 'placeholder',
    child: const MyApp(),
  );
  Provider.debugCheckInvalidValueType = null;
  runApp(app);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => MainAppViewModel(
            id: 3,
            code: 'en-us',
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LanguageViewModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProfileViewModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AudioViewModel(),
        )
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        navigatorKey: navigatorKey,
        title: 'eTravel',
        theme: ThemeData(
          colorScheme: theme.colorScheme.copyWith(
            primary: AppColors.primaryColor,
          ),
        ),
        home: Consumer<AuthViewModel>(builder: (ctx, authVm, _) {
          return FutureBuilder(
            future: authVm.autoLogin(ctx),
            builder: (c, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingView(
                  title: 'Logging in...',
                );
              }
              final isAlreadyLoggedIn = authVm.isAlreadyLoggedIn;
              if (isAlreadyLoggedIn) {
                return const MainApp();
              }
              return const ChooseLanguageView();
            },
          );
        }),
        // home: const ChooseLanguageView(),
      ),
    );
  }
}
